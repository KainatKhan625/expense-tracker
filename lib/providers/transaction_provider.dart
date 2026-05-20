import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;
  double get totalBalance {
  return _transactions.fold(0, (sum, t) => 
    t.isIncome ? sum + t.amount : sum - t.amount
  );
}
double get totalIncome {
  return _transactions
    .where((t) => t.isIncome)
    .fold(0, (sum, t) => sum + t.amount);
}

double get totalExpense {
  return _transactions
    .where((t) => !t.isIncome)
    .fold(0, (sum, t) => sum + t.amount);
}

void loadTransactions() {
  var box = Hive.box<Transaction>('transactions');
  _transactions = box.values.toList();
  notifyListeners();
}

void addTransaction(Transaction transaction){
  var box = Hive.box<Transaction>('transactions');
  box.add(transaction);
  _transactions.add(transaction);
  notifyListeners();
}

void deleteTransaction(int index){
  var box = Hive.box<Transaction>('transactions');
  box.deleteAt(index);
  _transactions.removeAt(index);
  notifyListeners();  
}

void editTransaction(int index, String title, double amount, bool isIncome, String category) {
  var box = Hive.box<Transaction>('transactions');
  _transactions[index].title = title;
  _transactions[index].amount = amount;
  _transactions[index].isIncome = isIncome;
  _transactions[index].category = category;
  box.putAt(index, _transactions[index]);
  notifyListeners();
}
}

