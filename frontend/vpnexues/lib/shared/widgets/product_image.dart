import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => errorWidget ?? _defaultError(),
      );
    }
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => errorWidget ?? _defaultError(),
    );
  }

  Widget _defaultError() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE6F4EA),
      child: const Center(
        child: Icon(Icons.image, color: Color(0xFF9CA3AF), size: 40),
      ),
    );
  }
}
