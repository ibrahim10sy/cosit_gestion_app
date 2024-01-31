import 'dart:convert';

import 'package:cosit_gestion/model/SendNotification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendNotifService extends ChangeNotifier {
  final String baseUrl = "https://depenses-cosit.com/send";
  late List<SendNotification> notifications = [];

  Future<List<SendNotification>> getNotification() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list'));
      print("Fetching notif");
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        notifications = body.map((e) => SendNotification.fromMap(e)).toList();
        print('Résultat attendu : ${response.statusCode}');
        debugPrint('notif service ${response.body}');
        return notifications;
      } else {
        notifications = [];
        print(
            'Échec de la requête du notif avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (error) {
      print('Erreur lors de la récupération des notifications: $error');
      rethrow;
    }
  }

  Future<void> deleteNotif(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/delete/$id"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body.toString());
    } else {
      throw Exception(
          "Erreur lors de la suppression avec le code: ${response.statusCode}");
    }
  }

Future<List<SendNotification>> fetchData(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read/$id'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetching data: $id");
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
         notifications = body.map((e) => SendNotification.fromMap(e)).toList();
        debugPrint(notifications.toString());
        return notifications;
      } else {
        notifications = [];
        print(
            'Échec de la requête avec le code d\'état: ${response.statusCode}');
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void applyChange() {
    notifyListeners();
  }
}
