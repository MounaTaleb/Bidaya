import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'avatar_selection_page.dart';

class ProfilPage extends StatefulWidget {
  final String? avatarPath;
  final File? customImage;

  const ProfilPage({Key? key, this.avatarPath, this.customImage})
    : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with TickerProviderStateMixin {
  String userName = 'ليلى';
  int userAge = 8;
  String userEmail = 'layla@example.com';
  int totalScore = 245;
  bool notificationsEnabled = true;
  bool musicEnabled = true;
  String selectedLanguage = 'ar';
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  File? profileImage;
  String? avatarPath;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    profileImage = widget.customImage;
    avatarPath = widget.avatarPath;

    // Animation de pulsation pour l'avatar
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Animation des bulles
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    _loadSettings();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bubbleController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'ar';
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      musicEnabled = prefs.getBool('music') ?? true;
      userName = prefs.getString('userName') ?? 'ليلى';
      userAge = prefs.getInt('userAge') ?? 8;
      currentPassword = prefs.getString('currentPassword') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', selectedLanguage);
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setBool('music', musicEnabled);
    await prefs.setString('userName', userName);
    await prefs.setInt('userAge', userAge);
    if (newPassword.isNotEmpty) {
      await prefs.setString('currentPassword', newPassword);
    }
  }

  String getText(String ar, String en) {
    return selectedLanguage == 'ar' ? ar : en;
  }

