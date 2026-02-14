import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/philosopher_assets.dart';

class PhilosopherImage extends StatelessWidget {
  final String philosopherName;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool useDeepDiveVariant;
  final WidgetBuilder? placeholderBuilder;

  const PhilosopherImage({
    super.key,
    required this.philosopherName,
    this.useDeepDiveVariant = false,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.placeholderBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = useDeepDiveVariant
        ? PhilosopherAssets.getDeepDiveImage(philosopherName)
        : PhilosopherAssets.getImage(philosopherName);
    
    final isSvg = assetPath.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: placeholderBuilder,
      );
    } else {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (placeholderBuilder != null) {
            return placeholderBuilder!(context);
          }
          return const Icon(Icons.error_outline);
        },
      );
    }
  }
}
