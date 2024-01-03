// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  

  Admin copyWith({
    int? idAdmin,
    String? nom,
    String? prenom,
    String? email,
    String? image,
    String? phone,
    String? passWord,
  }) {
    return Admin(
      idAdmin: idAdmin ?? this.idAdmin,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      passWord: passWord ?? this.passWord,
    );
  }

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

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin(idAdmin: $idAdmin, nom: $nom, prenom: $prenom, email: $email, image: $image, phone: $phone, passWord: $passWord)';
  }

  @override
  bool operator ==(covariant Admin other) {
    if (identical(this, other)) return true;
  
    return 
      other.idAdmin == idAdmin &&
      other.nom == nom &&
      other.prenom == prenom &&
      other.email == email &&
      other.image == image &&
      other.phone == phone &&
      other.passWord == passWord;
  }

  @override
  int get hashCode {
    return idAdmin.hashCode ^
      nom.hashCode ^
      prenom.hashCode ^
      email.hashCode ^
      image.hashCode ^
      phone.hashCode ^
      passWord.hashCode;
  }
}
