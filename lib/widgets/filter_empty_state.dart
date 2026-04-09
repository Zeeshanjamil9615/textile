import 'package:flutter/material.dart';

/// Centered empty state for filter-driven list screens: before first successful
/// load vs after load with no matching rows.
class FilterEmptyState extends StatelessWidget {
  const FilterEmptyState({
    super.key,
    required this.hasLoadedData,

    /// Shown when the user has not applied filters / loaded data yet.
    this.messageBeforeApply,

    /// Shown after data was loaded (or list is empty after search/filter).
    this.messageNoResults,
    this.icon = Icons.filter_list,
  });

  /// `false` until the user has successfully loaded data at least once (e.g. Apply).
  /// For screens that auto-fetch on open, pass `true` so only [messageNoResults] is used.
  final bool hasLoadedData;

  final String? messageBeforeApply;
  final String? messageNoResults;
  final IconData icon;

  static const String defaultBeforeApply =
      'Choose your filters, then tap Apply to load results.';

  static const String defaultNoResults =
      'No results match your filters. Try adjusting your search.';

  @override
  Widget build(BuildContext context) {
    final text = hasLoadedData
        ? (messageNoResults ?? defaultNoResults)
        : (messageBeforeApply ?? defaultBeforeApply);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
