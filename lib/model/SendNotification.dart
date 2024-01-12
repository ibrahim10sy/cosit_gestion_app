import 'dart:convert';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';

class SendNotification {
  final int? idNotification;
  final String message;
  final String date;
  final Utilisateur utilisateur;
  final Admin admin;
  final Depense depense;
  
  SendNotification({
    this.idNotification,
    required this.message,
    required this.date,
    required this.utilisateur,
    required this.admin,
    required this.depense,
  });
 

  SendNotification copyWith({
    int? idNotification,
    String? message,
    String? date,
    Utilisateur? utilisateur,
    Admin? admin,
    Depense? depense,
  }) {
    return SendNotification(
      idNotification: idNotification ?? this.idNotification,
      message: message ?? this.message,
      date: date ?? this.date,
      utilisateur: utilisateur ?? this.utilisateur,
      admin: admin ?? this.admin,
      depense: depense ?? this.depense,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idNotification': idNotification,
      'message': message,
      'date': date,
      'utilisateur': utilisateur.toMap(),
      'admin': admin.toMap(),
      'depense': depense.toMap(),
    };
  }

  factory SendNotification.fromMap(Map<String, dynamic> map) {
    return SendNotification(
      idNotification: map['idNotification'] != null ? map['idNotification'] as int : null,
      message: map['message'] as String,
      date: map['date'] as String,
      utilisateur: Utilisateur.fromMap(map['utilisateur'] as Map<String,dynamic>),
      admin: Admin.fromMap(map['admin'] as Map<String,dynamic>),
      depense: Depense.fromMap(map['depense'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SendNotification.fromJson(String source) => SendNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendNotification(idNotification: $idNotification, message: $message, date: $date, utilisateur: $utilisateur, admin: $admin, depense: $depense)';
  }

  @override
  bool operator ==(covariant SendNotification other) {
    if (identical(this, other)) return true;
  
    return 
      other.idNotification == idNotification &&
      other.message == message &&
      other.date == date &&
      other.utilisateur == utilisateur &&
      other.admin == admin &&
      other.depense == depense;
  }

  @override
  int get hashCode {
    return idNotification.hashCode ^
      message.hashCode ^
      date.hashCode ^
      utilisateur.hashCode ^
      admin.hashCode ^
      depense.hashCode;
  }
}
