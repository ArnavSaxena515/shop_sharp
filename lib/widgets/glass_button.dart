import 'dart:ui';

import 'package:flutter/material.dart';

class GlassButton extends StatefulWidget {
  const GlassButton({Key? key, required this.child, required this.onTap}) : super(key: key);
  final Widget child;
  final Function onTap;

  @override
  _GlassButtonState createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isBlur = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isBlur = !_isBlur;
          widget.onTap;
        });
      },
      child: GlassMorphism(
        blur: _isBlur ? 20 : 0,
        opacity: 0.2,
        child: SizedBox(
          child: widget.child,
        ),
      ),
    );
  }
}

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({Key? key, required this.blur, required this.opacity, required this.child}) : super(key: key);
  final double blur, opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(width: 1.5, color: Colors.white.withOpacity(0.2))),
          child: child,
        ),
      ),
    );
  }
}
