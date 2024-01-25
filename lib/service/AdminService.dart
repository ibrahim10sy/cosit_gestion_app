import 'dart:convert';
import 'dart:io';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class AdminServcie extends ChangeNotifier {
  static const String baseUrl = "http://10.0.2.2:5100/Admin";

  Future<Admin> updateAdmin({
    required int idAdmin,
    required String nom,
    required String prenom,
    required String email,
    File? image,
    required String phone,
    required String passWord,
  }) async {
    try {
      var requete =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$idAdmin'));

      if (image != null) {
        requete.files.add(http.MultipartFile(
          'images',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: basename(image.path),
        ));
      }

      requete.fields['admin'] = jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'image': "",
        'phone': phone,
        'passWord': passWord,
      });

      var response = await requete.send();
      var responsed = await http.Response.fromStream(response);

      if (response.statusCode == 200 || responsed.statusCode == 201) {
        final donneesResponse = json.decode(responsed.body);
        debugPrint(donneesResponse.toString());
        return Admin.fromMap(donneesResponse);
      } else {
        throw Exception(
            'Échec de la requête avec le code d\'état : ${responsed.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Une erreur s\'est produite lors de la modification admin  : $e');
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
