// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/model/ParametreDepense.dart';
import 'package:cosit_gestion/model/SousCategorie.dart';
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
  final SousCategorie sousCategorie;
  final Bureau bureau;
  final Budget budget;
  final ParametreDepense? parametreDepense;
  bool viewed;
  final bool autorisationAdmin;
  
  Depense({
    this.idDepense,
    this.image,
    required this.description,
    required this.montantDepense,
    required this.dateDepense,
    this.utilisateur,
    this.admin,
    this.demande,
    required this.sousCategorie,
    required this.bureau,
    required this.budget,
    this.parametreDepense,
    required this.viewed,
    required this.autorisationAdmin,
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
    SousCategorie? sousCategorie,
    Bureau? bureau,
    Budget? budget,
    ParametreDepense? parametreDepense,
    bool? viewed,
    bool? autorisationAdmin,
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
      sousCategorie: sousCategorie ?? this.sousCategorie,
      bureau: bureau ?? this.bureau,
      budget: budget ?? this.budget,
      parametreDepense: parametreDepense ?? this.parametreDepense,
      viewed: viewed ?? this.viewed,
      autorisationAdmin: autorisationAdmin ?? this.autorisationAdmin,
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
      'sousCategorie': sousCategorie.toMap(),
      'bureau': bureau.toMap(),
      'budget': budget.toMap(),
      'parametreDepense': parametreDepense?.toMap(),
      'viewed': viewed,
      'autorisationAdmin': autorisationAdmin,
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
      sousCategorie: SousCategorie.fromMap(map['sousCategorie'] as Map<String,dynamic>),
      bureau: Bureau.fromMap(map['bureau'] as Map<String,dynamic>),
      budget: Budget.fromMap(map['budget'] as Map<String,dynamic>),
      parametreDepense: map['parametreDepense'] != null ? ParametreDepense.fromMap(map['parametreDepense'] as Map<String,dynamic>) : null,
      viewed: map['viewed'] as bool,
      autorisationAdmin: map['autorisationAdmin'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Depense.fromJson(String source) => Depense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Depense(idDepense: $idDepense, image: $image, description: $description, montantDepense: $montantDepense, dateDepense: $dateDepense, utilisateur: $utilisateur, admin: $admin, demande: $demande, sousCategorie: $sousCategorie, bureau: $bureau, budget: $budget, parametreDepense: $parametreDepense, viewed: $viewed, autorisationAdmin: $autorisationAdmin)';
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
      other.sousCategorie == sousCategorie &&
      other.bureau == bureau &&
      other.budget == budget &&
      other.parametreDepense == parametreDepense &&
      other.viewed == viewed &&
      other.autorisationAdmin == autorisationAdmin;
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
      sousCategorie.hashCode ^
      bureau.hashCode ^
      budget.hashCode ^
      parametreDepense.hashCode ^
      viewed.hashCode ^
      autorisationAdmin.hashCode;
  }
}
