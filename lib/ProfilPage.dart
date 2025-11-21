import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'avatar_selection_page.dart';

class ProfilPage extends StatefulWidget {
  final String name;
  final int age;
  final String email;
  final String avatar;

  const ProfilPage({
    Key? key,
    required this.name,
    required this.age,
    required this.email,
    required this.avatar,
  }) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with TickerProviderStateMixin {
  late String userName;
  late int userAge;
  late String userEmail;
  int totalScore = 245;
  bool notificationsEnabled = true;
  bool musicEnabled = true;
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

  bool _isSettingsOpen = false;

  @override
  void initState() {
    super.initState();

    // Initialiser avec les paramètres reçus
    userName = widget.name;
    userAge = widget.age;
    userEmail = widget.email;
    avatarPath = widget.avatar.isNotEmpty ? widget.avatar : null;

    // Si l'avatar est un chemin de fichier (commence par /), c'est une image personnalisée
    if (avatarPath != null && avatarPath!.startsWith('/')) {
      profileImage = File(avatarPath!);
      avatarPath = null;
    }

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

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
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      musicEnabled = prefs.getBool('music') ?? true;
      currentPassword = prefs.getString('currentPassword') ?? '';
      totalScore = prefs.getInt('totalScore') ?? 245;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setBool('music', musicEnabled);
    await prefs.setString('userName', userName);
    await prefs.setInt('userAge', userAge);
    await prefs.setInt('totalScore', totalScore);
    if (newPassword.isNotEmpty) {
      await prefs.setString('currentPassword', newPassword);
    }
  }

  void _toggleSettingsPanel() {
    setState(() {
      _isSettingsOpen = !_isSettingsOpen;
    });
  }

  void _openAvatarSelection() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarSelectionPage(
            name: userName,
            age: userAge,
            email: userEmail,
            password: currentPassword,
          ),
        ),
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
            content: const Text(
              'حدث خطأ أثناء اختيار الصورة',
              style: TextStyle(fontFamily: 'Cairo'),
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
        textDirection: TextDirection.rtl,
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
              const Text(
                'تعديل الاسم',
                style: TextStyle(
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
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
            decoration: InputDecoration(
              hintText: 'أدخل الاسم الجديد',
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
              child: const Text('إلغاء'),
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
              child: const Text(
                'حفظ',
                style: TextStyle(
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
        textDirection: TextDirection.rtl,
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
              const Text(
                'تعديل العمر',
                style: TextStyle(
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
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
            decoration: InputDecoration(
              hintText: 'أدخل العمر الجديد',
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
              child: const Text('إلغاء'),
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
              child: const Text(
                'حفظ',
                style: TextStyle(
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
        textDirection: TextDirection.rtl,
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
              const Text(
                'تغيير كلمة المرور',
                style: TextStyle(
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
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور الحالية',
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
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور الجديدة',
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
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'تأكيد كلمة المرور',
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
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
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
              child: const Text(
                'حفظ',
                style: TextStyle(
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
      _showErrorDialog('يرجى إدخال كلمة المرور الحالية');
      return;
    }

    if (currentPassword.isNotEmpty && currentInput != currentPassword) {
      _showErrorDialog('كلمة المرور الحالية غير صحيحة');
      return;
    }

    if (newInput.isEmpty) {
      _showErrorDialog('يرجى إدخال كلمة المرور الجديدة');
      return;
    }

    if (newInput.length < 4) {
      _showErrorDialog('كلمة المرور يجب أن تكون 4 أحرف على الأقل');
      return;
    }

    if (newInput != confirmInput) {
      _showErrorDialog('كلمات المرور غير متطابقة');
      return;
    }

    setState(() {
      newPassword = newInput;
      currentPassword = newInput;
    });
    _saveSettings();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم تغيير كلمة المرور بنجاح',
          style: TextStyle(fontFamily: 'Cairo'),
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
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFEF5350)),
              const SizedBox(width: 8),
              const Text('خطأ', style: TextStyle(fontFamily: 'Cairo')),
            ],
          ),
          content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
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
              const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من أنك تريد الخروج؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
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
              child: const Text(
                'خروج',
                style: TextStyle(
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

  Widget _buildSettingsPanel() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: _isSettingsOpen ? 0 : -MediaQuery.of(context).size.width * 0.75,
      top: 0,
      bottom: 0,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'الإعدادات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildSettingCardCompact(
                        icon: Icons.notifications_active_rounded,
                        label: 'الإشعارات',
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
                      _buildSettingCardCompact(
                        icon: Icons.music_note_rounded,
                        label: 'الموسيقى',
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
                      _buildSettingCardCompact(
                        icon: Icons.lock_rounded,
                        label: 'تغيير كلمة المرور',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                        ),
                        onTap: _changePassword,
                      ),
                      const SizedBox(height: 30),
                      _buildActionButtonCompact(
                        text: 'حفظ التغييرات',
                        icon: Icons.check_circle_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                        ),
                        onTap: () {
                          _saveSettings();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'تم حفظ التغييرات بنجاح!',
                                style: TextStyle(fontFamily: 'Cairo'),
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
                      const SizedBox(height: 10),
                      _buildActionButtonCompact(
                        text: 'تسجيل الخروج',
                        icon: Icons.logout_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF5350), Color(0xFFE57373)],
                        ),
                        onTap: _showLogoutDialog,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
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
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
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
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
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
                                        child: profileImage == null &&
                                                avatarPath == null
                                            ? const Text(
                                                '👤',
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
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          children: [
                            _buildBadge(
                              'مستوى 3',
                              Icons.rocket_launch_rounded,
                              const Color(0xFF64B5F6),
                            ),
                            _buildBadge(
                              '$totalScore ⭐',
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
                        _buildInfoCard(
                          icon: Icons.child_care_rounded,
                          label: 'العمر',
                          value: '$userAge سنوات',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                          ),
                          onTap: _editAge,
                        ),
                        const SizedBox(height: 14),
                        _buildInfoCard(
                          icon: Icons.email_rounded,
                          label: 'البريد الإلكتروني',
                          value: userEmail,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildInfoCard(
                          icon: Icons.emoji_events_rounded,
                          label: 'النقاط الإجمالية',
                          value: '$totalScore',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: _toggleSettingsPanel,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            if (_isSettingsOpen)
              GestureDetector(
                onTap: _toggleSettingsPanel,
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            _buildSettingsPanel(),
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
                crossAxisAlignment: CrossAxisAlignment.end,
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

  Widget _buildSettingCardCompact({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gradient.colors[0].withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors[0].withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5C546A),
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonCompact({
    required String text,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gradient.colors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
