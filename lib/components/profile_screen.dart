import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mbanking_app_flutter/page/account.dart';
import 'package:mbanking_app_flutter/components/personal_screen.dart';
import 'package:mbanking_app_flutter/components/security_screen.dart';
import 'dart:io'; // Import ini untuk menggunakan File
import 'package:image_picker/image_picker.dart'; // Import image_picker

class ProfileScreen extends StatefulWidget {
  final bool showSuccessMessage;
  final String? successMessage;

  const ProfileScreen({
    super.key,
    this.showSuccessMessage = false,
    this.successMessage,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _profileImageController;
  late AnimationController _cardAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _profileRotationAnimation;
  // late Animation<double> _cardStaggerAnimation; // Hapus ini karena tidak digunakan

  File? _profileImage; // Variabel untuk menyimpan gambar yang dipilih

  @override
  void initState() {
    super.initState();

    // Main animation controller for overall screen
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Profile image animation controller
    _profileImageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Card stagger animation controller
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animation for overall content
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOutQuart),
      ),
    );

    // Slide animation for content from bottom
    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Profile image scale animation
    _profileScaleAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(
        parent: _profileImageController,
        curve: Curves.elasticOut,
      ),
    );

    // Profile image subtle rotation
    _profileRotationAnimation = Tween<double>(begin: -0.1, end: 0).animate(
      CurvedAnimation(
        parent: _profileImageController,
        curve: Curves.easeOutBack,
      ),
    );

    // Card stagger animation (dihapus karena tidak digunakan)
    // _cardStaggerAnimation = Tween<double>(begin: 0, end: 1).animate(
    //   CurvedAnimation(
    //     parent: _cardAnimationController,
    //     curve: Curves.easeOutQuart,
    //   ),
    // );

    // Start animations with slight delays
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _mainAnimationController.forward();

      // Start profile image animation after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _profileImageController.forward();
        }
      });

      // Start card animations after main content
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _cardAnimationController.forward();
        }
      });
    });

    // Show success message if needed
    if (widget.showSuccessMessage && widget.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _showSuccessNotification(widget.successMessage!);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _profileImageController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _showSuccessNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'Apakah Anda yakin ingin keluar dari akun?',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Tidak',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const AccountScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Ya',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Fungsi baru untuk memilih gambar ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      _showSuccessNotification('Foto profil berhasil diubah!');
    } else {
      _showSuccessNotification('Pemilihan foto dibatalkan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            isDarkMode ? Colors.grey[900] : const Color.fromARGB(255, 101, 106, 252),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: AnimatedBuilder(
        animation: _mainAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Profile Image with enhanced animation
                    AnimatedBuilder(
                      animation: _profileImageController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _profileScaleAnimation.value,
                          child: Transform.rotate(
                            angle: _profileRotationAnimation.value,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDarkMode
                                          ? Colors.indigo[400]!
                                          : Colors.indigo[800]!,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: _profileImage != null
                                        ? FileImage(_profileImage!)
                                        : const NetworkImage('assets/logo/icon.png')
                                            as ImageProvider,
                                  ),
                                ),
                                // Tombol/Icon Ubah Foto
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 800),
                                  tween: Tween(begin: 0, end: 1),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: GestureDetector( // Tambahkan GestureDetector di sini
                                        onTap: _pickImage, // Panggil fungsi _pickImage saat di-tap
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? Colors.indigo[700]
                                                : Colors.indigo[800],
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDarkMode
                                                  ? Colors.grey[800]!
                                                  : Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt, 
                                            color: Colors.white,
                                            size: 18,
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
                      },
                    ),

                    const SizedBox(height: 16),

                    // Profile Info with staggered animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: Column(
                              children: [
                                Text(
                                  'Mikumiestu',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sabrina Mikumiestu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Priority Chip with bounce animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Chip(
                              backgroundColor:
                                  isDarkMode ? Colors.indigo[900] : Colors.indigo[50],
                              label: Text(
                                'Prioritas',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.indigo[200]
                                      : Colors.indigo[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              avatar: Icon(
                                Icons.verified,
                                color: isDarkMode
                                    ? Colors.indigo[200]
                                    : Colors.indigo[800],
                                size: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Cards with staggered animation
                    AnimatedBuilder(
                      animation: _cardAnimationController,
                      builder: (context, child) {
                        return Column(
                          children: [
                            _buildAnimatedCard(
                              delay: 0,
                              child: _buildFirstCard(isDarkMode),
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedCard(
                              delay: 200,
                              child: _buildSecondCard(isDarkMode),
                            ),
                            const SizedBox(height: 24),
                            _buildAnimatedCard(
                              delay: 400,
                              child: _buildSignOutButton(),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutQuart,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildFirstCard(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.person_outline,
                title: 'Personal Data',
                subtitle: 'Update your personal information',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalScreen(),
                    ),
                  );
                },
                isDarkMode: isDarkMode,
              ),
              const Divider(height: 1, indent: 16),
              _buildListTile(
                icon: Icons.lock_outline,
                title: 'Security',
                subtitle: 'Change password and security settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityScreen(),
                    ),
                  );
                },
                isDarkMode: isDarkMode,
              ),
              const Divider(height: 1, indent: 16),
              _buildListTile(
                icon: Icons.credit_card,
                title: 'Payment Methods',
                subtitle: 'Manage your cards and accounts',
                onTap: () {},
                isDarkMode: isDarkMode,
              ),
              const Divider(height: 1, indent: 16),
              _buildListTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Configure notification preferences',
                onTap: () {},
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondCard(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'Get help with your account',
                onTap: () {},
                isDarkMode: isDarkMode,
              ),
              const Divider(height: 1, indent: 16),
              _buildListTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Appearance and preferences',
                onTap: () {},
                isDarkMode: isDarkMode,
              ),
              const Divider(height: 1, indent: 16),
              _buildListTile(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'Version 1.0.0',
                onTap: () {},
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _showSignOutDialog,
          child: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.indigo[900] : Colors.indigo[50],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDarkMode ? Colors.indigo[200] : Colors.indigo[800],
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.grey[800],
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minVerticalPadding: 0,
    );
  }
}
