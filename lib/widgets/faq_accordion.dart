import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';

class FaqAccordionTile extends StatefulWidget {
  final String question;
  final String answer;

  const FaqAccordionTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqAccordionTile> createState() => _FaqAccordionTileState();
}

class _FaqAccordionTileState extends State<FaqAccordionTile> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: _isExpanded 
                ? AppColors.cardBg 
                : (_isHovered ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.02)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isExpanded 
                  ? AppColors.primary.withOpacity(0.6) 
                  : (_isHovered ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.08)),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isExpanded ? AppColors.secondary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _iconRotation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _iconRotation.value,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: _isExpanded ? AppColors.secondary : AppColors.textSecondary,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: _isExpanded
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        child: Text(
                          widget.answer,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
