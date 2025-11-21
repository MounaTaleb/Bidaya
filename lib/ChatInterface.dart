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

  // États contextuels d'Arnob
  String _arnobState = "happy"; // happy, thinking, writing, searching

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
        return "أرنوب";
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
                // Header avec indicateur contextuel
                _buildHeader(),

                // Messages
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
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            final clampedValue = value.clamp(0.0, 1.0);
                            return Transform.scale(
                              scale: clampedValue,
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

                // Suggestions rapides
                if (_showSuggestions && !_isLoading) _buildQuickSuggestions(),

                // Barre d'emojis
                if (_showEmojiPicker) _buildEmojiPicker(),

                // Input
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            // Avatar avec animation et état contextuel
            AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bubbleAnimation.value * 0.3),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      _getArnobEmoji(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أرنوب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                // Indicateur d'état
                if (_isLoading)
                  Text(
                    _getArnobStatus(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                final opacity =
                    (0.5 + (_sparkleController.value * 0.5)).clamp(0.0, 1.0);
                return Opacity(
                  opacity: opacity,
                  child: const Text(
                    '✨',
                    style: TextStyle(fontSize: 18),
                  ),
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
      {'text': 'ساعدني في الواجب', 'emoji': '📚'},
      {'text': 'العب معي', 'emoji': '🎮'},
      {'text': 'اقرأ لي قصة', 'emoji': '📖'},
      {'text': 'تمارين رياضيات', 'emoji': '🧮'},
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Opacity(
            opacity: clampedValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
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
                Text(
                  'اقتراحات سريعة ⚡',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showSuggestions = false),
                  child:
                      Icon(Icons.close, size: 18, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildSuggestionChip(
                      suggestion['text']!,
                      suggestion['emoji']!,
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

  Widget _buildSuggestionChip(String text, String emoji) {
    return InkWell(
      onTap: () => _sendQuickSuggestion(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE8F3), Color(0xFFE3F2FD)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB3D9), width: 2),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6B9D),
              ),
            ),
          ],
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
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 100 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: child,
          ),
        );
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'إيموجي 😊',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showEmojiPicker = false),
                  child: Icon(Icons.close, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _insertEmoji(emojis[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          emojis[index],
                          style: const TextStyle(fontSize: 24),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
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
            // Bouton emoji
            GestureDetector(
              onTap: () => setState(() => _showEmojiPicker = !_showEmojiPicker),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _showEmojiPicker
                      ? const Color(0xFFFFE8F3)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '😊',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F9),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFFFB3D9),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
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
                      horizontal: 18,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Bouton suggestions
            if (!_showSuggestions)
              GestureDetector(
                onTap: () => setState(() => _showSuggestions = true),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFFF6B9D),
                    size: 22,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            // Bouton d'envoi
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                final glowOpacity =
                    (0.3 + _sparkleController.value * 0.2).clamp(0.0, 1.0);
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withOpacity(glowOpacity),
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
                child: _buildCircle(70, const Color(0xFFFFB3D9), 0.25),
              ),
              Positioned(
                top: 180 - _bubbleAnimation.value,
                right: 40,
                child: _buildCircle(55, const Color(0xFFB3E0F2), 0.3),
              ),
              Positioned(
                bottom: 250 + _bubbleAnimation.value,
                left: 50,
                child: _buildCircle(65, const Color(0xFFFFF59D), 0.25),
              ),
              Positioned(
                bottom: 180 - _bubbleAnimation.value,
                right: 35,
                child: _buildCircle(60, const Color(0xFFA5D6A7), 0.25),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFB3D9),
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
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        final bounce = (clampedValue * 6.28318).clamp(0.0, 6.28318);
        final offset = -6 * (1 - (bounce % 3.14159) / 3.14159).abs();

        return Transform.translate(
          offset: Offset(0, offset),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 8,
            height: 8,
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
