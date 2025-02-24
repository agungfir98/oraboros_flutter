import 'package:flutter/material.dart';

class CustomGestureDetector extends StatefulWidget {
  const CustomGestureDetector({
    super.key,
    this.onTapDown,
    this.onTapCancel,
    this.onTapUp,
    this.onTap,
    this.child,
  });

  final Function? onTapDown;
  final Function? onTapCancel;
  final Function? onTapUp;
  final Function? onTap;
  final Widget? child;

  @override
  State<CustomGestureDetector> createState() => _CustomGestureDetectorState();
}

class _CustomGestureDetectorState extends State<CustomGestureDetector> {
  double _shadowOffset = 5.0;

  void onTapDown(TapDownDetails details) {
    setState(() => _shadowOffset = 0.0);
    widget.onTapDown?.call();
  }

  void onTapUp(TapUpDetails details) {
    setState(() => _shadowOffset = 5.0);
    widget.onTapUp?.call();
  }

  void onTapCancel() {
    setState(() => _shadowOffset = 5.0);
    widget.onTapCancel?.call();
  }

  void onTap() {
    setState(() => _shadowOffset = 0.0);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _shadowOffset = 5.0);
      }
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      onTap: onTap,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: _shadowOffset, end: _shadowOffset),
        duration: const Duration(microseconds: 100),
        builder: (context, value, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  offset: Offset(value, value),
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
