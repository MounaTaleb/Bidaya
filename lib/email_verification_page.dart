import 'package:flutter/material.dart';
import 'auth_Service.dart';
import 'avatar_selection_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final String name;
  final int age;
  final String password;

  const EmailVerificationPage({
    Key? key,
    required this.email,
    required this.name,
    required this.age,
    required this.password,
  }) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final AuthService _authService = AuthService();
  late AnimationController _fadeController;
  late AnimationController _bubbleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bubbleAnimation;

  bool _isVerified = false;
  bool _isChecking = false;
  bool _isCheckingManually = false;
  int _resendCount = 0;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isVerified) {
      _checkEmailVerificationNow();
    }
  }

  Future<void> _checkEmailVerificationNow() async {
    if (!mounted) return;
    setState(() => _isCheckingManually = true);
    try {
      bool verified = await _authService.isEmailVerified();
      if (mounted) {
        setState(() {
          _isVerified = verified;
          _isCheckingManually = false;
        });
        if (verified) _showSuccessDialog();
      }
    } catch (_) {
      if (mounted) setState(() => _isCheckingManually = false);
    }
  }

  void _startVerificationCheck() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted || _isVerified) return;
      setState(() => _isChecking = true);
      try {
        bool verified = await _authService.isEmailVerified();
        if (mounted) {
          setState(() {
            _isVerified = verified;
            _isChecking = false;
          });
          if (verified)
            _showSuccessDialog();
          else
            _startVerificationCheck();
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isChecking = false);
          _startVerificationCheck();
        }
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 20,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFF5F9),
                Color(0xFFFFE8F3),
                Color(0xFFE3F2FD),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icône avec animation de succès
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D).withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: const Color(0xFFFF6B9D),
                    size: 60,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'تم التحقق بنجاح! 🎉',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFF6B9D),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'حسابك مفعل وجاهز للاستخدام الآن',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 35),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvatarSelectionPage(
                          email: widget.email,
                          password: widget.password,
                          name: widget.name,
                          age: widget.age,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B9D),
                          Color(0xFFFF8FB9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'المتابعة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resendEmail() async {
    if (_remainingSeconds > 0) return;
    try {
      await _authService.resendVerificationEmail();
      setState(() {
        _resendCount++;
        _remainingSeconds = 60;
      });
      _startCountdown();
    } catch (_) {}
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          if (!_isVerified) {
                            _authService.signOut();
                            if (mounted) Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: const Color(0xFFFF6B9D),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                // Icône principale
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B9D)
                                            .withOpacity(0.2),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isVerified
                                        ? Icons.check_circle
                                        : Icons.mail_outline,
                                    size: 80,
                                    color: _isVerified
                                        ? const Color(0xFFFF6B9D)
                                        : const Color(0xFFFF6B9D),
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Titre principal
                                Text(
                                  _isVerified
                                      ? '✅ تم التحقق!'
                                      : '📧 تحقق من بريدك',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFFF6B9D),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Email avec style cohérent
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFFFF6B9D)
                                            .withOpacity(0.08),
                                        const Color(0xFF64B5F6)
                                            .withOpacity(0.08),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFFF6B9D)
                                          .withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    widget.email,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // Status box avec animation
                                if (!_isVerified)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    constraints:
                                        const BoxConstraints(maxWidth: 350),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF6B9D)
                                              .withOpacity(0.1),
                                          blurRadius: 25,
                                          offset: const Offset(0, 10),
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        if (_isChecking || _isCheckingManually)
                                          SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                const Color(0xFFFF6B9D),
                                              ),
                                              strokeWidth: 3,
                                            ),
                                          )
                                        else
                                          Icon(
                                            Icons.hourglass_bottom_rounded,
                                            size: 45,
                                            color: const Color(0xFFFF6B9D),
                                          ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'في انتظار تأكيد بريدك الإلكتروني',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'انقر على الرابط في البريد لتفعيل حسابك',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                const SizedBox(height: 40),

                                // زر إعادة الإرسال
                                if (!_isVerified)
                                  GestureDetector(
                                    onTap: _remainingSeconds == 0
                                        ? _resendEmail
                                        : null,
                                    child: Container(
                                      width: double.infinity,
                                      constraints:
                                          const BoxConstraints(maxWidth: 320),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: BoxDecoration(
                                        color: _remainingSeconds == 0
                                            ? Colors.white
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: _remainingSeconds == 0
                                              ? const Color(0xFFFF6B9D)
                                              : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                        boxShadow: _remainingSeconds == 0
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFFFF6B9D)
                                                      .withOpacity(0.3),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _remainingSeconds == 0
                                                ? '📧 إعادة إرسال البريد'
                                                : 'إعادة الإرسال (${_remainingSeconds}s)',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: _remainingSeconds == 0
                                                  ? const Color(0xFFFF6B9D)
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                          if (_resendCount > 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Text(
                                                'تم الإرسال $_resendCount مرات',
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                  color: _remainingSeconds == 0
                                                      ? Colors.grey.shade600
                                                      : Colors.grey.shade500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 15),

                                // زر فحص يدوي
                                if (!_isVerified)
                                  GestureDetector(
                                    onTap: _checkEmailVerificationNow,
                                    child: Container(
                                      width: double.infinity,
                                      constraints:
                                          const BoxConstraints(maxWidth: 320),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: const Color(0xFFFF6B9D),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFF6B9D)
                                                .withOpacity(0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (_isCheckingManually)
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  const Color(0xFFFF6B9D),
                                                ),
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          else
                                            Icon(
                                              Icons.refresh_rounded,
                                              color: const Color(0xFFFF6B9D),
                                              size: 20,
                                            ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'فحص الآن',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFFF6B9D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 25),

                                // رسالة مساعدة
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF59D)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFFF59D),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '💡 نصيحة سريعة',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'إذا لم تستقبل البريد، تحقق من مجلد Spam',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                top: 80 + _bubbleAnimation.value,
                left: 30,
                child: _buildCircle(80, const Color(0xFFFFB3D9), 0.25),
              ),
              Positioned(
                top: 140 - _bubbleAnimation.value,
                right: 40,
                child: _buildCircle(60, const Color(0xFFB3E0F2), 0.3),
              ),
              Positioned(
                bottom: 200 + _bubbleAnimation.value,
                left: 50,
                child: _buildCircle(70, const Color(0xFFFFF59D), 0.25),
              ),
              Positioned(
                bottom: 140 - _bubbleAnimation.value,
                right: 35,
                child: _buildCircle(75, const Color(0xFFA5D6A7), 0.25),
              ),
              Positioned(
                top: 280 + _bubbleAnimation.value * 0.5,
                left: -20,
                child: _buildCircle(90, const Color(0xFFFFCCBC), 0.2),
              ),
              Positioned(
                bottom: 320 - _bubbleAnimation.value * 0.5,
                right: -15,
                child: _buildCircle(85, const Color(0xFFCE93D8), 0.22),
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
}
