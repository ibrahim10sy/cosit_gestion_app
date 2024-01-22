import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:flutter/material.dart';

class UtilisateurDetail extends StatefulWidget {
  final Utilisateur utilisateur;

  const UtilisateurDetail({Key? key, required this.utilisateur})
      : super(key: key);

  @override
  State<UtilisateurDetail> createState() => _UtilisateurDetailState();
}

class _UtilisateurDetailState extends State<UtilisateurDetail> {
  late Utilisateur utilisateurs;

  @override
  void initState() {
    utilisateurs = widget.utilisateur;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(), // Remplacez par votre implémentation de CustomAppBar
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomCard(
              imagePath: "assets/images/employe.png",
              title: "Détails du Profil",
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 450,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(40, 15, 15, 15),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: utilisateurs.image == null ||
                                utilisateurs.image?.isEmpty == true
                            ? CircleAvatar(
                                backgroundColor:
                                    Colors.red, // Remplacez par votre couleur
                                radius: 30,
                                child: Text(
                                  "${utilisateurs.prenom.substring(0, 1).toUpperCase()}${utilisateurs.nom.substring(0, 1).toUpperCase()}",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              )
                            : Image.network(
                                utilisateurs.image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Nom : ${utilisateurs.nom}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Prénom : ${utilisateurs.prenom}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Email : ${utilisateurs.email}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rôle : ${utilisateurs.role}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Téléphone : ${utilisateurs.phone}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Ajouter un bouton d'édition pour la modification du profil
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
