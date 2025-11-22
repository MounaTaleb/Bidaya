import 'package:flutter/material.dart';
import 'login_form_page.dart'; // Import de la page de formulaire

class NameInputPage extends StatefulWidget {
  final int age;

  const NameInputPage({Key? key, required this.age}) : super(key: key);

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _bubbleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _confirmName() {
    if (_nameController.text.trim().isNotEmpty) {
      // Navigation vers LoginFormPage avec le nom et l'âge
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginFormPage(name: _nameController.text.trim(), age: widget.age),
        ),
      );
    } else {
      // Afficher un message si le champ est vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'من فضلك اكتب اسمك! 😊',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.pink.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec bulles animées
          _buildBackground(),

          SafeArea(
            child: Column(
              children: [
                // Bouton de retour en haut
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                          color: Colors.pink.shade400,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                // Contenu principal
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
                              // Titre avec style moderne
                              Text(
                                'ما اسمك؟',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 32,
                                  color: Colors.pink.shade400,
                                  fontWeight: FontWeight.w800,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.9),
                                      offset: const Offset(0, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Image avec animation
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.8, end: 1.0),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.asset(
                                    'assets/images/nom.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Carte de saisie du nom
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 35,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pink.shade100.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 25,
                                      offset: const Offset(0, 10),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.8),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Texte d'instruction
                                    Text(
                                      'اكتب اسمك هنا',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 18,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Champ de texte stylisé
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFF6B9D).withOpacity(0.1),
                                            Color(0xFF64B5F6).withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Colors.pink.shade200,
                                          width: 2,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _nameController,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade800,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'اسمي هو...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 20,
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 18,
                                          ),
                                        ),
                                        maxLength: 20,
                                        buildCounter: (
                                          context, {
                                          required currentLength,
                                          required isFocused,
                                          maxLength,
                                        }) {
                                          return null; // Cache le compteur
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    // Petit message encourageant
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '✨',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'اسم جميل!',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 14,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '✨',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Bouton de confirmation
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: child,
                                  );
                                },
                                child: GestureDetector(
                                  onTap: _confirmName,
                                  child: Container(
                                    width: 240,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 20.0,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B9D),
                                          Color(0xFFFF8FB9),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF6B9D,
                                          ).withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'هيا بنا',
                                          style: TextStyle(
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
                                        SizedBox(width: 8),
                                        Text(
                                          '🚀',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
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
}
