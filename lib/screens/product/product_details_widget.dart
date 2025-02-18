import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatelessWidget {
  final String name;
  final String description;
  final String color;
  final String material;
  final String weight;

  const ProductDetailsWidget({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.material,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.palette, color: Colors.orange),
                title: const Text(
                  'Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(color),
              ),
              ListTile(
                leading: const Icon(Icons.texture, color: Colors.orange),
                title: const Text(
                  'Material',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(material),
              ),
              ListTile(
                leading: const Icon(Icons.line_weight, color: Colors.orange),
                title: const Text(
                  'Weight',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(weight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
