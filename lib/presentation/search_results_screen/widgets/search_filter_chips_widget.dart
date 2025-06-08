import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchFilterChipsWidget extends StatelessWidget {
  final List<String> categories;
  final List<String> sources;
  final String selectedSource;
  final String selectedCategory;
  final String selectedDateRange;
  final Function(String) onSourceSelected;
  final Function(String) onCategorySelected;
  final Function(String) onDateRangeSelected;
  final VoidCallback onClearFilters;

  const SearchFilterChipsWidget({
    super.key,
    required this.categories,
    required this.sources,
    required this.selectedSource,
    required this.selectedCategory,
    required this.selectedDateRange,
    required this.onSourceSelected,
    required this.onCategorySelected,
    required this.onDateRangeSelected,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasActiveFilters = selectedSource.isNotEmpty ||
        selectedCategory.isNotEmpty ||
        selectedDateRange.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (hasActiveFilters)
                TextButton(
                  onPressed: onClearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: theme.colorScheme.tertiary,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Date Range Filter
                _buildFilterChip(
                  context: context,
                  label: selectedDateRange.isEmpty ? 'Date' : selectedDateRange,
                  isSelected: selectedDateRange.isNotEmpty,
                  onTap: () => _showDateRangeFilter(context),
                ),
                SizedBox(width: 2.w),

                // Source Filter
                _buildFilterChip(
                  context: context,
                  label: selectedSource.isEmpty ? 'Source' : selectedSource,
                  isSelected: selectedSource.isNotEmpty,
                  onTap: () => _showSourceFilter(context),
                ),
                SizedBox(width: 2.w),

                // Category Filter
                _buildFilterChip(
                  context: context,
                  label:
                      selectedCategory.isEmpty ? 'Category' : selectedCategory,
                  isSelected: selectedCategory.isNotEmpty,
                  onTap: () => _showCategoryFilter(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
              : theme.chipTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.tertiary : theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.tertiary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: isSelected
                  ? theme.colorScheme.tertiary
                  : theme.iconTheme.color!.withValues(alpha: 0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangeFilter(BuildContext context) {
    final dateRanges = ['Today', 'This Week', 'This Month', 'All Time'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date Range',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ...dateRanges.map((range) => ListTile(
                  title: Text(range),
                  trailing: selectedDateRange == range
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onDateRangeSelected(range == 'All Time' ? '' : range);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showSourceFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Source',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              title: const Text('All Sources'),
              trailing: selectedSource.isEmpty
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                onSourceSelected('');
              },
            ),
            ...sources.map((source) => ListTile(
                  title: Text(source),
                  trailing: selectedSource == source
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onSourceSelected(source);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              title: const Text('All Categories'),
              trailing: selectedCategory.isEmpty
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                onCategorySelected('');
              },
            ),
            ...categories.map((category) => ListTile(
                  title: Text(category),
                  trailing: selectedCategory == category
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onCategorySelected(category);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
