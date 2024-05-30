import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  final double height;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.height,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
          ),
        
        child: Image.asset(
          imagePath, 
          height: height
        )
      ),
    );
  }
}