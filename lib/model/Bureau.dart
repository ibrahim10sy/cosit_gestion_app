import 'dart:convert';

class Bureau {
  final int? idBureau;
  final String nom;
  final String adresse;
  Bureau({
    this.idBureau,
    required this.nom,
    required this.adresse,
  });

 
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idBureau': idBureau,
      'nom': nom,
      'adresse': adresse,
    };
  }

  factory Bureau.fromMap(Map<String, dynamic> map) {
    return Bureau(
      idBureau: map['idBureau'] != null ? map['idBureau'] as int : null,
      nom: map['nom'] as String,
      adresse: map['adresse'] as String,
    );
  }

  factory Bureau.fromJson(Map<String, dynamic> json) => Bureau(
        idBureau: json["idBureau"],
        nom: json["nom"],
        adresse: json["adresse"],
      );
}
