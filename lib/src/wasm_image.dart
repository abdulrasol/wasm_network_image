import 'package:flutter/material.dart';
import 'platform/image_stub.dart'
    if (dart.library.js_interop) 'platform/image_web.dart'
    if (dart.library.io) 'platform/image_io.dart';

/// A network image widget that works smoothly on Web (WASM) and Native platforms.
class WasmNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  
  /// Widget to show while loading (Web & Native)
  final WidgetBuilder? loadingBuilder;
  
  /// Widget to show on error (Web & Native)
  final Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder;

  const WasmNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return buildPlatformNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
