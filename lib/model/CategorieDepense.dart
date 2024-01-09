import 'dart:convert';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';

class CategorieDepense {
  final int? idCategoriedepense;
  final String libelle;
  final Utilisateur? utilisateur;
  final Admin? admin;

  CategorieDepense({
    required this.idCategoriedepense,
    required this.libelle,
    this.utilisateur,
    this.admin,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCategoriedepense': idCategoriedepense,
      'libelle': libelle,
      'utilisateur': utilisateur?.toMap(),
      'admin': admin?.toMap(),
    };
  }

  factory CategorieDepense.fromMap(Map<String, dynamic> map) {
    return CategorieDepense(
      idCategoriedepense: map['idCategoriedepense'] as int,
      libelle: map['libelle'] as String,
      utilisateur: map['utilisateur'] != null ? Utilisateur.fromMap(map['utilisateur'] as Map<String,dynamic>) : null,
      admin: map['admin'] != null ? Admin.fromMap(map['admin'] as Map<String,dynamic>) : null,
    );
  }
  factory CategorieDepense.fromJson(Map<String, dynamic> json) =>
      CategorieDepense(
        idCategoriedepense: json["idCategoriedepense"],
        libelle: json["libelle"],
        utilisateur: json['utilisateur'] != null
            ? Utilisateur.fromJson(json['utilisateur'])
            : null,
        admin: Admin.fromJson(json["admin"]),
      );
  
}
