// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSizeBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData icon;

  const CustomSizeBox({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: FaIcon(
            icon,
            size: 30,
          ),
        ),
        Text(text)
      ],
    );
  }
}
