import 'dart:convert';

class Admin {
  final int? idAdmin;
  final String nom;
  final String prenom;
  final String email;
  final String? image;
  final String phone;
  final String passWord;
  Admin({
    this.idAdmin,
    required this.nom,
    required this.prenom,
    required this.email,
    this.image,
    required this.phone,
    required this.passWord,
  });
  

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idAdmin': idAdmin,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'image': image,
      'phone': phone,
      'passWord': passWord,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      idAdmin: map['idAdmin'] != null ? map['idAdmin'] as int : null,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      phone: map['phone'] as String,
      passWord: map['passWord'] as String,
    );
  }

   factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        idAdmin: json["idAdmin"],
        nom: json["nom"],
        prenom: json["prenom"],
        email: json["email"],
        image: json["image"],
        phone: json["phone"],
        passWord: json["passWord"],
      );
}
