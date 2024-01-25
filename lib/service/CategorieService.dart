import 'dart:convert';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/CategorieDepense.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategorieService extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:5100/Categorie";

  List<CategorieDepense> categories = [];

  Future<void> addCategorieByUser({
    required String libelle,
    required Utilisateur utilisateur,
  }) async { 
    var addCategorie = jsonEncode({
      'idCategoriedepense': null,
      'libelle': libelle,
      'utilisateur': utilisateur.toMap()
    });

    final response = await http.post(
      Uri.parse("$baseUrl/createByUser"),
      headers: {'Content-Type': 'application/json'},
      body: addCategorie,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> addCategorieByAdmin({
    required String libelle,
    required Admin admin,
  }) async {
    var addCategorie = jsonEncode({
      'idCategoriedepense': null,
      'libelle': libelle,
      'admin': admin.toMap()
    });

    final response = await http.post(
      Uri.parse("$baseUrl/createByAdmin"),
      headers: {'Content-Type': 'application/json'},
      body: addCategorie,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(addCategorie.toString());
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> updateCategorie({
    required idCategoriedepense,
    required String libelle,
  }) async {
    var addCategorie = jsonEncode({
      'idCategoriedepense': idCategoriedepense,
      'libelle': libelle,
    });

    final response = await http.put(
      Uri.parse("$baseUrl/update/$idCategoriedepense"),
      headers: {'Content-Type': 'application/json'},
      body: addCategorie,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> deleteCategorie(int idCategoriedepense) async {
    final response = await http
        .delete(Uri.parse("$baseUrl/SupprimerCategorie/$idCategoriedepense"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<List<CategorieDepense>> fetchCategorieByUser(int idUtilisateur) async {
    final response =
        await http.get(Uri.parse('$baseUrl/listeByUser/$idUtilisateur'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      categories = body.map((item) => CategorieDepense.fromMap(item)).toList();
      debugPrint(response.body);
      return categories;
    } else {
      categories = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }
  Future<List<CategorieDepense>> fetchAllCategorie() async {
    final response =
        await http.get(Uri.parse('$baseUrl/lire'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      categories = body.map((item) => CategorieDepense.fromMap(item)).toList();
      debugPrint(response.body);
      return categories;
    } else {
      categories = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<CategorieDepense>> fetchCategorieByAdmin(int idAdmin) async {
    final response =
        await http.get(Uri.parse('$baseUrl/listeByAdmin/$idAdmin'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      categories = body.map((item) => CategorieDepense.fromMap(item)).toList();
      debugPrint(response.body);
      return categories;
    } else {
      categories = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
