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

  String toJson() => json.encode(toMap());

  factory Utilisateur.fromJson(String source) => Utilisateur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Utilisateur(idUtilisateur: $idUtilisateur, nom: $nom, prenom: $prenom, email: $email, image: $image, role: $role, phone: $phone, passWord: $passWord)';
  }

  @override
  bool operator ==(covariant Utilisateur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idUtilisateur == idUtilisateur &&
      other.nom == nom &&
      other.prenom == prenom &&
      other.email == email &&
      other.image == image &&
      other.role == role &&
      other.phone == phone &&
      other.passWord == passWord;
  }

  @override
  int get hashCode {
    return idUtilisateur.hashCode ^
      nom.hashCode ^
      prenom.hashCode ^
      email.hashCode ^
      image.hashCode ^
      role.hashCode ^
      phone.hashCode ^
      passWord.hashCode;
  }
}
