
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  static const String _placeholderUrl =
      'https://via.placeholder.com/600x400?text=Recipe+Image';

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = imageUrl.isEmpty ? _placeholderUrl : imageUrl;

    return Image.network(
      effectiveUrl,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Use a post-frame callback to avoid logging during build.
        WidgetsBinding.instance.addPostFrameCallback((_) {
            developer.log(
              'Failed to load recipe image. Displaying placeholder.',
              name: 'RecipeImage',
              error: 'URL: $imageUrl, Error: $error',
              level: 900, // Warning level
            );
        });
        // Display a placeholder icon on error.
        return Container(
          height: height,
          width: width,
          color: Colors.grey[350],
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[600],
            size: 48,
          ),
        );
      },
    );
  }
}
