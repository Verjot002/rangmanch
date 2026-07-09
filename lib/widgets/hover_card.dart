import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final Color? glowColor;
  final bool enableScale;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 16,
    this.glowColor,
    this.enableScale = true,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultGlow = widget.glowColor ?? Theme.of(context).primaryColor.withOpacity(0.3);
    final themeBg = widget.backgroundColor ?? Theme.of(context).cardColor;

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: widget.padding ?? const EdgeInsets.all(24),
          transform: widget.enableScale
              ? (Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0)
                ..scale(_isHovered ? 1.03 : 1.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: themeBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered
                  ? (widget.glowColor ?? Theme.of(context).primaryColor)
                  : Colors.white.withOpacity(0.08),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? defaultGlow : Colors.black.withOpacity(0.2),
                blurRadius: _isHovered ? 24 : 12,
                offset: _isHovered ? const Offset(0, 12) : const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
