import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/services/todo_service.dart';

class CategoryListProvider with ChangeNotifier {
  CategoryListProvider() {
    getCategoryList();
  }

  //Instance of TodoService class
  final _todoService = TodoService();

  List<Category> _categoryList = [];
  List<Category> get categoryList => _categoryList;

  Future<List<Category>> getCategoryList() async {
    print("getCategory Ran");
    _categoryList = [];
    _categoryList = await _todoService.readTodosCategory();
    print(_categoryList.toString());
    notifyListeners();
    return _categoryList;
  }

  //Add new category
  void addCategory(String categoryId) async {
    Category category = await _todoService.addNewCategory(categoryId);
    await getCategoryList();
    //_categoryList.add(category);
    notifyListeners();
  }

  //Delete Category
  Future<void> deleteCategory(String category, int index) async {
    try {
      await _todoService.deleteCategory(category);

      notifyListeners();
    } catch (e) {}

    //_categoryList.removeAt(index);
    //print(_categoryList.toString());
    await getCategoryList();

    print(_categoryList.toString());
    notifyListeners();
  }
}
