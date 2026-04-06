import 'package:flutter/material.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Widgets/custom_card.dart';

/// Widget for the chart section container
class ChartCard extends StatelessWidget {
  final Widget child;

  const ChartCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 32, bottom: 40),
      child: child,
    );
  }
}

/// Widget for section title
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Text(title, style: AppTextStyles.h3),
    );
  }
}

/// Widget for trend title
class TrendTitle extends StatelessWidget {
  const TrendTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('6-Month Trend', style: AppTextStyles.h3),
    );
  }
}
