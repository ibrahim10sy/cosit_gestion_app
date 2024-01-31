import 'dart:convert';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DemandeService extends ChangeNotifier {
  static const String baseUrl = 'https://depenses-cosit.com/Demande';

  List<Demande> demandes = [];

  Future<void> addDemande(
      {
      required String motif,
      required String montantDemande,
      required Utilisateur utilisateur, 
      required Admin admin}) async {
    var addDemande = {
      'idDemande': null,
      'motif' : motif,
      'moontDemande': int.tryParse(montantDemande),
      'utilisateur': utilisateur.toMap(),
      'admin': admin.toMap()
    };

    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(addDemande),
    );
   debugPrint(addDemande.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite lors de l'ajout de la demande' : ${response.statusCode}");
    }
  }

  Future<void> updateDemande({
    required int idDemande,
    required String motif,
    required String montantDemande,
  }) async {
    var addDemande = jsonEncode({
      'idDemande': idDemande,
      'moontDemande': montantDemande,
    });

    final response = await http.put(
      Uri.parse("$baseUrl/update/$idDemande"),
      headers: {'Content-Type': 'application/json'},
      body: addDemande,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> approuveDirecteur({
    required int idDemande,
    required Utilisateur utilisateur,
  }) async {
    var addDemande = jsonEncode(
        {'idDemande': idDemande, 'utilisateur': utilisateur.toMap()});

    final response = await http.put(
      Uri.parse("$baseUrl/approuveDemandeByDirecteur/$idDemande"),
      headers: {'Content-Type': 'application'},
      body: addDemande,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> approuveAdmin({
      required int idDemande,
      required Admin admin,
      required Utilisateur utilisateur}) async {
    var addDemande = {
      'idDemande': idDemande,
      'admin': admin.toMap(),
      'utilisateur': utilisateur.toMap(),
    };

    final response = await http.put(
      Uri.parse("$baseUrl/approuveDemandeByAdmin/$idDemande"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(addDemande),
    );
     debugPrint(response.toString());
    print("iD de la demande $idDemande");
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
    } else {
      throw Exception("Une erreur s'est produite' : ${response.statusCode}");
    }
  }

  Future<void> deleteDemande(int idDemande) async {
    final response = await http.delete(Uri.parse("$baseUrl/delete/$idDemande"));
    print("Demande à supprimer $idDemande");
    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

  Future<List<Demande>> getDemande() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list'));
      print("Fetching demande...");
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        demandes = body.map((e) => Demande.fromMap(e)).toList();
        print('Résultat attendu : ${response.statusCode}');
        return demandes;
      } else {
        print(
            'Échec de la requête du demande avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Demande>> fetchDemande(int idUtilisateur) async {
    final response = await http.get(Uri.parse('$baseUrl/read/$idUtilisateur'));
    print('Demande $idUtilisateur ');
    if (response.statusCode == 200) {
      print('condition if 200 ');
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      demandes = body.map((item) => Demande.fromMap(item)).toList();
      print('condition if 200 encore ');
      debugPrint(response.body);
      // demandes.printInfo();
      return demandes;
    } else {
      demandes = [];
      print(
          'Échec de la requête av ec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    } 
  }


  void applyChange() {
    notifyListeners();
  }
}
