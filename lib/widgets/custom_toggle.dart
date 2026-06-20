import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  const CustomToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 48,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _positionAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.value) _controller.value = 1;
  }

  @override
  void didUpdateWidget(CustomToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.size;
    final width = height * 1.8;
    final thumbSize = height * 0.75;

    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              color: Color.lerp(
                Theme.of(context).colorScheme.onSurface.withAlpha(60),
                Theme.of(context).colorScheme.primary,
                _positionAnim.value,
              ),
              boxShadow: [
                if (_glowAnim.value > 0)
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(
                      (40 * _glowAnim.value).toInt(),
                    ),
                    blurRadius: 12 * _glowAnim.value,
                    spreadRadius: 2 * _glowAnim.value,
                  ),
              ],
            ),
            padding: EdgeInsets.all(height * 0.1),
            child: Align(
              alignment: Alignment(
                -1 + (2 * _positionAnim.value),
                0,
              ),
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
