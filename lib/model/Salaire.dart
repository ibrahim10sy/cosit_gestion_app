import 'dart:convert';

import 'package:cosit_gestion/model/Utilisateur.dart';

class Salaire {
  final int? idSalaire;
  final String description;
  final int montant;
  final String date;
  final Utilisateur utilisateur;
  Salaire({
    this.idSalaire,
    required this.description,
    required this.montant,
    required this.date,
    required this.utilisateur,
  });

  Salaire copyWith({
    int? idSalaire,
    String? description,
    int? montant,
    String? date,
    Utilisateur? utilisateur,
  }) {
    return Salaire(
      idSalaire: idSalaire ?? this.idSalaire,
      description: description ?? this.description,
      montant: montant ?? this.montant,
      date: date ?? this.date,
      utilisateur: utilisateur ?? this.utilisateur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idSalaire': idSalaire,
      'description': description,
      'montant': montant,
      'date': date,
      'utilisateur': utilisateur.toMap(),
    };
  }

  factory Salaire.fromMap(Map<String, dynamic> map) {
    return Salaire(
      idSalaire: map['idSalaire'] != null ? map['idSalaire'] as int : null,
      description: map['description'] as String,
      montant: map['montant'] as int,
      date: map['date'] as String,
      utilisateur: Utilisateur.fromMap(map['utilisateur'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Salaire.fromJson(String source) => Salaire.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Salaire(idSalaire: $idSalaire, description: $description, montant: $montant, date: $date, utilisateur: $utilisateur)';
  }

  @override
  bool operator ==(covariant Salaire other) {
    if (identical(this, other)) return true;
  
    return 
      other.idSalaire == idSalaire &&
      other.description == description &&
      other.montant == montant &&
      other.date == date &&
      other.utilisateur == utilisateur;
  }

  @override
  int get hashCode {
    return idSalaire.hashCode ^
      description.hashCode ^
      montant.hashCode ^
      date.hashCode ^
      utilisateur.hashCode;
  }
}