  void _openAvatarSelection() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AvatarSelectionPage()),
      );

      if (result != null && mounted) {
        setState(() {
          if (result is String) {
            avatarPath = result;
            profileImage = null;
          } else if (result is File) {
            profileImage = result;
            avatarPath = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              getText('حدث خطأ أثناء اختيار الصورة', 'Error selecting image'),
              style: const TextStyle(fontFamily: 'Cairo'),
              textAlign: TextAlign.center,
            ),
            backgroundColor: const Color(0xFFFF6B9D),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _editName() {
    final TextEditingController controller = TextEditingController(
      text: userName,
    );
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B9D).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                getText('تعديل الاسم', 'Edit Name'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Color(0xFF5C546A),
                ),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            textAlign: selectedLanguage == 'ar'
                ? TextAlign.right
                : TextAlign.left,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
            decoration: InputDecoration(
              hintText: getText('أدخل الاسم الجديد', 'Enter new name'),
              filled: true,
              fillColor: const Color(0xFFFFF5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getText('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() => userName = controller.text.trim());
                  _saveSettings();
                }
                Navigator.pop(context);
              },
              child: Text(
                getText('حفظ', 'Save'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editAge() {
    final controller = TextEditingController(text: userAge.toString());
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64B5F6).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.cake_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                getText('تعديل العمر', 'Edit Age'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Color(0xFF5C546A),
                ),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: selectedLanguage == 'ar'
                ? TextAlign.right
                : TextAlign.left,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
            decoration: InputDecoration(
              hintText: getText('أدخل العمر الجديد', 'Enter new age'),
              filled: true,
              fillColor: const Color(0xFFE3F2FD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getText('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64B5F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                final v = int.tryParse(controller.text);
                if (v != null && v > 0 && v < 100) {
                  setState(() => userAge = v);
                  _saveSettings();
                }
                Navigator.pop(context);
              },
              child: Text(
                getText('حفظ', 'Save'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFA726).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                getText('تغيير كلمة المرور', 'Change Password'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Color(0xFF5C546A),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  textAlign: selectedLanguage == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  decoration: InputDecoration(
                    hintText: getText(
                      'كلمة المرور الحالية',
                      'Current password',
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  textAlign: selectedLanguage == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  decoration: InputDecoration(
                    hintText: getText('كلمة المرور الجديدة', 'New password'),
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  textAlign: selectedLanguage == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  decoration: InputDecoration(
                    hintText: getText('تأكيد كلمة المرور', 'Confirm password'),
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                getText('إلغاء', 'Cancel'),
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA726),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                _validateAndSavePassword();
              },
              child: Text(
                getText('حفظ', 'Save'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSavePassword() {
    final currentInput = _currentPasswordController.text;
    final newInput = _newPasswordController.text;
    final confirmInput = _confirmPasswordController.text;

    if (currentInput.isEmpty) {
      _showErrorDialog(
        getText(
          'يرجى إدخال كلمة المرور الحالية',
          'Please enter current password',
        ),
      );
      return;
    }

    if (currentInput != currentPassword) {
      _showErrorDialog(
        getText(
          'كلمة المرور الحالية غير صحيحة',
          'Current password is incorrect',
        ),
      );
      return;
    }

    if (newInput.isEmpty) {
      _showErrorDialog(
        getText('يرجى إدخال كلمة المرور الجديدة', 'Please enter new password'),
      );
      return;
    }

    if (newInput.length < 4) {
      _showErrorDialog(
        getText(
          'كلمة المرور يجب أن تكون 4 أحرف على الأقل',
          'Password must be at least 4 characters',
        ),
      );
      return;
    }

    if (newInput != confirmInput) {
      _showErrorDialog(
        getText('كلمات المرور غير متطابقة', 'Passwords do not match'),
      );
      return;
    }

    setState(() {
      newPassword = newInput;
    });
    _saveSettings();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          getText(
            'تم تغيير كلمة المرور بنجاح',
            'Password changed successfully',
          ),
          style: const TextStyle(fontFamily: 'Cairo'),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFEF5350)),
              const SizedBox(width: 8),
              Text(
                getText('خطأ', 'Error'),
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ],
          ),
          content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getText('حسناً', 'OK')),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64B5F6).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                getText('اختر اللغة', 'Choose Language'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Color(0xFF5C546A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('العربية', '🇸🇦', 'ar'),
              const SizedBox(height: 15),
              _buildLanguageOption('English', '🇬🇧', 'en'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getText('إلغاء', 'Cancel')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String text, String flag, String languageCode) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = languageCode;
        });
        _saveSettings();
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedLanguage == languageCode
              ? const Color(0xFFE3F2FD)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedLanguage == languageCode
                ? const Color(0xFF64B5F6)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5C546A),
              ),
            ),
            if (selectedLanguage == languageCode) ...[
              const Spacer(),
              const Icon(Icons.check_circle_rounded, color: Color(0xFF64B5F6)),
            ],
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: selectedLanguage == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF5350),
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                getText('تسجيل الخروج', 'Logout'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          content: Text(
            getText(
              'هل أنت متأكد من أنك تريد الخروج؟',
              'Are you sure you want to logout?',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getText('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
              child: Text(
                getText('خروج', 'Logout'),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: selectedLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Arrière-plan coloré avec dégradé
            Container(
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
            ),

            // Bulles décoratives animées
            AnimatedBuilder(
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
                  ],
                );
              },
            ),

            // Contenu principal
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Avatar avec animation
                        AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pink.shade200.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 65,
                                        backgroundColor: const Color(
                                          0xFFFFF5F9,
                                        ),
                                        backgroundImage: profileImage != null
                                            ? FileImage(profileImage!)
                                            : avatarPath != null
                                            ? AssetImage(avatarPath!)
                                                  as ImageProvider
                                            : null,
                                        child:
                                            profileImage == null &&
                                                avatarPath == null
                                            ? const Text(
                                                '🐰',
                                                style: TextStyle(fontSize: 56),
                                              )
                                            : null,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: _openAvatarSelection,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFF6B9D),
                                                Color(0xFFFF8FB9),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFFF6B9D,
                                                ).withOpacity(0.5),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Nom avec bouton édition
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _editName,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFF8FB9),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF6B9D,
                                      ).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF5C546A),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Badges
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          children: [
                            _buildBadge(
                              getText('مستوى 3', 'Level 3'),
                              Icons.rocket_launch_rounded,
                              const Color(0xFF64B5F6),
                            ),
                            _buildBadge(
                              '245 ⭐',
                              Icons.star_rounded,
                              const Color(0xFFFFD54F),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Carte Age
                        _buildInfoCard(
                          icon: Icons.child_care_rounded,
                          label: getText('العمر', 'Age'),
                          value: getText('$userAge سنوات', '$userAge years'),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                          ),
                          onTap: _editAge,
                        ),
                        const SizedBox(height: 14),

                        // Carte Email
                        _buildInfoCard(
                          icon: Icons.email_rounded,
                          label: getText('البريد الإلكتروني', 'Email'),
                          value: userEmail,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Carte Score
                        _buildInfoCard(
                          icon: Icons.emoji_events_rounded,
                          label: getText('النقاط الإجمالية', 'Total Score'),
                          value: '$totalScore',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Titre Paramètres
                        Text(
                          getText('الإعدادات', 'Settings'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF5C546A),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Notifications
                        _buildSettingCard(
                          icon: Icons.notifications_active_rounded,
                          label: getText('الإشعارات', 'Notifications'),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                          ),
                          trailing: Switch(
                            value: notificationsEnabled,
                            onChanged: (v) {
                              setState(() => notificationsEnabled = v);
                              _saveSettings();
                            },
                            activeColor: const Color(0xFF9C27B0),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Musique
                        _buildSettingCard(
                          icon: Icons.music_note_rounded,
                          label: getText('الموسيقى', 'Music'),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          ),
                          trailing: Switch(
                            value: musicEnabled,
                            onChanged: (v) {
                              setState(() => musicEnabled = v);
                              _saveSettings();
                            },
                            activeColor: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Mot de passe
                        _buildSettingCard(
                          icon: Icons.lock_rounded,
                          label: getText(
                            'تغيير كلمة المرور',
                            'Change Password',
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                          ),
                          onTap: _changePassword,
                        ),
                        const SizedBox(height: 12),

                        // Langue
                        _buildSettingCard(
                          icon: Icons.language_rounded,
                          label: getText('اللغة', 'Language'),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              selectedLanguage == 'ar'
                                  ? 'العربية 🇸🇦'
                                  : 'English 🇬🇧',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64B5F6),
                              ),
                            ),
                          ),
                          onTap: _showLanguageSelection,
                        ),
                        const SizedBox(height: 25),

                        // Bouton Sauvegarder
                        _buildActionButton(
                          text: getText('حفظ التغييرات', 'Save Changes'),
                          icon: Icons.check_circle_rounded,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          ),
                          onTap: () {
                            _saveSettings();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  getText(
                                    'تم حفظ التغييرات بنجاح!',
                                    'Changes saved successfully!',
                                  ),
                                  style: const TextStyle(fontFamily: 'Cairo'),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: const Color(0xFF4CAF50),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Bouton Déconnexion
                        _buildActionButton(
                          text: getText('تسجيل الخروج', 'Logout'),
                          icon: Icons.logout_rounded,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF5350), Color(0xFFE57373)],
                          ),
                          onTap: _showLogoutDialog,
                        ),
                        const SizedBox(height: 40),
                      ]),
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

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required LinearGradient gradient,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gradient.colors[0].withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors[0].withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: selectedLanguage == 'ar'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF5C546A),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: gradient.colors[0].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: gradient.colors[0],
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gradient.colors[0].withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors[0].withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                textAlign: selectedLanguage == 'ar'
                    ? TextAlign.right
                    : TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5C546A),
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              Icon(
                selectedLanguage == 'ar'
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gradient.colors[0].withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
