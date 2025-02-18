import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  final String imageUrl;

  const ProductImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      ),
    )
        : Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }
}
