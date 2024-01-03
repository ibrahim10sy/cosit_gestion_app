import 'dart:convert';
import 'package:cosit_gestion/model/Salaire.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalaireService extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:8080/Salaire";

  List<Salaire> salaires = [];

  Future<void> addSalaire({
    required String description,
    required String montant,
    required String date,
    required Utilisateur utilisateur,
  }) async {
    var salaire = jsonEncode({
      'idSalaire': null,
      'description': description,
      'montant': int.tryParse(montant),
      'date': date,
      'utilisateur': utilisateur.toMap(),
    });

    final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/Salaire/create"),
        headers: {'Content-Type': 'application/json'},
        body: salaire);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Response Body: ${response.body}");
      debugPrint(salaire.toString());
    } else {
      throw Exception(
          "Une erreur s'est produite lors de l'ajout' : ${response.statusCode}");
    }
  }

  Future<void> updateSalaire({
    required int idSalaire,
    required String description,
    required String montant,
    required String date,
    required Utilisateur utilisateur,
  }) async {
    var salaire = jsonEncode({
      'idSalaire': null,
      'description': description,
      'montant': int.tryParse(montant),
      'date': date,
      'utilisateur': utilisateur.toMap(),
    });

    final response = await http.put(Uri.parse("$baseUrl/update/$idSalaire"),
        headers: {'Content-Type': 'application/json'}, body: salaire);
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<List<Salaire>> fetchSalaire() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      salaires = body.map((item) => Salaire.fromMap(item)).toList();
      debugPrint(response.body);
      return salaires;
    } else {
      salaires = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Salaire>> fetchSalaireByIdUser(int idUtilisateur) async {
    final response = await http.get(Uri.parse('$baseUrl/liste/$idUtilisateur'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      salaires = body.map((item) => Salaire.fromMap(item)).toList();
      debugPrint(response.body);
      return salaires;
    } else {
      salaires = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteSalaire(int idSalaire) async {
    final response = await http.delete(Uri.parse("$baseUrl/delete/$idSalaire"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getSalireTotal() async {
    final response = await http.get(Uri.parse('$baseUrl/somme'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la recuperation ${response.statusCode}");
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
