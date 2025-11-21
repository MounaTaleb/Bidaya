import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'avatar_selection_page.dart';
import 'email_verification_page.dart';

class LoginFormPage extends StatefulWidget {
  final String name;
  final int age;

  const LoginFormPage({Key? key, required this.name, required this.age})
      : super(key: key);

  @override
  State<LoginFormPage> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _showSnack(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ✅ Inscription avec vérification email
  Future<void> _signUpWithEmail() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      _showSnack('من فضلك املأ جميع الحقول! 📝', Colors.pink.shade400);
      return;
    }

    if (!email.contains('@')) {
      _showSnack('من فضلك أدخل بريد إلكتروني صحيح! ✉️', Colors.orange.shade400);
      return;
    }

    if (password.length < 6) {
      _showSnack(
          'كلمة المرور يجب أن تكون 6 أحرف على الأقل', Colors.orange.shade400);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ Créer le compte Firebase
      await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      _showSnack('تم إنشاء الحساب! تحقق من بريدك 📧', Colors.green.shade400);

      // ✅ Naviguer vers la page de vérification
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationPage(
              email: email,
              name: widget.name,
              age: widget.age,
              password: password,
            ),
          ),
        );
      }
    } catch (e) {
      _showSnack(e.toString(), Colors.red.shade400);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ Connexion avec Google
  Future<void> _googleLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        _showSnack('تم الدخول بنجاح عبر Google! 🎉', Colors.green.shade400);

        // ✅ Navigation directe (pas besoin de vérification email)
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AvatarSelectionPage(
                email: userCredential.user!.email!,
                password: '',
                name: widget.name,
                age: widget.age,
              ),
            ),
          );
        }
      }
    } catch (e) {
      _showSnack(e.toString(), Colors.red.shade400);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        if (!_isLoading) Navigator.pop(context);
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
                              Text(
                                'مرحباً ${widget.name}! 👋',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 32,
                                  color: Colors.pink.shade400,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 180,
                                child: Image.asset(
                                  'assets/images/formulaire.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildFormCard(),
                              const SizedBox(height: 25),
                              _buildSignupButton(),
                              const SizedBox(height: 20),
                              _buildGoogleButton(),
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

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      constraints: const BoxConstraints(maxWidth: 350),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            hintText: 'البريد الإلكتروني',
            icon: Icons.email_outlined,
            isPassword: false,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _passwordController,
            hintText: 'كلمة المرور',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSignupButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _signUpWithEmail,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
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
              color: const Color(0xFFFF6B9D).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'إنشاء الحساب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _googleLogin,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(vertical: 13.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google.png', width: 22, height: 22),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'الدخول بواسطة Google',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.08),
            const Color(0xFF64B5F6).withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.pink.shade200.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.pink.shade300,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          suffixIcon: Icon(icon, color: Colors.pink.shade300, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
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
