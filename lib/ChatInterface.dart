import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'gemini_service.dart';

class ChatInterface extends StatefulWidget {
  const ChatInterface({super.key});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface>
    with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "مرحباً يا صديقي! 👋 أنا أرنوب! ماذا تريد أن نفعل اليوم؟ ✨",
      isBot: true,
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showEmojiPicker = false;
  bool _showSuggestions = true;

  late AnimationController _bubbleController;
  late AnimationController _sparkleController;
  late AnimationController _typingController;
  late Animation<double> _bubbleAnimation;

  String _arnobState = "happy";

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _sparkleController.dispose();
    _typingController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send([String? customText]) async {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isBot: false));
      _controller.clear();
      _isLoading = true;
      _showSuggestions = false;
      _arnobState = "thinking";
    });

    _scrollDown();
    _typingController.repeat();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _arnobState = "writing");

      final reply = await GeminiService.getReply(text);

      setState(() {
        _messages.add(ChatMessage(text: reply, isBot: true));
        _arnobState = "happy";
      });
    } catch (_) {
      setState(() {
        _messages.add(ChatMessage(
          text: "أوه لا! 😥 صار خطأ صغير. نجربو مرة أخرى!",
          isBot: true,
        ));
        _arnobState = "happy";
      });
    } finally {
      setState(() => _isLoading = false);
      _typingController.stop();
      _scrollDown();
    }
  }

  void _sendQuickSuggestion(String text) {
    _send(text);
  }

  void _insertEmoji(String emoji) {
    _controller.text += emoji;
    setState(() {});
  }

  String _getArnobEmoji() {
    switch (_arnobState) {
      case "thinking":
        return "🤔";
      case "writing":
        return "✍️";
      case "searching":
        return "🔍";
      default:
        return "🐰";
    }
  }

  String _getArnobStatus() {
    switch (_arnobState) {
      case "thinking":
        return "أرنوب يفكر...";
      case "writing":
        return "أرنوب يكتب...";
      case "searching":
        return "أرنوب يبحث...";
      default:
        return "أرنوب متصل";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _messages.length) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            final clampedValue = value.clamp(0.0, 1.0);
                            return Transform.scale(
                              scale: 0.8 + (clampedValue * 0.2),
                              child: Opacity(
                                opacity: clampedValue,
                                child: ChatMessageWidget(
                                    message: _messages[index]),
                              ),
                            );
                          },
                        );
                      } else {
                        return _buildTypingIndicator();
                      }
                    },
                  ),
                ),
                if (_showSuggestions && !_isLoading) _buildQuickSuggestions(),
                if (_showEmojiPicker) _buildEmojiPicker(),
                _buildInputArea(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bubbleAnimation.value * 0.3),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Text(
                      _getArnobEmoji(),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أرنوب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getArnobStatus(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.5 + (_sparkleController.value * 0.5),
                  child: const Text('✨', style: TextStyle(fontSize: 20)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    final suggestions = [
      {
        'text': 'ساعدني في الواجب',
        'emoji': '📚',
        'gradient': [Color(0xFFFFB3D9), Color(0xFFFFCCE5)]
      },
      {
        'text': 'العب معي',
        'emoji': '🎮',
        'gradient': [Color(0xFFB3E0F2), Color(0xFFCCEBF7)]
      },
      {
        'text': 'اقرأ لي قصة',
        'emoji': '📖',
        'gradient': [Color(0xFFFFF4A3), Color(0xFFFFF9C4)]
      },
      {
        'text': 'تمارين رياضيات',
        'emoji': '🧮',
        'gradient': [Color(0xFFA5D6A7), Color(0xFFBDE6BF)]
      },
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 30 * (1 - clampedValue)),
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(
            top: BorderSide(
              color: const Color(0xFFFFB3D9).withOpacity(0.3),
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'اقتراحات سريعة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5C546A),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => _showSuggestions = false),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close,
                        size: 18, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: suggestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final suggestion = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildSuggestionChip(
                      suggestion['text']! as String,
                      suggestion['emoji']! as String,
                      suggestion['gradient']! as List<Color>,
                      index,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(
      String text, String emoji, List<Color> colors, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: 0.8 + (clampedValue * 0.2),
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: InkWell(
        onTap: () => _sendQuickSuggestion(text),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5C546A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = [
      '😊',
      '😂',
      '❤️',
      '👍',
      '🎉',
      '⭐',
      '🌟',
      '✨',
      '🎈',
      '🎁',
      '🌈',
      '🦄',
      '🐰',
      '🦊',
      '🐻',
      '🐼',
      '🍕',
      '🍰',
      '🎂',
      '🍦',
      '🍓',
      '🍎',
      '🌺',
      '🌸',
      '⚽',
      '🎮',
      '🎨',
      '🎭',
      '🎪',
      '🎯',
      '🏆',
      '🎓',
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 200 * (1 - clampedValue)),
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF5F9), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border.all(
            color: const Color(0xFFFFB3D9).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('😊', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'اختر إيموجي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5C546A),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => _showEmojiPicker = false),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 200 + (index * 20)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      final clampedValue = value.clamp(0.0, 1.0);
                      return Transform.scale(
                        scale: 0.5 + (clampedValue * 0.5),
                        child: Opacity(opacity: clampedValue, child: child),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _insertEmoji(emojis[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE8F3), Color(0xFFFFF5F9)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFB3D9).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emojis[index],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(
          color: const Color(0xFFFFB3D9).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _showEmojiPicker = !_showEmojiPicker),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: _showEmojiPicker
                      ? const LinearGradient(
                          colors: [Color(0xFFFFE8F3), Color(0xFFFFCCE5)],
                        )
                      : null,
                  color: _showEmojiPicker ? null : Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _showEmojiPicker
                        ? const Color(0xFFFFB3D9)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: const Text('😊', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF5F9), Color(0xFFFFE8F3)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFFFB3D9).withOpacity(0.6),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: Color(0xFF5C546A),
                  ),
                  decoration: InputDecoration(
                    hintText: "اكتب رسالتك... 💬",
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (!_showSuggestions)
              GestureDetector(
                onTap: () => setState(() => _showSuggestions = true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFFF6B9D),
                    size: 20,
                  ),
                ),
              ),
            const SizedBox(width: 10),
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D)
                            .withOpacity(0.3 + _sparkleController.value * 0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _send(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF5F9),
            Color(0xFFFFE8F3),
            Color(0xFFE3F2FD),
            Color(0xFFFFFDE7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AnimatedBuilder(
        animation: _bubbleAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: 100 + _bubbleAnimation.value,
                left: 30,
                child: _buildCircle(80, const Color(0xFFFFB3D9), 0.25),
              ),
              Positioned(
                top: 180 - _bubbleAnimation.value,
                right: 50,
                child: _buildCircle(60, const Color(0xFFB3E0F2), 0.3),
              ),
              Positioned(
                bottom: 250 + _bubbleAnimation.value,
                left: 40,
                child: _buildCircle(70, const Color(0xFFFFF59D), 0.25),
              ),
              Positioned(
                bottom: 180 - _bubbleAnimation.value,
                right: 30,
                child: _buildCircle(65, const Color(0xFFA5D6A7), 0.25),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCircle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFFFB3D9).withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _bouncingDot(0),
                _bouncingDot(200),
                _bouncingDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bouncingDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        // Animation de rebond simple sans sin
        final bounce =
            clampedValue < 0.5 ? clampedValue * 2 : (1 - clampedValue) * 2;
        final offset = -6 * bounce;

        return Transform.translate(
          offset: Offset(0, offset.clamp(-6.0, 0.0)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          Future.delayed(Duration(milliseconds: delayMs), () {
            if (mounted) setState(() {});
          });
        }
      },
    );
  }
}

// Widget pour afficher un message
class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isBot ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: message.isBot
              ? const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFF5F9)],
                )
              : const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: message.isBot
                ? const Radius.circular(20)
                : const Radius.circular(5),
            bottomRight: message.isBot
                ? const Radius.circular(5)
                : const Radius.circular(20),
          ),
          border: Border.all(
            color: message.isBot
                ? const Color(0xFFFFB3D9).withOpacity(0.6)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (message.isBot
                      ? const Color(0xFFFF6B9D)
                      : const Color(0xFFFF6B9D))
                  .withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: message.isBot ? const Color(0xFF5C546A) : Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
