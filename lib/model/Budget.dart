// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';

class Budget {
  final int? idBudget;
  final String description;
  final int montant;
  final int montantRestant;
  final String dateDebut;
  final String dateFin;
  final Admin admin;
  final Utilisateur? utilisateur;
  Budget({
    this.idBudget,
    required this.description,
    required this.montant,
    required this.montantRestant,
    required this.dateDebut,
    required this.dateFin,
    required this.admin,
    this.utilisateur,
  });
  

  Budget copyWith({
    int? idBudget,
    String? description,
    int? montant,
    int? montantRestant,
    String? dateDebut,
    String? dateFin,
    Admin? admin,
    Utilisateur? utilisateur,
  }) {
    return Budget(
      idBudget: idBudget ?? this.idBudget,
      description: description ?? this.description,
      montant: montant ?? this.montant,
      montantRestant: montantRestant ?? this.montantRestant,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      admin: admin ?? this.admin,
      utilisateur: utilisateur ?? this.utilisateur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idBudget': idBudget,
      'description': description,
      'montant': montant,
      'montantRestant': montantRestant,
      'dateDebut': dateDebut,
      'dateFin': dateFin,
      'admin': admin.toMap(),
      'utilisateur': utilisateur?.toMap(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      idBudget: map['idBudget'] != null ? map['idBudget'] as int : null,
      description: map['description'] as String,
      montant: map['montant'] as int,
      montantRestant: map['montantRestant'] as int,
      dateDebut: map['dateDebut'] as String,
      dateFin: map['dateFin'] as String,
      admin: Admin.fromMap(map['admin'] as Map<String,dynamic>),
      utilisateur: map['utilisateur'] != null ? Utilisateur.fromMap(map['utilisateur'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Budget(idBudget: $idBudget, description: $description, montant: $montant, montantRestant: $montantRestant, dateDebut: $dateDebut, dateFin: $dateFin, admin: $admin, utilisateur: $utilisateur)';
  }

  @override
  bool operator ==(covariant Budget other) {
    if (identical(this, other)) return true;
  
    return 
      other.idBudget == idBudget &&
      other.description == description &&
      other.montant == montant &&
      other.montantRestant == montantRestant &&
      other.dateDebut == dateDebut &&
      other.dateFin == dateFin &&
      other.admin == admin &&
      other.utilisateur == utilisateur;
  }

  @override
  int get hashCode {
    return idBudget.hashCode ^
      description.hashCode ^
      montant.hashCode ^
      montantRestant.hashCode ^
      dateDebut.hashCode ^
      dateFin.hashCode ^
      admin.hashCode ^
      utilisateur.hashCode;
  }
}
