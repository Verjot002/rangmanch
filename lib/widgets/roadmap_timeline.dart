import 'package:flutter/material.dart';
import '../theme.dart';

class RoadmapStep {
  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;

  const RoadmapStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class RoadmapTimeline extends StatelessWidget {
  final List<RoadmapStep> steps;

  const RoadmapTimeline({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return isMobile ? _buildMobileTimeline() : _buildDesktopTimeline();
  }

  Widget _buildDesktopTimeline() {
    return Stack(
      children: [
        // Center Line
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        // Alternating steps
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            final isLeft = index % 2 == 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  // Left Side Content
                  Expanded(
                    child: isLeft
                        ? _TimelineCard(step: step, alignRight: true)
                        : const SizedBox.shrink(),
                  ),
                  // Middle Circle Indicator
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: _TimelineIndicator(
                      stepNumber: step.stepNumber,
                      icon: step.icon,
                    ),
                  ),
                  // Right Side Content
                  Expanded(
                    child: !isLeft
                        ? _TimelineCard(step: step, alignRight: false)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMobileTimeline() {
    return Stack(
      children: [
        // Left-aligned Line
        Positioned(
          top: 8,
          bottom: 8,
          left: 20,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.primary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];

            return Padding(
              padding: const EdgeInsets.only(left: 48, top: 16, bottom: 16, right: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Left indicator positioned absolute relative to left alignment
                  Positioned(
                    left: -48,
                    top: 12,
                    child: SizedBox(
                      width: 40,
                      child: _TimelineIndicator(
                        stepNumber: step.stepNumber,
                        icon: step.icon,
                        size: 32,
                      ),
                    ),
                  ),
                  _TimelineCard(step: step, alignRight: false),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TimelineIndicator extends StatefulWidget {
  final String stepNumber;
  final IconData icon;
  final double size;

  const _TimelineIndicator({
    required this.stepNumber,
    required this.icon,
    this.size = 40,
  });

  @override
  State<_TimelineIndicator> createState() => _TimelineIndicatorState();
}

class _TimelineIndicatorState extends State<_TimelineIndicator> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isHovered ? widget.size + 8 : widget.size,
        height: _isHovered ? widget.size + 8 : widget.size,
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.secondary : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: _isHovered ? Colors.white : AppColors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (_isHovered ? AppColors.secondary : AppColors.primary).withOpacity(0.6),
              blurRadius: _isHovered ? 16 : 6,
              spreadRadius: _isHovered ? 3 : 1,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.size * 0.45,
            color: _isHovered ? Colors.black : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _TimelineCard extends StatefulWidget {
  final RoadmapStep step;
  final bool alignRight;

  const _TimelineCard({
    required this.step,
    required this.alignRight,
  });

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(
          left: widget.alignRight ? 40 : 16,
          right: widget.alignRight ? 16 : 40,
        ),
        transform: Matrix4.identity()..translate(_isHovered ? (widget.alignRight ? -8.0 : 8.0) : 0.0, 0.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.cardBg : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.primary : Colors.white.withOpacity(0.08),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.2),
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "STEP ${widget.step.stepNumber}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(
                  widget.step.icon,
                  color: AppColors.primary.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.step.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.step.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
