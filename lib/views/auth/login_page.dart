import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:textile/views/auth/login_controller.dart';
import 'package:textile/views/auth/signup_page.dart';
import 'package:textile/widgets/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 74,
                      child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Textile Analytics',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.5, color: Colors.white70, height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x24000000),
                            blurRadius: 26,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Use your email/username and password.',
                            style: TextStyle(fontSize: 12.5, color: Colors.black54, height: 1.35),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE9EEF2)),
                            ),
                            child: TextField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email / Username',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE9EEF2)),
                              ),
                              child: TextField(
                                controller: controller.passwordController,
                                obscureText: !controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: controller.togglePasswordVisibility,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: controller.forgotPassword,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryDark,
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              ),
                              child: const Text('Forgot password?', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value ? null : controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Log in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Divider(color: Color(0xFFE9EEF2))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('OR', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800)),
                              ),
                              Expanded(child: Divider(color: Color(0xFFE9EEF2))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialButton(
                                icon: FontAwesomeIcons.facebook,
                                color: AppColors.facebook,
                                onPressed: () => controller.socialLogin('Facebook'),
                              ),
                              const SizedBox(width: 16),
                              _SocialButton(
                                icon: FontAwesomeIcons.instagram,
                                color: AppColors.instagram,
                                onPressed: () => controller.socialLogin('Instagram'),
                              ),
                              const SizedBox(width: 16),
                              _SocialButton(
                                icon: FontAwesomeIcons.linkedin,
                                color: AppColors.linkedin,
                                onPressed: () => controller.socialLogin('LinkedIn'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? ", style: TextStyle(color: Colors.black54, fontSize: 13)),
                              GestureDetector(
                                onTap: () => Get.to(() => const SignupPage()),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF2)),
      ),
      child: IconButton(
        icon: FaIcon(icon, color: color),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }
}