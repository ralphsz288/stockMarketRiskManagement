import 'package:flutter/material.dart';

class ChangeUsername extends ChangeNotifier{

  String username = 'Username';

  void changeUsername(String newUsername){
    username = newUsername;
    notifyListeners();
  }
}