import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchSkeletonLoaderWidget extends StatefulWidget {
  const SearchSkeletonLoaderWidget({super.key});

  @override
  State<SearchSkeletonLoaderWidget> createState() =>
      _SearchSkeletonLoaderWidgetState();
}

class _SearchSkeletonLoaderWidgetState extends State<SearchSkeletonLoaderWidget>
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 2.h),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image skeleton
                    Container(
                      width: 20.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                        color: theme.dividerColor
                            .withValues(alpha: _animation.value),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 3.w),

                    // Content skeleton
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title skeleton
                          Container(
                            height: 2.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.dividerColor
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            height: 2.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: theme.dividerColor
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          // Description skeleton
                          Container(
                            height: 1.5.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.dividerColor
                                  .withValues(alpha: _animation.value * 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            height: 1.5.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: theme.dividerColor
                                  .withValues(alpha: _animation.value * 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            height: 1.5.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: theme.dividerColor
                                  .withValues(alpha: _animation.value * 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          // Source and date skeleton
                          Row(
                            children: [
                              Container(
                                height: 1.2.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  color: theme.dividerColor.withValues(
                                      alpha: _animation.value * 0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 1.2.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  color: theme.dividerColor.withValues(
                                      alpha: _animation.value * 0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Bookmark skeleton
                    Column(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: theme.dividerColor
                                .withValues(alpha: _animation.value * 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
