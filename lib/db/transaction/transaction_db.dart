import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/db/Balance/balance_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

const Transaction_Db_Name = 'Transaction_Database';

ValueNotifier<List<TransactionModelDemo>> transactionListNotifier =
    ValueNotifier([]);

abstract class TransactionDbfunctions {
  Future<void> insertTransaction(TransactionModel value);
  Future<void> TransactionRefreshUI();
}

class TransactionDB implements TransactionDbfunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  Future<void> insertTransaction(TransactionModel value) async {
    final _TransactionDB =
        await Hive.openBox<TransactionModel>(Transaction_Db_Name);
    _TransactionDB.add(value);
    await TransactionRefreshUI();
  }

  Future<void> deleteTrans(TransactionModelDemo value) async {
    final _TransactionDB =
        await Hive.openBox<TransactionModel>(Transaction_Db_Name);
    int i = 0;
    Future.forEach(_TransactionDB.values, (val) {
      if (value.id == val.id) {
        _TransactionDB.deleteAt(i);
      }
      i++;
    });
    //_TransactionDB.deleteAt(index);

    await TransactionRefreshUI();
  }

  Future<void> deleteAllTrans() async {
    final _TransactionDB =
        await Hive.openBox<TransactionModel>(Transaction_Db_Name);
    await _TransactionDB.clear();
    await TransactionRefreshUI();
  }

  Future<void> TransactionRefreshUI() async {
    Balance.instance.balancing();
    final _TransactionDB =
        await Hive.openBox<TransactionModel>(Transaction_Db_Name);
    transactionListNotifier.value.clear();

    final transactionList = _TransactionDB.values.toList();
    for (var i = 0; i < transactionList.length; i++) {
      DateTime oldDate = transactionList[i].date;
      String newDate = await dateFormatCorrection(oldDate);
      String id = transactionList[i].id;
      String name = transactionList[i].name;
      CategoryType type = transactionList[i].type;
      String typeName = transactionList[i].typeName;
      int amount = transactionList[i].amount;

      TransactionModelDemo newList = TransactionModelDemo(
          id: id,
          date: newDate,
          name: name,
          type: type,
          typeName: typeName,
          amount: amount);
      transactionListNotifier.value.add(newList);
      //transactionList[i].date.replaceRange(0, null, newDate);
      print(transactionList[i].date);
    }
    transactionListNotifier.value.sort((first, second) =>
        first.date != second.date
            ? second.date.compareTo(first.date)
            : second.id.compareTo(first.id));
    transactionListNotifier.notifyListeners();
  }
}

Future<String> dateFormatCorrection(DateTime dateValue) async {
  String date = dateValue.toString();
  String correctDate;

  switch (date.split('-')[1]) {
    case '01':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Jan-${date.split('-')[0]}";
      }
      return correctDate;
    case '02':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Feb-${date.split('-')[0]}";
      }
      return correctDate;
    case '03':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Mar-${date.split('-')[0]}";
      }
      return correctDate;
    case '04':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Apr-${date.split('-')[0]}";
      }
      return correctDate;
    case '05':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-May-${date.split('-')[0]}";
      }
      return correctDate;
    case '06':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Jun-${date.split('-')[0]}";
      }
      return correctDate;
    case '07':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Jul-${date.split('-')[0]}";
      }
      return correctDate;
    case '08':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Aug-${date.split('-')[0]}";
      }
      return correctDate;
    case '09':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Sep-${date.split('-')[0]}";
      }
      return correctDate;
    case '10':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Oct-${date.split('-')[0]}";
      }
      return correctDate;
    case '11':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Nov-${date.split('-')[0]}";
      }
      return correctDate;
    case '12':
      {
        correctDate =
            "${date.split('-')[2].split(' ')[0]}-Dec-${date.split('-')[0]}";
        print('Month is December');
      }
      return correctDate;
    default:
      {
        date = date;
        print('date is not corrected');
      }
      return date;
  }
}

class TransactionModelDemo {
  final String id;
  final String date;
  final String name;
  final CategoryType type;
  final String typeName;
  final int amount;

  TransactionModelDemo(
      {required this.id,
      required this.date,
      required this.name,
      required this.type,
      required this.typeName,
      required this.amount});
}
