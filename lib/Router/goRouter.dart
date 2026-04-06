import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../Data/models/transaction_model.dart';
import '../Features/Dashboard/Bloc/dashboard_bloc.dart';
import '../Features/Dashboard/ui/dashboard_screen.dart';
import '../Features/Goals/Bloc/goals_bloc.dart';
import '../Features/Goals/ui/goals_screen.dart';
import '../Features/Insights/Bloc/insights_bloc.dart';
import '../Features/Insights/ui/insights_screen.dart';
import '../Features/MainWrapper.dart';
import '../Features/Transactions/Bloc/transactions_bloc.dart';
import '../Features/Transactions/ui/add_transaction_screen.dart';
import '../Features/Transactions/ui/transactions_screen.dart';
import 'routerConstant.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorDashboardKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellDashboard');
final GlobalKey<NavigatorState> _shellNavigatorTransactionsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTransactions');
final GlobalKey<NavigatorState> _shellNavigatorGoalsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellGoals');
final GlobalKey<NavigatorState> _shellNavigatorInsightsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellInsights');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouterConstants.dashboard,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainWrapper(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDashboardKey,
          routes: [
            GoRoute(
              path: RouterConstants.dashboard,
              builder: (context, state) {
                context.read<DashboardBloc>().add(LoadDashboard());
                return const DashboardScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTransactionsKey,
          routes: [
            GoRoute(
              path: RouterConstants.transactions,
              builder: (context, state) {
                context.read<TransactionsBloc>().add(LoadTransactions());
                return const TransactionsScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorGoalsKey,
          routes: [
            GoRoute(
              path: RouterConstants.goals,
              builder: (context, state) {
                context.read<GoalsBloc>().add(LoadGoal());
                return const GoalsScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorInsightsKey,
          routes: [
            GoRoute(
              path: RouterConstants.insights,
              builder: (context, state) {
                context.read<InsightsBloc>().add(LoadInsights());
                return const InsightsScreen();
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouterConstants.addTransaction,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/edit-transaction',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final transaction = state.extra as TransactionModel?;
        return AddTransactionScreen(transaction: transaction);
      },
    ),
  ],
);
