import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';

import '../otp/otp_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _sendingOtp = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _resendCooldown = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          _resendCooldown = 0;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    if (_resendCooldown > 0) return;

    setState(() => _sendingOtp = true);

    try {
      await _apiService.sendOtp(phone);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sendingOtp = false);
      String message = 'Failed to send OTP. Please try again.';
      if (e.toString().contains('Cannot connect to server') ||
          e.toString().contains('Connection timed out')) {
        message = 'Cannot connect to server. Please make sure the backend is running.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _sendingOtp = false;
      _startCooldown();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(email: phone),
      ),
    );
  }

  void _goSignup() {
    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0E5A35),
                                    borderRadius: BorderRadius.circular(21),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _goSignup,
                                  child: const Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
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
                        const Text(
                          'Welcome back 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your phone number to proceed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '🇮🇳 +91',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 26,
                                color: const Color(0xFFD1D5DB),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  cursorColor: const Color(0xFF0E5A35),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    counterText: '',
                                    hintText: 'Phone number',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 15,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: (_sendingOtp || _resendCooldown > 0) ? null : _sendOtp,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E5A35),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x330E5A35),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_sendingOtp)
                                  const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  const Icon(Icons.send_outlined,
                                      color: Colors.white, size: 22),
                                const SizedBox(width: 10),
                                Text(
                                  _sendingOtp
                                      ? 'Sending...'
                                      : _resendCooldown > 0
                                          ? 'Resend OTP in ${_resendCooldown}s'
                                          : 'Send OTP',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New to VPNexues? ',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: _goSignup,
                              child: const Text(
                                'Create an account',
                                style: TextStyle(
                                  color: Color(0xFF0E5A35),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'By continuing, you agree to Terms & Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 11,
                          ),
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
}
