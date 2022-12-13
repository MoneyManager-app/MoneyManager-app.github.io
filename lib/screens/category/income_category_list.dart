import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/category/category_edit_popup.dart';

class IncomeCategoryList extends StatelessWidget {
  IncomeCategoryList({super.key});

  final incomeCategories = CategoryDb().incomeCategoryNotifier;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: incomeCategories,
        builder: (BuildContext context, newValue, Widget? child) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.rightSlide,
                              title: 'Confirm Delete',
                              desc:
                                  'Do you want delete all Income types permanently...',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                await CategoryDb.instance
                                    .deleteAllCategories(CategoryType.income);
                              },
                            )..show();
                          },
                          child: Text('Delete All')),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) => Card(
                            child: ListTile(
                              title: Text(newValue[index].name),
                              trailing: SizedBox(
                                height: double.infinity,
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        showEditPopup(context, newValue[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.rightSlide,
                                          title: 'Confirm Delete Category',
                                          desc:
                                              'Do you want delete ${newValue[index].name} Category permanently...',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            CategoryDb().deleteCategory(
                                                newValue[index]);
                                          },
                                        )..show();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      separatorBuilder: (CopySelectionTextIntent, index) =>
                          SizedBox(
                            height: 10,
                          ),
                      itemCount: newValue.length),
                ),
              ],
            ));
  }
}
