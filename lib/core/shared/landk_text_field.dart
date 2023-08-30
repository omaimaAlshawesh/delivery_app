import 'package:flutter/material.dart';

class LandkTextField extends StatelessWidget {
  const LandkTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.padding,
    required this.prefix,
  });

  final TextEditingController controller;
  final String label;
  final EdgeInsets padding;
  final Widget prefix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            label: Text(label),
            prefixIcon: prefix),
      ),
    );
  }
}
