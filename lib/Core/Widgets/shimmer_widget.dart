import 'package:flutter/material.dart';
import '../Colors/app_colors.dart';

/// Shimmer effect widget for loading states
class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerWidget({
    required this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
              colors: [
                AppColors.border.withValues(alpha: 0.3),
                AppColors.border.withValues(alpha: 0.6),
                AppColors.border.withValues(alpha: 0.3),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer loading list tile
class ShimmerListTile extends StatelessWidget {
  final BorderRadius? borderRadius;

  const ShimmerListTile({this.borderRadius, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ShimmerWidget(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading chart placeholder
class ShimmerChart extends StatelessWidget {
  const ShimmerChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          ShimmerWidget(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 24,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          ShimmerWidget(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          ShimmerWidget(
            width: double.infinity,
            height: 250,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading card
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerCard({
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ShimmerWidget(
        width: width,
        height: height,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
    );
  }
}

/// Full page shimmer loading skeleton
class ShimmerLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const ShimmerLoadingSkeleton({this.itemCount = 5, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ShimmerCard(height: 80)),
        SliverList.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) => ShimmerListTile(),
        ),
      ],
    );
  }
}
