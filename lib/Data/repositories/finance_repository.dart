import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class FinanceRepository {
  static const String _transactionsKey = 'transactions_list';
  static const String _goalKey = 'monthly_goal';

  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? transactionsJson = prefs.getStringList(_transactionsKey);
    
    if (transactionsJson == null) return [];

    try {
      final List<TransactionModel> transactions = transactionsJson
          .map((json) => TransactionModel.fromJson(json))
          .toList();
      

      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index >= 0) {
      transactions[index] = transaction;
    } else {
      transactions.add(transaction);
    }

    final List<String> transactionsJson = 
        transactions.map((t) => t.toJson()).toList();
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    
    transactions.removeWhere((t) => t.id == id);
    
    final List<String> transactionsJson = 
        transactions.map((t) => t.toJson()).toList();
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  Future<GoalModel?> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? goalJson = prefs.getString(_goalKey);
    
    if (goalJson == null) return null;

    try {
      return GoalModel.fromJson(goalJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveGoal(GoalModel goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalKey, goal.toJson());
  }
}
