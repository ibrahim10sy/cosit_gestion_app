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
  

  CategorieDepense copyWith({
    int? idCategoriedepense,
    String? libelle,
    Utilisateur? utilisateur,
    Admin? admin,
  }) {
    return CategorieDepense(
      idCategoriedepense: idCategoriedepense ?? this.idCategoriedepense,
      libelle: libelle ?? this.libelle,
      utilisateur: utilisateur ?? this.utilisateur,
      admin: admin ?? this.admin,
    );
  }

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

  String toJson() => json.encode(toMap());

  factory CategorieDepense.fromJson(String source) => CategorieDepense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategorieDepense(idCategoriedepense: $idCategoriedepense, libelle: $libelle, utilisateur: $utilisateur, admin: $admin)';
  }

  @override
  bool operator ==(covariant CategorieDepense other) {
    if (identical(this, other)) return true;
  
    return 
      other.idCategoriedepense == idCategoriedepense &&
      other.libelle == libelle &&
      other.utilisateur == utilisateur &&
      other.admin == admin;
  }

  @override
  int get hashCode {
    return idCategoriedepense.hashCode ^
      libelle.hashCode ^
      utilisateur.hashCode ^
      admin.hashCode;
  }
}
