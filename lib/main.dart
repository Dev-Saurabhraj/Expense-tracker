import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Core/Colors/app_colors.dart';
import 'Data/repositories/finance_repository.dart';
import 'Features/Dashboard/Bloc/dashboard_bloc.dart';
import 'Features/Goals/Bloc/goals_bloc.dart';
import 'Features/Insights/Bloc/insights_bloc.dart';
import 'Features/Transactions/Bloc/transactions_bloc.dart';
import 'Router/goRouter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final financeRepository = FinanceRepository();
  runApp(ExpenseTrackerApp(repository: financeRepository));
}

class ExpenseTrackerApp extends StatelessWidget {
  final FinanceRepository repository;

  const ExpenseTrackerApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionsBloc>(
          create: (context) => TransactionsBloc(repository: repository)..add(LoadTransactions()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(repository: repository)..add(LoadDashboard()),
        ),
        BlocProvider<GoalsBloc>(
          create: (context) => GoalsBloc(repository: repository)..add(LoadGoal()),
        ),
        BlocProvider<InsightsBloc>(
          create: (context) => InsightsBloc(repository: repository)..add(LoadInsights()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
