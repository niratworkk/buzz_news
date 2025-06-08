import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final Function(String)? onChanged;
  final bool isVoiceSearchAvailable;
  final VoidCallback? onVoiceSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    this.onChanged,
    this.isVoiceSearchAvailable = false,
    this.onVoiceSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.inputDecorationTheme.enabledBorder!.borderSide.color,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search news articles...',
          hintStyle: theme.inputDecorationTheme.hintStyle,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: theme.iconTheme.color!.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          suffixIcon: isVoiceSearchAvailable
              ? IconButton(
                  onPressed: onVoiceSearch,
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: theme.colorScheme.tertiary,
                    size: 20,
                  ),
                  tooltip: 'Voice search',
                )
              : null,
        ),
      ),
    );
  }
}
