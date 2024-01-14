import 'dart:convert'; 

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BudgetService extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:8080/Budget";

  List<Budget> budget = [];
  String action = "all";
  String lastAction = "";
  String desc = "";
  String sortValue = "";

  Future<Map<String, dynamic>> getBudgetTotalByAdmin(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/sommeByAdmin/$id'));
    print("Fetching budget total");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la recuperation ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getBudgetTotalByUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/sommeByUser/$id'));
    print("Fetching budget total");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur lors de la recuperation ${response.statusCode}");
    }
  }

  Future<List<Budget>> fetchBudgets() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      budget = body.map((item) => Budget.fromMap(item)).toList();
      debugPrint("Budget recuperer ${budget.toString()}");

      return budget;
    } else {
      budget = [];
      print(
          'Échec de la recupereration du budget avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }
  Future<List<Budget>> fetchBudgetByUser(int idUtilisateur) async {
    final response =
        await http.get(Uri.parse('$baseUrl/listeByUser/$idUtilisateur'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      budget = body.map((item) => Budget.fromMap(item)).toList();
      debugPrint(response.body);
      return budget;
    } else {
      budget = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }
  Future<List<Budget>> searchBudgetByDesc() async {
    final response = await http.get(Uri.parse("$baseUrl/search?desc=$desc"));
    debugPrint(response.body);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      budget = body.map((dynamic item) => Budget.fromJson(item)).toList();
      return budget;
    } else {
      budget = [];
      throw Exception(
          "Erreur lors de la recupération avec le code: ${response.statusCode}");
    }
  }

  Future<List<Budget>> sortByMonthAndYear() async {
    final response = await http.get(Uri.parse("$baseUrl/trie?date=$sortValue"));
    debugPrint("$baseUrl/trie?date=$sortValue");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      budget = body.map((dynamic item) => Budget.fromJson(item)).toList();
      debugPrint("Budgets trie ${budget.toString()}");
     
      return budget;
    } else {
      budget = [];
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteBudget(int idBudget) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/supprimer/$idBudget"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<void> addBudgets({
    required String description,
    required String montant,
    required String dateDebut,
    Utilisateur? utilisateur, 
    required Admin admin,
  }) async {
    var addBudget = {
      'idBudget': null,
      'description': description,
      'montant': int.tryParse(montant),
      'dateDebut': dateDebut,
      // Ajouter la vérification pour inclure 'utilisateur' uniquement s'il est non nul
      if (utilisateur != null) 'utilisateur': utilisateur.toMap(),
      'admin': admin.toMap(),
    };

    final response = await http.post(
      Uri.parse("$baseUrl/ajouter"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(addBudget),
    );

    debugPrint(addBudget.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite : ${response.statusCode}");
    }
  }

  Future<void> updateBudgets({
    required int idBudget,
    required String description,
    required String montant,
    required String dateDebut,
    Utilisateur? utilisateur,
    required Admin admin,
  }) async {
    var addBudget = {
      'idBudget': idBudget,
      'description': description,
      'montant': int.tryParse(montant),
      'dateDebut': dateDebut,
      // Ajouter la vérification pour inclure 'utilisateur' uniquement s'il est non nul
      if (utilisateur != null) 'utilisateur': utilisateur.toMap(),
      'admin': admin.toMap(),
    };

    final response = await http.put(
      Uri.parse("$baseUrl/modifier/$idBudget"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(addBudget),
    );

    debugPrint(addBudget.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite : ${response.statusCode}");
    }
  }

  getBudgetById(int id) {
    late Budget bud;
    for (var element in budget) {
      if (element.idBudget == id) {
        bud = element;
      }
    }
    return bud;
  }

  void applyChange() {
    notifyListeners();
  }

  void applySearch(String value) {
    action = "search";
    desc = value;
    applyChange();
  }

  void applyTrie(String value) {
    action = "trie";
    sortValue = value;
    applyChange();
  }
}
