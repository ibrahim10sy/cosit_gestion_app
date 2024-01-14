import 'dart:convert';

class Utilisateur {
  final int? idUtilisateur;
  final String nom;
  final String prenom;
  final String email;
  final String? image;
  final String role;
  final String phone;
  final String passWord;

  Utilisateur({
    this.idUtilisateur,
    required this.nom,
    required this.prenom,
    required this.email,
    this.image,
    required this.role,
    required this.phone,
    required this.passWord,
  });

  Utilisateur copyWith({
    int? idUtilisateur,
    String? nom,
    String? prenom,
    String? email,
    String? image,
    String? role,
    String? phone,
    String? passWord,
  }) {
    return Utilisateur(
      idUtilisateur: idUtilisateur ?? this.idUtilisateur,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      image: image ?? this.image,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      passWord: passWord ?? this.passWord,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUtilisateur': idUtilisateur,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'image': image,
      'role': role,
      'phone': phone,
      'passWord': passWord,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      idUtilisateur: map['idUtilisateur'] != null ? map['idUtilisateur'] as int : null,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      role: map['role'] as String,
      phone: map['phone'] as String,
      passWord: map['passWord'] as String,
    );
  }

   factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      passWord: json['passWord'],
      idUtilisateur: json['idUtilisateur'],
      image: json['image'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
