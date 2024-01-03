import 'dart:convert';

class Procedure {
  int? total_depenses;
  String libelle;
  int? id_categoriedepense;
  int? id_depense;
  int? admin_id;
  int? utilisateur_id;

  Procedure({
    this.total_depenses,
    required this.libelle,
    this.id_categoriedepense,
    this.id_depense,
    this.admin_id,
    this.utilisateur_id,
  });

 

  Procedure copyWith({
    int? total_depenses,
    String? libelle,
    int? id_categoriedepense,
    int? id_depense,
    int? admin_id,
    int? utilisateur_id,
  }) {
    return Procedure(
      total_depenses: total_depenses ?? this.total_depenses,
      libelle: libelle ?? this.libelle,
      id_categoriedepense: id_categoriedepense ?? this.id_categoriedepense,
      id_depense: id_depense ?? this.id_depense,
      admin_id: admin_id ?? this.admin_id,
      utilisateur_id: utilisateur_id ?? this.utilisateur_id,
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
    };
  }

  factory Procedure.fromMap(Map<String, dynamic> map) {
    return Procedure(
      total_depenses: map['total_depenses'] != null ? map['total_depenses'] as int : null,
      libelle: map['libelle'] as String,
      id_categoriedepense: map['id_categoriedepense'] != null ? map['id_categoriedepense'] as int : null,
      id_depense: map['id_depense'] != null ? map['id_depense'] as int : null,
      admin_id: map['admin_id'] != null ? map['admin_id'] as int : null,
      utilisateur_id: map['utilisateur_id'] != null ? map['utilisateur_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Procedure.fromJson(String source) => Procedure.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Procedure(total_depenses: $total_depenses, libelle: $libelle, id_categoriedepense: $id_categoriedepense, id_depense: $id_depense, admin_id: $admin_id, utilisateur_id: $utilisateur_id)';
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
      other.utilisateur_id == utilisateur_id;
  }

  @override
  int get hashCode {
    return total_depenses.hashCode ^
      libelle.hashCode ^
      id_categoriedepense.hashCode ^
      id_depense.hashCode ^
      admin_id.hashCode ^
      utilisateur_id.hashCode;
  }
}
