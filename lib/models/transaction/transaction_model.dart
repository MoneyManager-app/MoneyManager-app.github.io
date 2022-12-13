import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final CategoryType type;

  @HiveField(4)
  final String typeName;

  @HiveField(5)
  final int amount;

  TransactionModel({
    required this.id,
    required this.date,
    required this.name,
    required this.type,
    required this.typeName,
    required this.amount,
  });
}
