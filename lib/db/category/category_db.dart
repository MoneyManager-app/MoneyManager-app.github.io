import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/Transaction/transaction_add.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';

const CATEGORY_DB_NAME = 'category_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> editCategory(CategoryModel value);
  Future<void> deleteCategory(CategoryModel value);
  Future<void> deleteAllCategories(CategoryType value);
}

class CategoryDb implements CategoryDbFunctions {
  // for refreshing all categories by asuming all objects are same
  // from _internal to factory return
  CategoryDb._internal();

  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }
  ValueNotifier<List<CategoryModel>> incomeCategoryNotifier = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDb.add(value);
    await refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    final _categoryList = await _categoryDb.values.toList();
    // final List<CategoryModel> _newCategoryList = [];
    // Future.forEach(_categoryList, (val) {
    //   if (val.isDeleted == false) _newCategoryList.add(val);
    // });
    return _categoryList;
  }

  @override
  Future<void> editCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    int i = 0;
    Future.forEach(_categoryDB.values, (val) {
      if (val.id == value.id) {
        _categoryDB.putAt(i, value);
      }
      i++;
    });
    await refreshUI();
  }

  @override
  Future<void> deleteCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    //await _categoryDB.delete(value.id);
    int i = 0;
    Future.forEach(_categoryDB.values, (val) {
      if (value.type == CategoryType.income) {
        if (val.name == value.name) {
          //val.isDeleted = true;
          _categoryDB.deleteAt(i);
          print('deleted $i th');
        }
      } else {
        if (val.name == value.name) {
          //val.isDeleted = true;
          _categoryDB.deleteAt(i);
          print('deleted $i th');
        }
      }
      i++;
    });
    await refreshUI();
  }

  @override
  Future<void> deleteAllCategories(CategoryType value) async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    final Map<dynamic, CategoryModel> _newList = _CategoryDB.toMap();
    dynamic desiredKey;
    _newList.forEach((key, val) {
      if (val.type == value) {
        desiredKey = key;
        print('key is $key');
        _CategoryDB.delete(desiredKey);
      }
    });

    /*
    //int i = 0;
    //Future.forEach(_CategoryDB.values, (val) async {
    for (var i = 0; i < _newList.length; i++) {
      print('${_newList[i].name} check for delete i value: $i');
      if (value.name == CategoryType.income) {
        if (_newList[i].type == value.name) {
          //val.isDeleted = true;
          //await _CategoryDB.delete(val.id);
          print('${value.name}');
          print('${_newList[i].name} deleted i value: $i');
          await _CategoryDB.deleteAt(i);
        }
      } else {
        if (_newList[i].type == value.name) {
          //val.isDeleted = true;
          //await _CategoryDB.delete(val.id);
          print('${value.name}');
          print('${_newList[i].name} deleted i value: $i');
          await _CategoryDB.deleteAt(i);
        }
      }
      //i++;

      
      print(i);
    }
    ;
    */

    await refreshUI();
  }

  Future<void> refreshUI() async {
    final _allCategory = await getCategories();

    incomeCategoryNotifier.value.clear();
    expenseCategoryNotifier.value.clear();
    Future.forEach(_allCategory, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryNotifier.value.add(category);
      } else {
        expenseCategoryNotifier.value.add(category);
      }
    });
    print(_allCategory.length);
    incomeCategoryNotifier.notifyListeners();
    expenseCategoryNotifier.notifyListeners();
    await transactionAddSupportWithCategory();
  }

  Future<void> transactionAddSupportWithCategory() async {
    if (dropDownValue != null) {
      dropDownListNotifier.value.clear();
      dropDownListNotifier.value.addAll((dropDownValue == CategoryType.income)
          ? CategoryDb().incomeCategoryNotifier.value
          : CategoryDb().expenseCategoryNotifier.value);

      dropDownListNotifier.notifyListeners();
    }
  }
}
