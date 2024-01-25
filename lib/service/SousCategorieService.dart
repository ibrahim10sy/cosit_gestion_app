import 'dart:convert';

import 'package:cosit_gestion/model/CategorieDepense.dart';
import 'package:cosit_gestion/model/SousCategorie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SousCategorieService extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:5100/SousCategorie";

  List<SousCategorie> sousCategorieListe = [];

  Future<void> addCategorie({
    required String libelle,
    required CategorieDepense categorieDepense,
  }) async {
    var addCategorie = jsonEncode({
      'idCategoriedepense': null,
      'libelle': libelle,
      'categorieDepense': categorieDepense.toMap(),
    });

    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: {'Content-Type': 'application/json'},
      body: addCategorie,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> updateCategorie({
    required int idSousCategorie,
    required String libelle,
    required CategorieDepense categorieDepense,
  }) async {
    var addCategorie = jsonEncode({
      'idCategoriedepense': idSousCategorie,
      'libelle': libelle,
      'categorieDepense': categorieDepense.toMap(),
    });

    final response = await http.put(
      Uri.parse("$baseUrl/update/$idSousCategorie"),
      headers: {'Content-Type': 'application/json'},
      body: addCategorie,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> deleteSousCategorie(int idSousCategorie) async {
    final response = await http
        .delete(Uri.parse("$baseUrl/SupprimerSousCategorie/$idSousCategorie"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<List<SousCategorie>> fetchData(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list/$id'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data: $id");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        sousCategorieListe = body.map((e) => SousCategorie.fromMap(e)).toList();
        debugPrint(sousCategorieListe.toString());
        return sousCategorieListe;
      } else {
        sousCategorieListe = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<List<SousCategorie>> fetchAllSousCategorie() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/liste'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" Fetching data ");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        sousCategorieListe = body.map((e) => SousCategorie.fromMap(e)).toList();
        debugPrint(sousCategorieListe.toString());
        return sousCategorieListe;
      } else {
        sousCategorieListe = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<List<SousCategorie >> fetchCategorie(int idCategoriedepense) async {
  //   final response =
  //       await http.get(Uri.parse('$baseUrl/list/$idCategoriedepense'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
  //     categories = body.map((item) => SousCategorie.fromMap(item)).toList();
  //     debugPrint(response.body);
  //     return categories;
  //   } else {
  //     categories = [];
  //     print('Échec de la requête avec le code d\'état: ${response.statusCode}');
  //     throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
  //   }
  // }

  void applyChange() {
    notifyListeners();
  }
}

