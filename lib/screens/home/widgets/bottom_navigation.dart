import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/screens/home/screen_home.dart';

class MoneyMangerBottomNavigation extends StatelessWidget {
  const MoneyMangerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext context, int updatedIndex, Widget? child) =>
          BottomNavigationBar(
              currentIndex: updatedIndex,
              onTap: (newIndex) =>
                  ScreenHome.selectedIndexNotifier.value = newIndex,
              items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories')
          ]),
    );
  }
}
