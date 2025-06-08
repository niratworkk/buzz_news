import 'package:flutter/material.dart';

class NewsSkeletonCardWidget extends StatefulWidget {
  const NewsSkeletonCardWidget({super.key});

  @override
  State<NewsSkeletonCardWidget> createState() => _NewsSkeletonCardWidgetState();
}

class _NewsSkeletonCardWidgetState extends State<NewsSkeletonCardWidget>
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
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      shape: theme.cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonThumbnail(context),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSkeletonContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonThumbnail(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonLine(context, width: double.infinity),
                  const SizedBox(height: 4),
                  _buildSkeletonLine(context, width: 200),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildSkeletonLine(context, width: 24, height: 24),
          ],
        ),
        const SizedBox(height: 12),
        _buildSkeletonLine(context, width: double.infinity),
        const SizedBox(height: 4),
        _buildSkeletonLine(context, width: double.infinity),
        const SizedBox(height: 4),
        _buildSkeletonLine(context, width: 150),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSkeletonLine(context, width: 80),
            const Spacer(),
            _buildSkeletonLine(context, width: 100),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonLine(
    BuildContext context, {
    required double width,
    double height = 16,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
