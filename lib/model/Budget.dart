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

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      idBudget: json['idBudget'],
      description: json['description'],
      montant: json['montant'],
      montantRestant: json['montantRestant'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      admin: Admin.fromJson(json['admin']),
      utilisateur: json['utilisateur'] != null
          ? Utilisateur.fromJson(json['utilisateur'])
          : null,
    );
  }
}
