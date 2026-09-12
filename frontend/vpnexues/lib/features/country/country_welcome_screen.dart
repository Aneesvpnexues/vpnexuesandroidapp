import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/models/country_config.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import '../auth/login/login_screen.dart';

class CountryWelcomeScreen extends StatelessWidget {
  final CountryConfig countryConfig;

  const CountryWelcomeScreen({
    super.key,
    required this.countryConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section - background image with logo
          Expanded(
            flex: 55,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F6F2),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/welcome_background.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return CustomPaint(
                          painter: _VeggiePatternPainter(),
                        );
                      },
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: Responsive.isSmallPhone(context) ? 20 : 40),
                        // Logo circle
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF0E5A35),
                                  ),
                                  child: const Icon(
                                    Icons.eco,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'VP NEXUES',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B5E20),
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'FRESH. ORGANIC. DELIVERED.',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom section - white card
          Expanded(
            flex: 45,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'VP Nexues!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We're excited to have you on board. Get ready\nto enjoy fresh, organic groceries delivered to your\ndoorstep.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Get Started button
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Responsive.isSmallPhone(context) ? 30 : 50,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VeggiePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1.5;

    final items = <_VeggieItem>[
      _VeggieItem(Offset(size.width * 0.1, size.height * 0.08), 12, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.35, size.height * 0.05), 10, _VeggieType.cross),
      _VeggieItem(Offset(size.width * 0.65, size.height * 0.1), 8, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.88, size.height * 0.06), 11, _VeggieType.carrot),
      _VeggieItem(Offset(size.width * 0.15, size.height * 0.22), 14, _VeggieType.broccoli),
      _VeggieItem(Offset(size.width * 0.5, size.height * 0.18), 9, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.82, size.height * 0.2), 10, _VeggieType.cross),
      _VeggieItem(Offset(size.width * 0.08, size.height * 0.4), 11, _VeggieType.location),
      _VeggieItem(Offset(size.width * 0.42, size.height * 0.35), 13, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.72, size.height * 0.38), 9, _VeggieType.broccoli),
      _VeggieItem(Offset(size.width * 0.92, size.height * 0.42), 10, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.25, size.height * 0.55), 8, _VeggieType.cross),
      _VeggieItem(Offset(size.width * 0.6, size.height * 0.52), 12, _VeggieType.carrot),
      _VeggieItem(Offset(size.width * 0.05, size.height * 0.65), 10, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.48, size.height * 0.68), 9, _VeggieType.location),
      _VeggieItem(Offset(size.width * 0.78, size.height * 0.62), 11, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.3, size.height * 0.78), 10, _VeggieType.broccoli),
      _VeggieItem(Offset(size.width * 0.9, size.height * 0.8), 8, _VeggieType.cross),
      _VeggieItem(Offset(size.width * 0.12, size.height * 0.85), 11, _VeggieType.leaf),
      _VeggieItem(Offset(size.width * 0.55, size.height * 0.85), 10, _VeggieType.leaf),
    ];

    for (final item in items) {
      paint.color = const Color(0xFF2E7D32).withValues(alpha: 0.35);

      switch (item.type) {
        case _VeggieType.leaf:
          _drawLeaf(canvas, item.center, item.size, paint);
          break;
        case _VeggieType.cross:
          _drawCross(canvas, item.center, item.size, paint);
          break;
        case _VeggieType.carrot:
          _drawCarrot(canvas, item.center, item.size, paint);
          break;
        case _VeggieType.broccoli:
          _drawBroccoli(canvas, item.center, item.size, paint);
          break;
        case _VeggieType.location:
          _drawLocationPin(canvas, item.center, item.size, paint);
          break;
      }
    }
  }

  void _drawLeaf(Canvas canvas, Offset center, double size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(center.dx, center.dy + size);
    path.quadraticBezierTo(center.dx - size, center.dy, center.dx, center.dy - size);
    path.quadraticBezierTo(center.dx + size, center.dy, center.dx, center.dy + size);
    canvas.drawPath(path, paint);
    canvas.drawLine(
      Offset(center.dx, center.dy + size),
      Offset(center.dx, center.dy - size * 0.2),
      paint,
    );
  }

  void _drawCross(Canvas canvas, Offset center, double size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx - size, center.dy),
      Offset(center.dx + size, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size),
      Offset(center.dx, center.dy + size),
      paint,
    );
  }

  void _drawCarrot(Canvas canvas, Offset center, double size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(center.dx - size * 0.4, center.dy - size * 0.5);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx + size * 0.4, center.dy - size * 0.5);
    canvas.drawPath(path, paint);
    canvas.drawLine(
      Offset(center.dx, center.dy - size * 0.5),
      Offset(center.dx - size * 0.3, center.dy - size),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size * 0.5),
      Offset(center.dx + size * 0.3, center.dy - size),
      paint,
    );
  }

  void _drawBroccoli(Canvas canvas, Offset center, double size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx, center.dy + size),
      Offset(center.dx, center.dy),
      paint,
    );
    final circleRadius = size * 0.45;
    canvas.drawCircle(Offset(center.dx, center.dy - circleRadius * 0.3), circleRadius, paint);
    canvas.drawCircle(Offset(center.dx - circleRadius * 0.6, center.dy), circleRadius * 0.7, paint);
    canvas.drawCircle(Offset(center.dx + circleRadius * 0.6, center.dy), circleRadius * 0.7, paint);
  }

  void _drawLocationPin(Canvas canvas, Offset center, double size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    final path = Path();
    path.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy - size * 0.3),
      width: size * 1.2,
      height: size * 1.2,
    ));
    path.moveTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size * 0.4, center.dy);
    path.moveTo(center.dx, center.dy + size);
    path.lineTo(center.dx + size * 0.4, center.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _VeggieType { leaf, cross, carrot, broccoli, location }

class _VeggieItem {
  final Offset center;
  final double size;
  final _VeggieType type;

  const _VeggieItem(this.center, this.size, this.type);
}
