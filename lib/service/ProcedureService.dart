import 'dart:convert';

import 'package:cosit_gestion/model/Procedure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProcedureService extends ChangeNotifier {
  final String baseUrl = "http://10.0.2.2:8080/procedure";

  Future<List<Procedure>> getDepenseByCategory(int adminId) async {
    try { 
      final response =
          await http.get(Uri.parse('$baseUrl/expensesByAdmin/$adminId'));
      print("Fetching data $adminId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body);
        debugPrint(data.toString());
        return data.map((item) => Procedure.fromMap(item)).toList();
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(
            'Réponse inattendue avec le code d\'état: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données dans le service: $e');
      throw Exception('Une erreur s\'est produite lors de la recuperation: $e');
    }
  }

  Future<List<Procedure>> getDepenseByUser(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/expensesByUser/$userId'));
      print("Fetching data $userId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body);
        debugPrint(data.toString());
        return data.map((item) => Procedure.fromMap(item)).toList();
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(
            'Réponse inattendue avec le code d\'état: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données dans le service: $e');
      throw Exception('Une erreur s\'est produite lors de la recuperation: $e');
    }
  }

  Future<List<Procedure>> getDepenseTotal() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/expensesByTotal'));
      print("Fetching data ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body);
        debugPrint(data.toString());
        return data.map((item) => Procedure.fromMap(item)).toList();
      } else {
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(
            'Réponse inattendue avec le code d\'état: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données dans le service: $e');
      throw Exception('Une erreur s\'est produite lors de la recuperation: $e');
    }
  }
}
