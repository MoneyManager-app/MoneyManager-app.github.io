import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class Balance {
  Balance._initial();
  static Balance instance = Balance._initial();
  factory Balance() {
    return instance;
  }

  ValueNotifier<int> totalExpense = ValueNotifier(0);
  ValueNotifier<int> totalIncome = ValueNotifier(0);
  ValueNotifier<int> totalBalance = ValueNotifier(0);

  Future<void> typesExpense() async {
    totalExpense.value = 0;
    final _typesExpenseDB =
        await Hive.openBox<TransactionModel>(Transaction_Db_Name);
    final _typesExpense = _typesExpenseDB.values
        .where((val) => val.type == CategoryType.expense)
        .toList();
    Future.forEach(
        _typesExpense,
        (
          val,
        ) =>
            totalExpense.value += val.amount);
    print(totalExpense);
  }

  Future<void> typesIncome() async {
    totalIncome.value = 0;
    final _typesExpenseDB =
        await Hive.openBox<TransactionModel>(Transaction_Db_Name);
    final _typesIncome = _typesExpenseDB.values
        .where((val) => val.type == CategoryType.income)
        .toList();
    Future.forEach(
        _typesIncome,
        (
          val,
        ) =>
            totalIncome.value += val.amount);
    print(totalIncome);
  }

  Future<void> balancing() async {
    await typesExpense();
    await typesIncome();
    totalBalance.value = totalIncome.value - totalExpense.value;
  }
}
