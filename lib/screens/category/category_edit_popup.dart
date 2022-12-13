import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';

final _nameController = TextEditingController();
Future<void> showEditPopup(BuildContext context, CategoryModel Ctvalue) async {
  _nameController.text = Ctvalue.name;
  selectedRadioNotifier.value = Ctvalue.type;
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
            title: Center(child: Text('Edit Category')),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nameController,
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
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      final newCategory = CategoryModel(
                          id: Ctvalue.id,
                          name: _nameController.text,
                          type: selectedRadioNotifier.value);
                      CategoryDb().editCategory(newCategory);
                      Navigator.of(context).pop();
                    },
                    child: Text('Edit')),
              )
            ]);
      });
}

/*
class RadioButton1 extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton1({super.key, required this.title, required this.type});

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
*/