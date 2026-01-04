import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FilterChipSkeleton extends StatelessWidget {
  const FilterChipSkeleton({
    super.key,
    this.count = 5,
    this.spacing = 8.0,
  });

  final int count;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(count, (index) {
          final rightPadding = index == count - 1 ? 0.0 : spacing;

          return Padding(
            padding: EdgeInsets.only(right: rightPadding),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                height: 32,
                width: 80 + (index * 10) % 40, // Varying widths
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
