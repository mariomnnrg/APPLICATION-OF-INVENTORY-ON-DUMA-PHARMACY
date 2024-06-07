import 'package:flutter/material.dart';

class BoxWithMaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const BoxWithMaxWidth(
      {super.key, required this.child, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: child,
          ),
        ),
      ),
    );
  }
}
