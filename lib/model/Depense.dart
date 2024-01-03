import 'dart:convert';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/CategorieDepense.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';

class Depense {
  final int? idDepense;
  final String? image;
  final String description;
  final int montantDepense;
  final String dateDepense;
  final Utilisateur? utilisateur;
  final Admin? admin;
  final Demande? demande;
  final CategorieDepense categorieDepense;
  final Bureau bureau;
  final Budget budget;
  
  Depense({
    this.idDepense,
    this.image,
    required this.description,
    required this.montantDepense,
    required this.dateDepense,
    this.utilisateur,
    this.admin,
    this.demande,
    required this.categorieDepense,
    required this.bureau,
    required this.budget,
  });

  Depense copyWith({
    int? idDepense,
    String? image,
    String? description,
    int? montantDepense,
    String? dateDepense,
    Utilisateur? utilisateur,
    Admin? admin,
    Demande? demande,
    CategorieDepense? categorieDepense,
    Bureau? bureau,
    Budget? budget,
  }) {
    return Depense(
      idDepense: idDepense ?? this.idDepense,
      image: image ?? this.image,
      description: description ?? this.description,
      montantDepense: montantDepense ?? this.montantDepense,
      dateDepense: dateDepense ?? this.dateDepense,
      utilisateur: utilisateur ?? this.utilisateur,
      admin: admin ?? this.admin,
      demande: demande ?? this.demande,
      categorieDepense: categorieDepense ?? this.categorieDepense,
      bureau: bureau ?? this.bureau,
      budget: budget ?? this.budget,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idDepense': idDepense,
      'image': image,
      'description': description,
      'montantDepense': montantDepense,
      'dateDepense': dateDepense,
      'utilisateur': utilisateur?.toMap(),
      'admin': admin?.toMap(),
      'demande': demande?.toMap(),
      'categorieDepense': categorieDepense.toMap(),
      'bureau': bureau.toMap(),
      'budget': budget.toMap(),
    };
  }

  factory Depense.fromMap(Map<String, dynamic> map) {
    return Depense(
      idDepense: map['idDepense'] != null ? map['idDepense'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      description: map['description'] as String,
      montantDepense: map['montantDepense'] as int,
      dateDepense: map['dateDepense'] as String,
      utilisateur: map['utilisateur'] != null ? Utilisateur.fromMap(map['utilisateur'] as Map<String,dynamic>) : null,
      admin: map['admin'] != null ? Admin.fromMap(map['admin'] as Map<String,dynamic>) : null,
      demande: map['demande'] != null ? Demande.fromMap(map['demande'] as Map<String,dynamic>) : null,
      categorieDepense: CategorieDepense.fromMap(map['categorieDepense'] as Map<String,dynamic>),
      bureau: Bureau.fromMap(map['bureau'] as Map<String,dynamic>),
      budget: Budget.fromMap(map['budget'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Depense.fromJson(String source) => Depense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Depense(idDepense: $idDepense, image: $image, description: $description, montantDepense: $montantDepense, dateDepense: $dateDepense, utilisateur: $utilisateur, admin: $admin, demande: $demande, categorieDepense: $categorieDepense, bureau: $bureau, budget: $budget)';
  }

  @override
  bool operator ==(covariant Depense other) {
    if (identical(this, other)) return true;
  
    return 
      other.idDepense == idDepense &&
      other.image == image &&
      other.description == description &&
      other.montantDepense == montantDepense &&
      other.dateDepense == dateDepense &&
      other.utilisateur == utilisateur &&
      other.admin == admin &&
      other.demande == demande &&
      other.categorieDepense == categorieDepense &&
      other.bureau == bureau &&
      other.budget == budget;
  }

  @override
  int get hashCode {
    return idDepense.hashCode ^
      image.hashCode ^
      description.hashCode ^
      montantDepense.hashCode ^
      dateDepense.hashCode ^
      utilisateur.hashCode ^
      admin.hashCode ^
      demande.hashCode ^
      categorieDepense.hashCode ^
      bureau.hashCode ^
      budget.hashCode;
  }
}
