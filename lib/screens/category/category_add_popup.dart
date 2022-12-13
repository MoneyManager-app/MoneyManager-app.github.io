import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/Transaction/transaction_add.dart';

ValueNotifier<CategoryType> selectedRadioNotifier =
    ValueNotifier(CategoryType.income);

final _categoryNameController = TextEditingController();

Future<void> showAddCategory(BuildContext context) async {
  _categoryNameController.text = '';
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Center(child: Text('Add Category')),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _categoryNameController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  RadioButton(title: 'Income', type: CategoryType.income),
                  RadioButton(title: 'Expense', type: CategoryType.expense)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    if (_categoryNameController.text == '') {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                title: Center(
                                  child: Text('Error Message'),
                                ),
                                titleTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  Divider(),
                                  SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        'please fill empty fields',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                    } else {
                      final newCategory = CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _categoryNameController.text,
                          type: selectedRadioNotifier.value);
                      await CategoryDb().insertCategory(newCategory);
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Add')),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedRadioNotifier,
      builder: (BuildContext context, newValue, Widget? child) => Row(
        children: [
          Radio<CategoryType>(
              value: type,
              groupValue: newValue,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                print(value);
                selectedRadioNotifier.value = value;
                selectedRadioNotifier.notifyListeners();
              }),
          Text(title)
        ],
      ),
    );
  }
}
