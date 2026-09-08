import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';

class FarmFreshBanner extends StatelessWidget {
  const FarmFreshBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerHeight = Responsive.isSmallPhone(context) ? 155.0 : 165.0;
    final imageWidth = Responsive.isSmallPhone(context) ? 125.0 : (Responsive.isTablet(context) ? 250.0 : 165.0);
    final bigFontSize = Responsive.isSmallPhone(context) ? 22.0 : 24.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: bannerHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFC107),
            Color(0xFFFFD54F),
            Color(0xFFFFCA28),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Green leaves decoration - bottom left
          Positioned(
            left: -10,
            bottom: -10,
            child: CustomPaint(
              size: const Size(80, 80),
              painter: _LeafPainter(),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 5,
            child: CustomPaint(
              size: const Size(60, 60),
              painter: _LeafPainter2(),
            ),
          ),

          // Main content
          Positioned(
            left: 0,
            right: imageWidth,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildBadge('B2B', const Color(0xFF1B5E20)),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8722A),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '&',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildBadge('B2C', const Color(0xFF1B5E20)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FARM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: bigFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FRESH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: bigFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Fresh Stocks Updated Daily',
                      style: TextStyle(
                        color: const Color(0xFF1B5E20),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vegetables image - right side
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: imageWidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?auto=format&fit=crop&w=800&q=80',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFFFFC107),
                  child: const Center(
                    child: Icon(Icons.shopping_basket, color: Colors.white54, size: 60),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width, 0)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.5, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeafPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, size.height)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.2, 0, 0)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.6, size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
