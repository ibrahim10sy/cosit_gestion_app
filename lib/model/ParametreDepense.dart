import 'dart:convert';

class ParametreDepense {
    int? idParametre;
    final String description;
    final int montantSeuil;
  ParametreDepense({
    this.idParametre,
    required this.description,
    required this.montantSeuil,
  });

  ParametreDepense copyWith({
    int? idParametre,
    String? description,
    int? montantSeuil,
  }) {
    return ParametreDepense(
      idParametre: idParametre ?? this.idParametre,
      description: description ?? this.description,
      montantSeuil: montantSeuil ?? this.montantSeuil,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idParametre': idParametre,
      'description': description,
      'montantSeuil': montantSeuil,
    };
  }

  factory ParametreDepense.fromMap(Map<String, dynamic> map) {
    return ParametreDepense(
      idParametre: map['idParametre'] != null ? map['idParametre'] as int : null,
      description: map['description'] as String,
      montantSeuil: map['montantSeuil'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParametreDepense.fromJson(String source) => ParametreDepense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ParametreDepense(idParametre: $idParametre, description: $description, montantSeuil: $montantSeuil)';

  @override
  bool operator ==(covariant ParametreDepense other) {
    if (identical(this, other)) return true;
  
    return 
      other.idParametre == idParametre &&
      other.description == description &&
      other.montantSeuil == montantSeuil;
  }

  @override
  int get hashCode => idParametre.hashCode ^ description.hashCode ^ montantSeuil.hashCode;
}
