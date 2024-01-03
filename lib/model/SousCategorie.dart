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

  SousCategorie copyWith({
    int? idSousCategorie,
    String? libelle,
    CategorieDepense? categorieDepense,
  }) {
    return SousCategorie(
      idSousCategorie: idSousCategorie ?? this.idSousCategorie,
      libelle: libelle ?? this.libelle,
      categorieDepense: categorieDepense ?? this.categorieDepense,
    );
  }

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

  String toJson() => json.encode(toMap());

  factory SousCategorie.fromJson(String source) => SousCategorie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SousCategorie(idSousCategorie: $idSousCategorie, libelle: $libelle, categorieDepense: $categorieDepense)';

  @override
  bool operator ==(covariant SousCategorie other) {
    if (identical(this, other)) return true;
  
    return 
      other.idSousCategorie == idSousCategorie &&
      other.libelle == libelle &&
      other.categorieDepense == categorieDepense;
  }

  @override
  int get hashCode => idSousCategorie.hashCode ^ libelle.hashCode ^ categorieDepense.hashCode;
}
