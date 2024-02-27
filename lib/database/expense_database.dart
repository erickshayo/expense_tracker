import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  /*
  S E T U P
  */
  //initiallize the database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  /*
  GETTERS
  */
  List<Expense> get allExpense => _allExpenses;

  /*
  OPERATIONS
  */
  //Create
  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    await readExpenses();
  }

  //Read
  Future<void> readExpenses() async {
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    notifyListeners();
  }

  //Update
  Future<void> updateExpense(int id, Expense updatedExpense) async {
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    await readExpenses();
  }

  //Delete
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await readExpenses();
  }

/*
  HELPERS
  
  */

  //calculate the total expense for each month
  Future<Map<int, double>> calculateMonthlyTotals() async {
    await readExpenses();
    Map<int, double> monthlyTotals = {};
    for (var expense in _allExpenses) {
      int month = expense.date.month;
      if (monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
      monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }
    return monthlyTotals;
  }

  // get the start month
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }
    _allExpenses.sort((a, b) => a.date.compareTo(b.date));
    return _allExpenses.first.date.month;
  }

  // get the start year
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }
    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.year;
  }
}
