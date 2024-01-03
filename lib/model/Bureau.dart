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

  Bureau copyWith({
    int? idBureau,
    String? nom,
    String? adresse,
  }) {
    return Bureau(
      idBureau: idBureau ?? this.idBureau,
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
    );
  }

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

  String toJson() => json.encode(toMap());

  factory Bureau.fromJson(String source) => Bureau.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Bureau(idBureau: $idBureau, nom: $nom, adresse: $adresse)';

  @override
  bool operator ==(covariant Bureau other) {
    if (identical(this, other)) return true;
  
    return 
      other.idBureau == idBureau &&
      other.nom == nom &&
      other.adresse == adresse;
  }

  @override
  int get hashCode => idBureau.hashCode ^ nom.hashCode ^ adresse.hashCode;
}
