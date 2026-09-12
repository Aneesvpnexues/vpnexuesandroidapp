import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import '../../navigation/main_navigation_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final ApiService _apiService = ApiService();
  bool _verifying = false;
  int _resendCooldown = 60;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    _checkClipboard();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    for (final n in _nodes) {
      n.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
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

  Future<void> _checkClipboard() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null && mounted) {
        final digits = data!.text!.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length >= 6) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('OTP found in clipboard'),
              action: SnackBarAction(
                label: 'Paste',
                textColor: const Color(0xFF0E5A35),
                onPressed: _pasteOtp,
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _pasteOtp() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null) {
        final digits = data!.text!.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length >= 6) {
          for (int i = 0; i < 6; i++) {
            _controllers[i].text = digits[i];
          }
          _nodes[5].requestFocus();
          setState(() {});
          if (_isComplete) {
            await Future.delayed(const Duration(milliseconds: 200));
            _verify();
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No valid 6-digit OTP found in clipboard'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {}
  }

  bool get _isComplete =>
      _controllers.every((c) => c.text.trim().isNotEmpty);

  void _onChanged(int index, String value) {
    setState(() {});
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isNotEmpty && _isComplete) {
      _verify();
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _nodes[index - 1].requestFocus();
        setState(() {});
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> _verify() async {
    if (_verifying) return;
    setState(() => _verifying = true);
    FocusScope.of(context).unfocus();

    final otp = _controllers.map((c) => c.text.trim()).join();
    try {
      final result = await _apiService.verifyOtp(widget.email, otp);
      if (!mounted) return;

      debugPrint('OTP verify result: $result');

      if (result != null && result['token'] != null) {
        final authProvider = context.read<AuthProvider>();
        _apiService.setToken(result['token']);
        await authProvider.login(
            result['token'], Map<String, dynamic>.from(result['user'] ?? {}));

        if (!mounted) return;
        setState(() => _verifying = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        setState(() => _verifying = false);
        if (!mounted) return;
        final errorMsg = result != null
            ? 'Server response missing token: ${result.toString()}'
            : 'No response from server. Please try again.';
        debugPrint('verifyOtp error: $errorMsg');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _verifying = false);
      String message = 'Verification failed';
      final errorStr = e.toString();
      if (errorStr.contains('Cannot connect to server')) {
        message = 'Cannot connect to server. Please check your connection.';
      } else if (errorStr.contains('Invalid OTP') || errorStr.contains('expired OTP')) {
        message = 'Invalid or expired OTP. Please request a new one.';
      } else if (errorStr.contains('OTP expired')) {
        message = 'OTP expired. Please request a new one.';
      } else {
        message = errorStr.replaceFirst('Exception: ', '');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0) return;
    try {
      await _apiService.sendOtp(widget.email);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to resend OTP. Please try again.')),
      );
      _startCooldown();
      return;
    }
    if (!mounted) return;
    _startCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New OTP sent to your phone!'),
        backgroundColor: Color(0xFF25D366),
        duration: Duration(seconds: 2),
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
                        Text(
                          'OTP Verification',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Enter the 6-digit code sent to\n+91 ${widget.email}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (i) {
                            final filled =
                                _controllers[i].text.trim().isNotEmpty;
                            final focused = _nodes[i].hasFocus;
                            return Container(
                              width: (w - 48 - 50) / 6,
                              height: 56,
                              decoration: BoxDecoration(
                                color: filled
                                    ? const Color(0xFFF0F7F2)
                                    : const Color(0xFFF9FAFB),
                                border: Border.all(
                                  color: focused || filled
                                      ? const Color(0xFF0E5A35)
                                      : const Color(0xFFD1D5DB),
                                  width: focused ? 2 : 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Focus(
                                onKeyEvent: (node, event) => _onKey(node, event, i),
                                child: GestureDetector(
                                  onLongPress: _pasteOtp,
                                  child: TextField(
                                    controller: _controllers[i],
                                    focusNode: _nodes[i],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                     cursorColor: const Color(0xFF0E5A35),
                                     style: const TextStyle(
                                       fontSize: 22,
                                       fontWeight: FontWeight.w700,
                                       color: Color(0xFF1A1A1A),
                                     ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (v) => _onChanged(i, v),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: _pasteOtp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F7F2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF0E5A35), width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.content_paste, color: Color(0xFF0E5A35), size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Paste OTP',
                                    style: TextStyle(
                                      color: Color(0xFF0E5A35),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: _isComplete ? _verify : null,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: _isComplete
                                  ? const Color(0xFF0E5A35)
                                  : const Color(0xFFB9C4BD),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: _verifying
                                  ? const SizedBox(
                                      width: 26,
                                      height: 26,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Verify',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive the code? ",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: _resendCooldown > 0 ? null : _resendOtp,
                              child: Text(
                                _resendCooldown > 0
                                    ? 'Resend OTP in ${_resendCooldown}s'
                                    : 'Resend OTP',
                                style: TextStyle(
                                  color: _resendCooldown > 0
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF0E5A35),
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
}
