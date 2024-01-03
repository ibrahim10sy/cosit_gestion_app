import 'dart:convert';

import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';

class Demande {
  final int? idDemande;
  final String motif;
  final int montantDemande;
  final String dateDemande;
  final bool autorisationDirecteur;
  final bool autorisationAdmin;
  final Admin admin;
  final Utilisateur utilisateur;
  final Depense? depense;

  Demande({
    this.idDemande,
    required this.motif,
    required this.montantDemande,
    required this.dateDemande,
    required this.autorisationDirecteur,
    required this.autorisationAdmin,
    required this.admin,
    required this.utilisateur,
    this.depense,
  });
 

  Demande copyWith({
    int? idDemande,
    String? motif,
    int? montantDemande,
    String? dateDemande,
    bool? autorisationDirecteur,
    bool? autorisationAdmin,
    Admin? admin,
    Utilisateur? utilisateur,
    Depense? depense,
  }) {
    return Demande(
      idDemande: idDemande ?? this.idDemande,
      motif: motif ?? this.motif,
      montantDemande: montantDemande ?? this.montantDemande,
      dateDemande: dateDemande ?? this.dateDemande,
      autorisationDirecteur: autorisationDirecteur ?? this.autorisationDirecteur,
      autorisationAdmin: autorisationAdmin ?? this.autorisationAdmin,
      admin: admin ?? this.admin,
      utilisateur: utilisateur ?? this.utilisateur,
      depense: depense ?? this.depense,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idDemande': idDemande,
      'motif': motif,
      'montantDemande': montantDemande,
      'dateDemande': dateDemande,
      'autorisationDirecteur': autorisationDirecteur,
      'autorisationAdmin': autorisationAdmin,
      'admin': admin.toMap(),
      'utilisateur': utilisateur.toMap(),
      'depense': depense?.toMap(),
    };
  }

  factory Demande.fromMap(Map<String, dynamic> map) {
    return Demande(
      idDemande: map['idDemande'] != null ? map['idDemande'] as int : null,
      motif: map['motif'] as String,
      montantDemande: map['montantDemande'] as int,
      dateDemande: map['dateDemande'] as String,
      autorisationDirecteur: map['autorisationDirecteur'] as bool,
      autorisationAdmin: map['autorisationAdmin'] as bool,
      admin: Admin.fromMap(map['admin'] as Map<String,dynamic>),
      utilisateur: Utilisateur.fromMap(map['utilisateur'] as Map<String,dynamic>),
      depense: map['depense'] != null ? Depense.fromMap(map['depense'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Demande.fromJson(String source) => Demande.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Demande(idDemande: $idDemande, motif: $motif, montantDemande: $montantDemande, dateDemande: $dateDemande, autorisationDirecteur: $autorisationDirecteur, autorisationAdmin: $autorisationAdmin, admin: $admin, utilisateur: $utilisateur, depense: $depense)';
  }

  @override
  bool operator ==(covariant Demande other) {
    if (identical(this, other)) return true;
  
    return 
      other.idDemande == idDemande &&
      other.motif == motif &&
      other.montantDemande == montantDemande &&
      other.dateDemande == dateDemande &&
      other.autorisationDirecteur == autorisationDirecteur &&
      other.autorisationAdmin == autorisationAdmin &&
      other.admin == admin &&
      other.utilisateur == utilisateur &&
      other.depense == depense;
  }

  @override
  int get hashCode {
    return idDemande.hashCode ^
      motif.hashCode ^
      montantDemande.hashCode ^
      dateDemande.hashCode ^
      autorisationDirecteur.hashCode ^
      autorisationAdmin.hashCode ^
      admin.hashCode ^
      utilisateur.hashCode ^
      depense.hashCode;
  }
}
