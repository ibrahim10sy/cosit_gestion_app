import 'dart:convert';

import 'package:cosit_gestion/model/CategorieDepense.dart';

class SousCategorie {
  final int? idSousCategorie;
  final String libelle;
  final CategorieDepense categorieDepense;
  SousCategorie({
    this.idSousCategorie,
    required this.libelle,
    required this.categorieDepense,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idSousCategorie': idSousCategorie,
      'libelle': libelle,
      'categorieDepense': categorieDepense.toMap(),
    };
  }

  factory SousCategorie.fromMap(Map<String, dynamic> map) {
    return SousCategorie(
      idSousCategorie: map['idSousCategorie'] != null ? map['idSousCategorie'] as int : null,
      libelle: map['libelle'] as String,
      categorieDepense: CategorieDepense.fromMap(map['categorieDepense'] as Map<String,dynamic>),
    );
  }

  factory SousCategorie.fromJson(Map<String, dynamic> json) => 
     SousCategorie(
      idSousCategorie: json['idSousCategorie'],
      libelle: json['libelle'] as String,
      categorieDepense: CategorieDepense.fromJson(
            json['categorieDepense']),
    );
  

  
}
