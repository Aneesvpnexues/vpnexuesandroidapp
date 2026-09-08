import 'package:flutter/material.dart';
import '../../navigation/main_navigation_screen.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goHome() {
    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  void _goLogin() {
    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _inputField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(icon, color: const Color(0xFF9CA3AF), size: 22),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              cursorColor: const Color(0xFF0E5A35),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final headerH = w * (268 / 412);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: headerH - 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1EE),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _goLogin,
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: const Color(0xFF6B7280),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0E5A35),
                                    borderRadius: BorderRadius.circular(21),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _inputField(
                          icon: Icons.person_outline,
                          controller: _nameController,
                          hint: 'Full Name',
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          hint: 'Email address',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          hint: 'Password',
                          obscure: _obscurePassword,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF9CA3AF),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        GestureDetector(
                          onTap: _goHome,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E5A35),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                'Create account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0xFFE5E7EB)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Or Sign up with',
                                style: TextStyle(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Color(0xFFE5E7EB)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialButton(Icons.g_mobiledata, 'Google'),
                            const SizedBox(width: 16),
                            _socialButton(Icons.apple, 'Apple'),
                            const SizedBox(width: 16),
                            _socialButton(Icons.facebook, 'Facebook'),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: const Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: _goLogin,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: const Color(0xFF0E5A35),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 412 / 268,
              child: Image.asset(
                'assets/images/header_login.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label login coming soon!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
            ),
            child: Icon(icon, size: 26, color: const Color(0xFF374151)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
