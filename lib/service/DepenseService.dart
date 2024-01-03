import 'dart:convert';
import 'dart:io';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/CategorieDepense.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DepenseService extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:8080/Depenses";

  List<Depense> depensesListe = [];
  String action = "all";
  String lastAction = "";
  String desc = "";
  String sortValue = "";

  Future<void> addDepenseByUser(
      {required String description,
      File? image,
      required String montantDepense,
      required String dateDepense,
      required Utilisateur utilisateur,
       Demande? demande,
      required CategorieDepense categorieDepense,
      required Bureau bureau,
      required Budget budget}) async {
    try {
      var requete =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/createByUser'));

      if (image != null) {
        requete.files.add(http.MultipartFile(
          'images',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: basename(image.path),
        ));
      }

      requete.fields['depense'] = jsonEncode({
        'description': description,
        'image': "",
        'montantDepense': montantDepense,
        'dateDepense': dateDepense,
        'utilisateur': utilisateur.toMap(),
        if(demande != null) 'demande' : demande.toMap(),
        'categorieDepense': categorieDepense.toMap(),
        'bureau': bureau.toMap(),
        'budget': budget.toMap(),
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint(donneesResponse.toString());
       
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout du depense : $e');
    }
  }

  Future<void> addDepenseByAdmin(
      {required String description,
      File? image,
      required String montantDepense,
      required String dateDepense,
      required Admin admin,
      required CategorieDepense categorieDepense,
      required Bureau bureau,
      required Budget budget}) async {
    try {
      var requete =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/createByAdmin'));

      if (image != null) {
        requete.files.add(http.MultipartFile(
          'images',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: basename(image.path),
        ));
      }

      requete.fields['depense'] = jsonEncode({
        'description': description,
        'image': "",
        'montantDepense': montantDepense,
        'dateDepense': dateDepense,
        'admin': admin.toMap(),
        'categorieDepense': categorieDepense.toMap(),
        'bureau': bureau.toMap(),
        'budget': budget.toMap(),
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);
      // responsed.printInfo();
      print("Date depense $dateDepense");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint(donneesResponse.toString());
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de depense : $e');
    }
  }

  Future<Depense> updateDepenseByAdmin(
      {required int idDepense,
      required String description,
      File? image,
      required String montantDepense,
      required String dateDepense,
      required Admin admin,
      required CategorieDepense categorieDepense,
      required Bureau bureau,
      required Budget budget}) async {
    try {
      var requete =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idDepense'));

      if (image != null) {
        requete.files.add(http.MultipartFile(
          'images',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: basename(image.path),
        ));
      }

      requete.fields['depense'] = jsonEncode({
        'description': description,
        'image': "",
        'montantDepense': montantDepense,
        'dateDepense': dateDepense,
        'categorieDepense': categorieDepense.toMap(),
        'bureau': bureau.toMap(),
        'budget': budget.toMap(),
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint(donneesResponse.toString());
        return Depense.fromMap(donneesResponse);
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout du depense : $e');
    }
  }

  Future<Map<String, dynamic>> getSommeDepenseTotalByBudget(
      int idBudget) async {
    print("Fetching data: $idBudget");
    final response = await http.get(Uri.parse('$baseUrl/sommeTotal/$idBudget'));
    try {
      print("Fetching depense total by budget");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Erreur lors de la recuperation ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la recuperation ${response.statusCode}");
    }
  }

  Future<void> deleteDepense(int idDepense) async {
    final response = await http.delete(Uri.parse("$baseUrl/delete/$idDepense"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  // Future<List<Depense>> fetchDepenseByBudget(int id) async {
  //   final response = await http
  //       .get(Uri.parse('http://10.0.2.2:8080/Depenses/listeByBudget/$id'));
  //   print("Fetching data : $id");
  //   if (response.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
  //     depensesListe = body.map((item) => Depense.fromMap(item)).toList();
  //     debugPrint(response.body);
  //     return depensesListe;
  //   } else {
  //     depensesListe = [];
  //     print('Échec de la requête avec le code d\'état: ${response.statusCode}');
  //     throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
  //   }
  // }
  Future<List<Depense>> fetchDepensesByBudget(int id) async {
    print("Fetching data: $id");
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/Depenses/listeByBudget/$id'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data: $id");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        depensesListe = body.map((e) => Depense.fromMap(e)).toList();
        // depensesListe.printInfo();
        return depensesListe;
      } else {
        depensesListe = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 Future<List<Depense>> fetchDepensesByUser(int id) async {
    print("Fetching data: $id");
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/listByUser/$id'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching depense user: $id");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        depensesListe = body.map((e) => Depense.fromMap(e)).toList();
        // depensesListe.printInfo();
        return depensesListe;
      } else {
        depensesListe = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<List<Depense>> fetchDepense() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      depensesListe = body.map((item) => Depense.fromMap(item)).toList();
      debugPrint("Depense recuperer ${depensesListe.toString()}");
      // depensesListe.printInfo();
      return depensesListe;
    } else {
      depensesListe = [];
      print(
          'Échec de la recupereration de depense avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Depense>> searchDepenseByDesc() async {
    final response = await http.get(Uri.parse("$baseUrl/search?desc=$desc"));
    debugPrint(response.body);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      depensesListe =
          body.map((dynamic item) => Depense.fromJson(item)).toList();
      return depensesListe;
    } else {
      depensesListe = [];
      throw Exception(
          "Erreur lors de la recupération avec le code: ${response.statusCode}");
    }
  }

  Future<List<Depense>> sortByMonthAndYear() async {
    final response = await http.get(Uri.parse("$baseUrl/trie?date=$sortValue"));
    debugPrint("$baseUrl/trie?date=$sortValue");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      depensesListe =
          body.map((dynamic item) => Depense.fromJson(item)).toList();
      debugPrint("Depenses trie");
      // printInfo();
      return depensesListe;
    } else {
      depensesListe = [];
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
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
