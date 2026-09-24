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
  throw UnsupportedError('Cannot play on this platform');
}
