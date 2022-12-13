import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screens/category/expense_category_list.dart';
import 'package:money_manager/screens/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    /*
    CategoryDb().getCategories().then((
      value,
    ) {
      for (var i = 0; i < value.length; i++) {
        print('categories: ${value[i].name} type: ${value[i].type}');
      }
    });
    super.initState();
    CategoryDb().incomeCategoryNotifier.notifyListeners();
    CategoryDb().expenseCategoryNotifier.notifyListeners();
    */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              )
            ]),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: [IncomeCategoryList(), ExpenseCategoryList()]),
        )
      ],
    );
  }
}
