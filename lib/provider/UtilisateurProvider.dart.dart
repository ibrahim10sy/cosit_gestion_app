import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';

class UtilisateurProvider with ChangeNotifier {
  Utilisateur? _utilisateur;
  Utilisateur? get utilisateur => _utilisateur;

  void setUtilisateur(Utilisateur newUtilisateur) {
    _utilisateur = newUtilisateur;
    debugPrint("setUtilisateur : $newUtilisateur");
    notifyListeners();
  }
}
