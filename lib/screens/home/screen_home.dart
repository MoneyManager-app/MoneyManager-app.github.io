import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/Transaction/screen_transaction.dart';
import 'package:money_manager/screens/Transaction/transaction_add.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';
import 'package:money_manager/screens/category/screen_category.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final _pages = [ScreenTransaction(), ScreenCategory()];

  @override
  void initState() {
    //TransactionRefreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: MoneyMangerBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: ScreenHome.selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, Widget? child) =>
            _pages[updatedIndex],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (ScreenHome.selectedIndexNotifier.value == 0) {
            print('do transaction');
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ShowAddTransaction();
            }));
          } else {
            print('do category');
            showAddCategory(context);
          }

          // final newCategory = CategoryModel(
          //     id: DateTime.now().millisecondsSinceEpoch.toString(),
          //     name: 'Travel',
          //     type: CategoryType.expense);
          // CategoryDb().insertCategory(newCategory);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
