import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;
import 'dart:js_interop';

Widget buildPlatformNetworkImage({
  required String imageUrl,
  double? width,
  double? height,
  required BoxFit fit,
  BorderRadiusGeometry? borderRadius,
  WidgetBuilder? loadingBuilder,
  Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder,
}) {
  return _WebNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit,
    borderRadius: borderRadius,
    loadingBuilder: loadingBuilder,
    errorBuilder: errorBuilder,
  );
}

class _WebNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder;

  const _WebNetworkImage({
    required this.imageUrl,
    this.width,
    this.height,
    required this.fit,
    this.borderRadius,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<_WebNetworkImage> createState() => _WebNetworkImageState();
}

class _WebNetworkImageState extends State<_WebNetworkImage> {
  late final String viewType;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    viewType = 'web-image-${DateTime.now().microsecondsSinceEpoch}-${widget.imageUrl.hashCode}';
    
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final img = web.HTMLImageElement()
        ..src = widget.imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..style.objectFit = _getBoxFit(widget.fit);

      if (widget.borderRadius != null && widget.borderRadius is BorderRadius) {
        final br = widget.borderRadius as BorderRadius;
        img.style.borderRadius = '${br.topLeft.x}px ${br.topRight.x}px ${br.bottomRight.x}px ${br.bottomLeft.x}px';
      }

      img.onload = (web.Event event) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }.toJS;

      img.onerror = (web.Event event) {
        if (mounted) {
          setState(() {
            isLoading = false;
            hasError = true;
          });
        }
      }.toJS;

      return img;
    });
  }

  String _getBoxFit(BoxFit fit) {
    switch (fit) {
      case BoxFit.contain:
        return 'contain';
      case BoxFit.cover:
        return 'cover';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
      case BoxFit.fitWidth:
      case BoxFit.fitHeight:
        return 'cover'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          HtmlElementView(viewType: viewType),
          if (isLoading && widget.loadingBuilder != null)
            Positioned.fill(
              child: widget.loadingBuilder!(context),
            ),
          if (hasError && widget.errorBuilder != null)
            Positioned.fill(
              child: widget.errorBuilder!(context, Exception('Failed to load web image'), null),
            ),
        ],
      ),
    );
  }
}
