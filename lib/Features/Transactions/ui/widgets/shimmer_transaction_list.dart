import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Widgets/custom_card.dart';

class ShimmerTransactionList extends StatelessWidget {
  final int itemCount;

  const ShimmerTransactionList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return CustomCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.withValues(alpha: 0.2),
                highlightColor: Colors.grey.withValues(alpha: 0.1),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.withValues(alpha: 0.2),
                      highlightColor: Colors.grey.withValues(alpha: 0.1),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.withValues(alpha: 0.2),
                      highlightColor: Colors.grey.withValues(alpha: 0.1),
                      child: Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Shimmer.fromColors(
                baseColor: Colors.grey.withValues(alpha: 0.2),
                highlightColor: Colors.grey.withValues(alpha: 0.1),
                child: Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
