import 'package:flutter/material.dart';

class ArticleLoadingWidget extends StatelessWidget {
  final double progress;

  const ArticleLoadingWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      child: Column(
        children: [
          // Skeleton content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  _buildSkeletonBox(
                    width: double.infinity,
                    height: 24,
                    theme: theme,
                  ),
                  const SizedBox(height: 8),
                  _buildSkeletonBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 24,
                    theme: theme,
                  ),

                  const SizedBox(height: 24),

                  // Image skeleton
                  _buildSkeletonBox(
                    width: double.infinity,
                    height: 200,
                    theme: theme,
                    borderRadius: 12,
                  ),

                  const SizedBox(height: 24),

                  // Content skeleton
                  ...List.generate(
                      8,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildSkeletonBox(
                              width: index % 3 == 0
                                  ? MediaQuery.of(context).size.width * 0.8
                                  : double.infinity,
                              height: 16,
                              theme: theme,
                            ),
                          )),
                ],
              ),
            ),
          ),

          // Loading indicator
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircularProgressIndicator(
                  value: progress > 0 ? progress : null,
                  color: theme.colorScheme.tertiary,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading article...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (progress > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({
    required double width,
    required double height,
    required ThemeData theme,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: _ShimmerEffect(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                theme.colorScheme.onSurface.withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  final Widget child;

  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * 100, 0),
          child: widget.child,
        );
      },
    );
  }
}
