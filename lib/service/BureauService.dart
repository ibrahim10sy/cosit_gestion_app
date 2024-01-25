import 'dart:convert';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BureauService extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:5100/Bureau";

  List<Bureau> bureau = [];

  Future<void> addBureau({
    required String nom,
    required String adresse,
  }) async {
    var addBureau =
        jsonEncode({'idBureau': null, 'nom': nom, 'adresse': adresse});

    final response = await http.post(Uri.parse("$baseUrl/create"),
        headers: {'Content-Type': 'application/json'}, body: addBureau);
    debugPrint(addBureau.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

   Future<void> updateBureau({
    required int idBureau,
    required String nom,
    required String adresse,
  }) async {
    var bureau =
        jsonEncode({'idBureau': idBureau, 'nom': nom, 'adresse': adresse});

    final response = await http.put(Uri.parse("$baseUrl/update/$idBureau"),
        headers: {'Content-Type': 'application/json'}, body: bureau);
    debugPrint(bureau.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception(
          "Une erreur s'est produite lors de la modification : ${response.statusCode}");
    }
  }

  Future<List<Bureau>> fetchBureau() async {
    final response = await http.get(Uri.parse('$baseUrl/read'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      bureau = body.map((item) => Bureau.fromMap(item)).toList();
      debugPrint(response.body);
      return bureau;
    } else {
      bureau = [];
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<void> deleteBureau(int idBureau) async {
    final response = await http.delete(Uri.parse("$baseUrl/Delete/$idBureau"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
