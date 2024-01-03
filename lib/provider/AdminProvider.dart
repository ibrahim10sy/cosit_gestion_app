import 'package:cosit_gestion/model/Admin.dart';
import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {
  Admin? _admin;
  Admin? get admin => _admin;

  void setAdmin(Admin newAdmin) {
    _admin = newAdmin;
    debugPrint("setAdmin : $newAdmin");
    notifyListeners();
  }
}
