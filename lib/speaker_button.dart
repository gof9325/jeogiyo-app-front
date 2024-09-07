import 'package:flutter/material.dart';

class SpeakerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double iconSize;
  const SpeakerButton({
    super.key,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      onPressed: onPressed,
      icon: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        child: Icon(
          size: iconSize,
          Icons.mic,
        ),
      ),
    );
  }
}
