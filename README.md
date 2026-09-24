# wasm_network_image

A modern, zero-dependency Flutter network image widget that provides native, performant image rendering across Web (WASM) and Native platforms.

### 📸 The Problem vs The Solution
Flutter Web (specifically with WASM and CanvasKit) strictly enforces CORS policies. If an external image server doesn't provide permissive CORS headers, the image will fail to render on the canvas, leaving a blank space.

| Without `wasm_network_image` | With `wasm_network_image` |
| :---: | :---: |
| <img src="without.webp" width="300" alt="Broken images due to CORS"/> | <img src="with.webp" width="300" alt="Images rendering perfectly"/> |

## The Solution
`wasm_network_image` solves this by bypassing the canvas rendering constraint on the web. It uses the official `package:web` and modern JS interop (`dart:js_interop`) to dynamically inject a native `HTMLImageElement` via `HtmlElementView` specifically for the web, while seamlessly falling back to the highly optimized `Image.network` on mobile and desktop platforms.

## ✨ Features
- 🚀 **100% WASM Compatible**: Replaces legacy `dart:html` with the modern `package:web`.
- 🎨 **Perfect Web Clipping**: Applies `BorderRadius` directly to the HTML element's CSS. This completely fixes the `ClipRRect` visual bugs when dealing with `HtmlElementView` overlays!
- 🔄 **Smart Loading & Error States**: Supports `loadingBuilder` and `errorBuilder` natively on the Web (by intercepting DOM `onload` and `onerror` events) and on Native platforms.
- 📦 **Zero External Dependencies**: Clean architecture. No bulky caching libraries included.

## Getting started

```yaml
dependencies:
  wasm_network_image: ^0.0.1
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:wasm_network_image/wasm_network_image.dart';

class MyImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WasmNetworkImage(
      imageUrl: 'https://example.com/company-logo.png',
      width: 150,
      height: 150,
      fit: BoxFit.cover,
      
      // Beautifully applied on both Mobile and Web CSS!
      borderRadius: BorderRadius.circular(16), 
      
      // Fires gracefully when the image loads
      loadingBuilder: (context) => const CircularProgressIndicator(),
      
      // Fires if the image link is broken
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
    );
  }
}
```

---
*Programmed with the help of Gemini ❤️*
