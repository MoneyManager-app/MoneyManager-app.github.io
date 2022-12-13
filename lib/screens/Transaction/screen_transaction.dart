import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/db/Balance/balance_db.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

bool StatusOfDelete = false;

class ScreenTransaction extends StatefulWidget {
  const ScreenTransaction({super.key});

  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  @override
  void initState() {
    TransactionDB().TransactionRefreshUI();
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: transactionListNotifier,
        builder: (BuildContext context, transValue, Widget? child) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Card(
                                    margin: EdgeInsets.all(0.5),
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: ValueListenableBuilder(
                                        valueListenable:
                                            Balance.instance.totalIncome,
                                        builder: (BuildContext context,
                                            newValue, child) {
                                          return Text(
                                            'Income:\n ${newValue}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                height: 1.5,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    margin: EdgeInsets.all(0.5),
                                    color: Colors.red,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                          Balance.instance.totalExpense,
                                      builder: (BuildContext context, newValue,
                                          child) {
                                        return Text(
                                          'Expense:\n ${newValue}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1.5,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Card(
                              color: Colors.green,
                              elevation: 0,
                              margin: EdgeInsets.all(0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable:
                                        Balance.instance.totalBalance,
                                    builder: (BuildContext context, newValue,
                                        child) {
                                      return (newValue > 0)
                                          ? Text(
                                              'Balance:  ${newValue}',
                                              textHeightBehavior:
                                                  TextHeightBehavior(
                                                      applyHeightToFirstAscent:
                                                          true),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  height: 3,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              'Balance:  ${newValue}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  height: 3,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.rightSlide,
                              title: 'Confirm Delete All',
                              desc:
                                  'Do you want delete all transactions permanently...',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                TransactionDB.instance.deleteAllTrans();
                              },
                            )..show();
                            /*
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        iconPadding: EdgeInsets.only(top: 0),
                                        icon: SizedBox(
                                          child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ));
                                      */
                            //
                          },
                          child: Text('Delete All'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.all(15),
                          itemBuilder: (ctx, index) {
                            String trsValue = transValue[index].date.toString();
                            return
                                /*
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    StatusOfDelete = true;
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text('Delete')),
                            ),
                    
                        */
                                /*
                              Dismissible(
                              key: Key(transValue[index].id),
                              confirmDismiss: (direction) async =>
                                  (StatusOfDelete == true) ? true : false,
                              movementDuration: Duration(milliseconds: 10),
                              )
                            */

                                Slidable(
                              key: Key(transValue[index].id),
                              startActionPane:
                                  ActionPane(motion: ScrollMotion(), children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 70),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      color: Colors.white,
                                      onPressed: () async {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.rightSlide,
                                          title: 'Confirm Delete',
                                          desc:
                                              'Do you want delete ${transValue[index].name} permanently...',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () async {
                                            await TransactionDB.instance
                                                .deleteTrans(transValue[index]);
                                          },
                                        )..show();
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ),
                                )
                              ]),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    radius: 50,
                                    child: Text(
                                      //'${transValue}',
                                      '${trsValue.split('-')[0]}\n${trsValue.split('-')[1]} ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  title: (transValue[index].type ==
                                          CategoryType.income)
                                      ? Text(
                                          'Rs ${transValue[index].amount}',
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      : Text(
                                          'Rs ${transValue[index].amount}',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  subtitle: Text('${transValue[index].name}'),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: transValue.length),
                    ),
                  ],
                ),
              ),
            ));
  }
}
