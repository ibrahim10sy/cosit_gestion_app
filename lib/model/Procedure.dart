import 'dart:convert';

class Procedure {
  int? total_depenses;
  String? libelle;
  int? id_categoriedepense;
  int? id_depense;
  int? admin_id;
  int? utilisateur_id;
  String? date;
  String? mois;
  String? nom_bureau;
  int? id_sous_categorie;
  String? sous_categorie;
  
  Procedure({
    this.total_depenses,
    this.libelle,
    this.id_categoriedepense,
    this.id_depense,
    this.admin_id,
    this.utilisateur_id,
    this.date,
    this.mois,
    this.nom_bureau,
    this.id_sous_categorie,
    this.sous_categorie,
  });

  Procedure copyWith({
    int? total_depenses,
    String? libelle,
    int? id_categoriedepense,
    int? id_depense,
    int? admin_id,
    int? utilisateur_id,
    String? date,
    String? mois,
    String? nom_bureau,
    int? id_sous_categorie,
    String? sous_categorie,
  }) {
    return Procedure(
      total_depenses: total_depenses ?? this.total_depenses,
      libelle: libelle ?? this.libelle,
      id_categoriedepense: id_categoriedepense ?? this.id_categoriedepense,
      id_depense: id_depense ?? this.id_depense,
      admin_id: admin_id ?? this.admin_id,
      utilisateur_id: utilisateur_id ?? this.utilisateur_id,
      date: date ?? this.date,
      mois: mois ?? this.mois,
      nom_bureau: nom_bureau ?? this.nom_bureau,
      id_sous_categorie: id_sous_categorie ?? this.id_sous_categorie,
      sous_categorie: sous_categorie ?? this.sous_categorie,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_depenses': total_depenses,
      'libelle': libelle,
      'id_categoriedepense': id_categoriedepense,
      'id_depense': id_depense,
      'admin_id': admin_id,
      'utilisateur_id': utilisateur_id,
      'date': date,
      'mois': mois,
      'nom_bureau': nom_bureau,
      'id_sous_categorie': id_sous_categorie,
      'sous_categorie': sous_categorie,
    };
  }

  factory Procedure.fromMap(Map<String, dynamic> map) {
    return Procedure(
      total_depenses: map['total_depenses'] != null ? map['total_depenses'] as int : null,
      libelle: map['libelle'] != null ? map['libelle'] as String : null,
      id_categoriedepense: map['id_categoriedepense'] != null ? map['id_categoriedepense'] as int : null,
      id_depense: map['id_depense'] != null ? map['id_depense'] as int : null,
      admin_id: map['admin_id'] != null ? map['admin_id'] as int : null,
      utilisateur_id: map['utilisateur_id'] != null ? map['utilisateur_id'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      mois: map['mois'] != null ? map['mois'] as String : null,
      nom_bureau: map['nom_bureau'] != null ? map['nom_bureau'] as String : null,
      id_sous_categorie: map['id_sous_categorie'] != null ? map['id_sous_categorie'] as int : null,
      sous_categorie: map['sous_categorie'] != null ? map['sous_categorie'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Procedure.fromJson(String source) => Procedure.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Procedure(total_depenses: $total_depenses, libelle: $libelle, id_categoriedepense: $id_categoriedepense, id_depense: $id_depense, admin_id: $admin_id, utilisateur_id: $utilisateur_id, date: $date, mois: $mois, nom_bureau: $nom_bureau, id_sous_categorie: $id_sous_categorie, sous_categorie: $sous_categorie)';
  }

  @override
  bool operator ==(covariant Procedure other) {
    if (identical(this, other)) return true;
  
    return 
      other.total_depenses == total_depenses &&
      other.libelle == libelle &&
      other.id_categoriedepense == id_categoriedepense &&
      other.id_depense == id_depense &&
      other.admin_id == admin_id &&
      other.utilisateur_id == utilisateur_id &&
      other.date == date &&
      other.mois == mois &&
      other.nom_bureau == nom_bureau &&
      other.id_sous_categorie == id_sous_categorie &&
      other.sous_categorie == sous_categorie;
  }

  @override
  int get hashCode {
    return total_depenses.hashCode ^
      libelle.hashCode ^
      id_categoriedepense.hashCode ^
      id_depense.hashCode ^
      admin_id.hashCode ^
      utilisateur_id.hashCode ^
      date.hashCode ^
      mois.hashCode ^
      nom_bureau.hashCode ^
      id_sous_categorie.hashCode ^
      sous_categorie.hashCode;
  }
}
