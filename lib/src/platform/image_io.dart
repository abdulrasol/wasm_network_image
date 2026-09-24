import 'package:flutter/material.dart';

Widget buildPlatformNetworkImage({
  required String imageUrl,
  double? width,
  double? height,
  required BoxFit fit,
  BorderRadiusGeometry? borderRadius,
  WidgetBuilder? loadingBuilder,
  Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder,
}) {
  Widget imageWidget = Image.network(
    imageUrl,
    width: width,
    height: height,
    fit: fit,
    loadingBuilder: loadingBuilder != null
        ? (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return loadingBuilder(context);
          }
        : null,
    errorBuilder: errorBuilder,
  );

  if (borderRadius != null) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: imageWidget,
    );
  }

  return imageWidget;
}
