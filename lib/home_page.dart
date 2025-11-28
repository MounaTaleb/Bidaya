import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'age.dart';
import 'login2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _logoController;
  late AnimationController _bubbleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation principale
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Animation du logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotateAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Animation des bulles flottantes
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    // Démarrer les animations
    _controller.forward();
    _logoController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _logoController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),

                          // Logo agrandi avec animation
                          AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoScaleAnimation.value,
                                child: Transform.rotate(
                                  angle: _logoRotateAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.shade200
                                              .withOpacity(0.4),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/bidaya_logo.png',
                                      width: 240,
                                      height: 240,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),

                          // Slogan avec animation scintillante
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1800),
                            curve: Curves.easeIn,
                            builder: (context, value, child) {
                              final clampedValue = value.clamp(0.0, 1.0);
                              return Opacity(
                                opacity: clampedValue,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - clampedValue)),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              'حيث يلتقي المرح بالتعلّم ✨',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 24,
                                color: Colors.pink.shade400,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.9),
                                    offset: const Offset(0, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),

                          // Boutons avec animation au survol
                          _buildCuteButton(
                            text: 'هيا بنا',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shadowColor: const Color(0xFFFF6B9D),
                            icon: '🚀',
                            delay: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginFormPage2(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          _buildCuteButton(
                            text: 'من نحن؟',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shadowColor: const Color(0xFF64B5F6),
                            icon: '💡',
                            delay: 200,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SplashPage(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 40),

                          // Texte de connexion avec animation
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                            builder: (context, value, child) {
                              final clampedValue = value.clamp(0.0, 1.0);
                              return Opacity(
                                opacity: clampedValue,
                                child: child,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'هل لديك حساب بالفعل؟ ',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AgeSelectionPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'سجّل الدخول',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Arrière-plan avec bulles animées
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
              // Bulles décoratives avec mouvement
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

              // Étoiles scintillantes
              Positioned(
                top: 180,
                left: 70,
                child: _buildStar(22, const Color(0xFFFFD54F)),
              ),
              Positioned(
                top: 250,
                right: 60,
                child: _buildStar(18, const Color(0xFFFF8A80)),
              ),
              Positioned(
                bottom: 260,
                left: 80,
                child: _buildStar(20, const Color(0xFF80DEEA)),
              ),
              Positioned(
                bottom: 190,
                right: 90,
                child: _buildStar(16, const Color(0xFFF48FB1)),
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

  Widget _buildStar(double size, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(scale: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Boutons avec animation
  Widget _buildCuteButton({
    required String text,
    required LinearGradient gradient,
    required Color shadowColor,
    required String icon,
    required int delay,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 240,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Color(0x30000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(icon, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
