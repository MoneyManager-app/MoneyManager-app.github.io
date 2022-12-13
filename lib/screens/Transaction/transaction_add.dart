import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

import '../category/category_add_popup.dart';

//final _dateController = TextEditingController();
DateTime? selectedDate;
TextEditingController _nameController = TextEditingController();
CategoryType? dropDownValue;
ValueNotifier<List<CategoryModel>> dropDownListNotifier = ValueNotifier([]);
String? _dropDownName;
TextEditingController _amountController = TextEditingController();

//ValueNotifier<List<String>> _typeNamelistNotifier = ValueNotifier([]);

class ShowAddTransaction extends StatefulWidget {
  ShowAddTransaction({super.key});

  @override
  State<ShowAddTransaction> createState() => _ShowAddTransactionState();
}

DateTime showDate = DateTime.now();

class _ShowAddTransactionState extends State<ShowAddTransaction> {
  final List<CategoryType> _typeList = [
    CategoryType.income,
    CategoryType.expense
  ];

  //String showingDate =
  //    '${showDate.toLocal().day}/${showDate.toLocal().month}/${showDate.toLocal().year}';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //_dateController.text = showingDate;
    selectedDate = null;
    dropDownListNotifier;
    _nameController.text = '';
    dropDownValue = null;
    _dropDownName = '';
    _amountController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 400,
                width: 300,
                child: Column(children: [
                  /*
                  InputDatePickerFormField(
                    // decoration: const InputDecoration(
                    //   hintStyle: TextStyle(color: Colors.black45),
                    //   errorStyle: TextStyle(color: Colors.redAccent),
                    //   border: OutlineInputBorder(),
                    //   suffixIcon: Icon(Icons.event_note),
                    //   labelText: 'My Super Date Time Field',
                    // ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    lastDate: DateTime.now().add(const Duration(days: 40)),
                    initialDate: DateTime.now().add(const Duration(days: 20)),
                    onDateSubmitted: (DateTime value) {
                      print(value);
                    },
                  ),*/

                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    // onSaved: (newValue) =>
                    //     _nameController.text = newValue.toString(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Purpose',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    decoration: InputDecoration(
                      prefix: Text('₹'),
                      border: OutlineInputBorder(),
                      hintText: 'Amount',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton.icon(
                      onPressed: () async {
                        final selectedDateTemp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 30)),
                            //DateTime.now().subtract(Duration(days: 30)),
                            lastDate: DateTime.now());
                        setState(() {
                          selectedDate = selectedDateTemp;
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                      label: (selectedDate == null)
                          ? Text('Select Date')
                          : Text('${selectedDate.toString().split(' ')[0]}')),
                  // TextFormField(
                  //   onSaved: (newValue) {
                  //     DateTime selecteDate = DateTime.now();
                  //     String selectedDate =
                  //         '${selecteDate.toLocal().day}/${selecteDate.toLocal().month}/${selecteDate.toLocal().year}';
                  //     //_dateController.text = newValue.toString();
                  //     _dateController.text = selectedDate;
                  //     if (newValue != null) {
                  //       _dateController.text = newValue;
                  //       print('new value : $newValue');
                  //     }
                  //   },
                  //   controller: _dateController,
                  //   //keyboardType: TextInputType.datetime,
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Date',
                  //       icon: Icon(Icons.calendar_today)),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'please enter Date';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // InputDatePickerFormField(
                  //     initialDate: DateTime.now(),
                  //     firstDate: DateTime.now(),
                  //     lastDate: DateTime.now()),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    items: _typeList
                        .map((e) =>
                            DropdownMenuItem(child: Text(e.name), value: e))
                        .toList(),
                    onChanged: (value) async {
                      setState(() {
                        dropDownValue = value;
                        dropDownListNotifier.value.clear();
                        dropDownListNotifier.value.addAll(
                            (value == CategoryType.income)
                                ? CategoryDb().incomeCategoryNotifier.value
                                : CategoryDb().expenseCategoryNotifier.value);
                        CategoryDb().refreshUI();
                        dropDownListNotifier.notifyListeners();
                      });

                      //await changeTypeNameOnSelect(value!);
                      print(value);
                    },
                    hint: Text('Select Type'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: dropDownListNotifier,
                            builder: (BuildContext context, newValue,
                                    Widget? child) =>
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  //value: _dropDownName,
                                  /*
                                  onTap: () async {
                                    dropDownListNotifier.value.clear();
                                    dropDownListNotifier.value.addAll(
                                        (dropDownValue == CategoryType.income)
                                            ? CategoryDb()
                                                .incomeCategoryNotifier
                                                .value
                                            : CategoryDb()
                                                .expenseCategoryNotifier
                                                .value);

                                    dropDownListNotifier.notifyListeners();
                                  },
                                  */
                                  items: newValue
                                      .map((e) => DropdownMenuItem(
                                          child: Text(e.name), value: e.name))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _dropDownName = val;
                                    });

                                    print(val);
                                  },
                                  hint: Text('Select Type Name'),
                                )),
                        /*
                        ValueListenableBuilder(
                          valueListenable: _typeNamelistNotifier,
                          builder: (BuildContext context, listValue,
                                  Widget? child) =>
                              DropdownButtonFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            items: listValue
                                .map((e) =>
                                    DropdownMenuItem(child: Text(e), value: e))
                                .toList(),
                            onChanged: (value) {
                              _dropDownName = value;
                              print(value);
                            },
                            hint: Text('Select Type Name'),
                          ),
                        ),
                        */
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await showAddCategory(context);
                          },
                          child: Center(child: Text('Add new\nCategory')))
                    ],
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   _formKey.currentState!.save();
                        // }

                        if (selectedDate == null ||
                            _nameController.text.isEmpty ||
                            dropDownValue == null ||
                            _dropDownName!.isEmpty ||
                            _amountController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                    title: Center(
                                      child: Text('Error Message'),
                                    ),
                                    titleTextStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    children: [
                                      Divider(
                                        thickness: 3,
                                      ),
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
                          final newTransaction = TransactionModel(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              date: selectedDate!,
                              name: _nameController.text,
                              type: dropDownValue!,
                              typeName: _dropDownName!,
                              amount: int.parse(_amountController.text));
                          TransactionDB().insertTransaction(newTransaction);

                          print(
                              'id ${newTransaction.id} date: ${newTransaction.date} name: ${newTransaction.name} type: ${newTransaction.type} amount ${newTransaction.amount}');

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Add'))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshDropDownNameList() async {
    List<CategoryModel> newDropValue = (dropDownValue == CategoryType.expense)
        ? CategoryDb().expenseCategoryNotifier.value
        : CategoryDb().incomeCategoryNotifier.value;

    dropDownListNotifier.value.clear();
    dropDownListNotifier.value.addAll(newDropValue);

    dropDownListNotifier.notifyListeners();
    print('new Category added');
  }
  /*
  Future<void> changeTypeNameOnSelect(CategoryType value) async {
    _typeNamelistNotifier.value.clear();
    final _TransactionDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    final _TransactionList = _TransactionDB.values.toList();
    for (var i = 0; i < _TransactionList.length; i++) {
      if (_TransactionList[i].type == value) {
        _typeNamelistNotifier.value.add(_TransactionList[i].name);
      }
    }
    _typeNamelistNotifier.notifyListeners();
  }
  */
/*
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2100)) as DateTime;
    if (picked != null || picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date =
            '${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}';
        _dateController.text = date;
      });
    }
  }
  */

}
