import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'MainAppPage.dart';

class LoginFormPage2 extends StatefulWidget {
  const LoginFormPage2({Key? key}) : super(key: key);

  @override
  State<LoginFormPage2> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage2>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

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
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }
  }

  Future<void> _saveUserData(
      String email, String name, int age, String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
    await prefs.setInt('userAge', age);
    await prefs.setString('userAvatar', avatar);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmLogin() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validation des champs
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('من فضلك املأ جميع الحقول! 📝');
      return;
    }

    if (!email.contains('@')) {
      _showErrorSnackBar('من فضلك أدخل بريد إلكتروني صحيح! ✉️');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Connexion avec Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupération des données utilisateur
      User? user = userCredential.user;

      if (user != null) {
        // Extraire le nom de l'email ou utiliser le displayName
        String displayName;
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          displayName = user.displayName!;
        } else {
          final emailName = email.split('@')[0];
          displayName = emailName.substring(0, 1).toUpperCase() +
              (emailName.length > 1 ? emailName.substring(1) : '');
        }

        // Déterminer l'avatar (vous pouvez adapter cette logique)
        String avatar = 'assets/images/avatar1.png';

        // Sauvegarder les données localement
        await _saveUserData(email, displayName, 8, avatar);

        _showSuccessSnackBar('مرحباً بك $displayName! 🎉');

        // Navigation vers la page principale
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainAppPage(
                  name: displayName,
                  age: 8,
                  email: email,
                  avatar: avatar,
                ),
              ),
            );
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'البريد الإلكتروني غير مسجل! ❌';
          break;
        case 'wrong-password':
          errorMessage = 'كلمة المرور غير صحيحة! 🔒';
          break;
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح! ✉️';
          break;
        case 'user-disabled':
          errorMessage = 'هذا الحساب معطل! ⚠️';
          break;
        default:
          errorMessage = 'حدث خطأ أثناء تسجيل الدخول! 🔄';
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar('حدث خطأ غير متوقع! 🔄');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Lance le flux de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obtient les authentifications
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crée un credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connecte l'utilisateur avec Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        // Utilise le nom Google ou l'email comme fallback
        String displayName =
            user.displayName ?? googleUser.displayName ?? 'مستخدم Google';

        String email = user.email ?? googleUser.email;
        String avatar = 'assets/images/avatar2.png';

        // Sauvegarder les données
        await _saveUserData(email, displayName, 8, avatar);

        _showSuccessSnackBar('مرحباً بك $displayName! 🎉');

        if (mounted) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainAppPage(
                  name: displayName,
                  age: 8,
                  email: email,
                  avatar: avatar,
                ),
              ),
            );
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'الحساب موجود بوسيلة تسجيل أخرى! ⚠️';
          break;
        case 'invalid-credential':
          errorMessage = 'معلومات التسجيل غير صالحة! 🔄';
          break;
        case 'operation-not-allowed':
          errorMessage = 'تسجيل الدخول بـ Google غير مفعل! ⚙️';
          break;
        case 'user-disabled':
          errorMessage = 'هذا الحساب معطل! ⚠️';
          break;
        case 'user-not-found':
          errorMessage = 'الحساب غير موجود! ❌';
          break;
        default:
          errorMessage = 'فشل في الدخول بواسطة Google! 🔄';
      }
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar('حدث خطأ أثناء الدخول بـ Google! 🔄');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                      onTap: _isLoading ? null : () => Navigator.pop(context),
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
                          color:
                              _isLoading ? Colors.grey : Colors.pink.shade400,
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
                                'أهلاً بعودتك! 👋',
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
                              const SizedBox(height: 10),
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
                                  height: 180,
                                  child: Image.asset(
                                    'assets/images/formulaire2.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 25,
                                ),
                                constraints: BoxConstraints(maxWidth: 350),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
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
                                    Text(
                                      'تسجيل الدخول',
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
                                      enabled: !_isLoading,
                                    ),
                                    const SizedBox(height: 15),
                                    _buildTextField(
                                      controller: _passwordController,
                                      hintText: 'كلمة المرور',
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                      enabled: !_isLoading,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
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
                                  onTap: _isLoading ? null : _confirmLogin,
                                  child: Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(maxWidth: 320),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: _isLoading
                                          ? LinearGradient(
                                              colors: [
                                                Colors.grey.shade400,
                                                Colors.grey.shade300,
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xFFFF6B9D),
                                                Color(0xFFFF8FB9),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: _isLoading
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: const Color(0xFFFF6B9D)
                                                    .withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (_isLoading)
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        else
                                          Text(
                                            'تسجيل الدخول',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        if (!_isLoading) ...[
                                          const SizedBox(width: 8),
                                          const Text(
                                            '🎮',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'أو',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 13,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: _isLoading ? null : _signInWithGoogle,
                                child: Container(
                                  width: double.infinity,
                                  constraints: BoxConstraints(maxWidth: 320),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isLoading
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: _isLoading
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.grey.shade300
                                                  .withOpacity(0.5),
                                              blurRadius: 15,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                    border: Border.all(
                                      color: _isLoading
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isLoading)
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.grey.shade600),
                                          ),
                                        )
                                      else ...[
                                        Image.asset(
                                          'assets/images/google.png',
                                          width: 22,
                                          height: 22,
                                        ),
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
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6B9D).withOpacity(0.08),
            Color(0xFF64B5F6).withOpacity(0.08),
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
        enabled: enabled,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.grey.shade800 : Colors.grey.shade400,
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
                    color:
                        enabled ? Colors.pink.shade300 : Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: enabled
                      ? () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        }
                      : null,
                )
              : null,
          suffixIcon: Icon(icon,
              color: enabled ? Colors.pink.shade300 : Colors.grey.shade400,
              size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // Les méthodes _buildBackground(), _buildCircle(), _buildStar() restent identiques
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
