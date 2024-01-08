import 'package:flutter/material.dart';
import '../db_helper.dart';

class MyAppState extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _todoList = [];
  String userName = '';
  bool logged = false;

  List<Map<String, dynamic>> get todoList => _todoList;

  void addToList(String task) async {
    await _dbHelper.saveTask(userName, task);
    await loadTasks();
  }

  void removeFromList(int id) async {
    await _dbHelper.deleteTask(id);
    await loadTasks();
  }

  void logIn(String login) async {
    if(login.isNotEmpty) {
      logged = true;
      userName = login;
      await loadTasks();
      notifyListeners();
    }
  }

  void logOut() {
    logged = false;
    userName = '';
    _todoList.clear();
    notifyListeners();
  }

  Future<void> loadTasks() async {
    if (logged) {
      _todoList = await _dbHelper.getAllTasks(userName);
      notifyListeners();
    }
  }
}