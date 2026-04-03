import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Core/Colors/app_colors.dart';
import '../../Core/Icons/app_icons.dart';
import 'Dashboard/Bloc/dashboard_bloc.dart';
import 'Transactions/Bloc/transactions_bloc.dart';
import 'Goals/Bloc/goals_bloc.dart';
import 'Insights/Bloc/insights_bloc.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {

            if (index == 0) context.read<DashboardBloc>().add(LoadDashboard());
            if (index == 1) context.read<TransactionsBloc>().add(LoadTransactions());
            if (index == 2) context.read<GoalsBloc>().add(LoadGoal());
            if (index == 3) context.read<InsightsBloc>().add(LoadInsights());

            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(AppIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.transactions),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.goals),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.insights),
              label: 'Insights',
            ),
          ],
        ),
      ),
    );
  }
}
