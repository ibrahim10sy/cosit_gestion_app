import 'dart:convert';
import 'dart:io';

import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UtilisateurService extends ChangeNotifier {
  static const String baseUrl = 'https://depenses-cosit.com/utilisateur';
  List<Utilisateur> utilisateurs = [];

  static Future<void> creerCompteUtilisateur({
    required String nom,
    required String prenom,
    required String email,
    File? image,
    required String role,
    required String phone,
    required String passWord,
  }) async {
    try {
      var requete = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      if (image != null) {
        requete.files.add(http.MultipartFile(
            'images', image.readAsBytes().asStream(), image.lengthSync(),
            filename: basename(image.path)));
      }

      requete.fields['utilisateur'] = jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'image': "",
        // 'image': image != null ? basename(image.path) : "",

        'role': role,
        'phone': phone,
        'passWord': passWord,
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint('user service ${donneesResponse.toString()}');
        // return Utilisateur.fromJson(donneesResponse);
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de l\'ajout de l\'utilisateur : $e');
    }
  }

  Future<Utilisateur> updateUtilisateur({
    required int idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
    File? image,
    required String role,
    required String phone,
    required String passWord,
  }) async {
    try {
      var requete = http.MultipartRequest(
          'PUT', Uri.parse('$baseUrl/update/$idUtilisateur'));

      if (image != null) {
        requete.files.add(http.MultipartFile(
          'images',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: basename(image.path),
        ));
      }

      requete.fields['utilisateur'] = jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'image': "",
        'role': role,
        'phone': phone,
        'passWord': passWord,
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint(donneesResponse.toString());
        return Utilisateur.fromMap(donneesResponse);
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de la modification de l\'utilisateur : $e');
    }
  }

  Future<List<Utilisateur>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://depenses-cosit.com/utilisateur/liste'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        utilisateurs = body.map((e) => Utilisateur.fromMap(e)).toList();
        debugPrint(utilisateurs.toString());
        return utilisateurs;
      } else {
        utilisateurs = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
// Future<List<Utilisateur>> fetchData() async {
//     final response = await http.get(Uri.parse('$baseUrl/list'));

//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
//       utilisateurs = body.map((item) => Utilisateur.fromMap(item)).toList();
//       debugPrint(response.body);
//       return utilisateurs;
//     } else {
//       utilisateurs = [];
//       print('Échec de la requête avec le code d\'état: ${response.statusCode}');
//       throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
//     }
//   }
  Future deleteUser(int idUtilisateur) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/delete/$idUtilisateur'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      applyChange();
    } else {
      print('Échec de la requête avec le code d\'état: ${response.statusCode}');
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
