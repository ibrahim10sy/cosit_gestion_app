import 'dart:io';

import 'package:cosit_gestion/DelayAnimation.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/UtilisateurService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class UpdateProfil extends StatefulWidget {
  
  final Utilisateur utilisateurs;
  const UpdateProfil({super.key, required this.utilisateurs});

  @override
  State<UpdateProfil> createState() => _UpdateProfilState();
}
const d_red = Colors.red;
List<String> list = <String>[
  'Directeur',
  'Comptable',
  'Sécretaire',
  'Développeur',
  'Développeuse'
];
class _UpdateProfilState extends State<UpdateProfil> {
   final _formKey = GlobalKey<FormState>();
  TextEditingController nom_controller = TextEditingController();
  TextEditingController prenom_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController role_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController motDepasse_controller = TextEditingController();
  TextEditingController ConfirmerMotDePasse_controller =
      TextEditingController();
  late Utilisateur utilisateur;
  late int utilisateurId;
  String? imageSrc;
  File? photo;
  String _errorMessage = '';
  late String defaultRole;
  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imagePermanent = await saveImagePermanently(image.path);

        setState(() {
          photo = imagePermanent;
          imageSrc = imagePermanent.path;
        });
      } else {
        throw Exception('Image non télécharger');
      }
    } on PlatformException catch (e) {
      debugPrint('erreur lors de téléchargement de l\'image : $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  void initState() {
    super.initState();
    utilisateur = widget.utilisateurs;
    utilisateurId = utilisateur.idUtilisateur!;
    nom_controller.text = utilisateur.nom;
    defaultRole = utilisateur.role;
    prenom_controller.text = utilisateur.prenom;
    email_controller.text = utilisateur.email;
    phone_controller.text = utilisateur.phone;
    ConfirmerMotDePasse_controller.text = utilisateur.passWord;
    motDepasse_controller.text = utilisateur.passWord;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 118),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: DelayedAnimation(
                delay: 2000,
                child: Center(
                  child: (photo != null)
                      ? Image.file(photo!)
                      : Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 5),
            decoration: const BoxDecoration(
                // color: Color(0xfff5f8fd),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                backgroundColor: const Color(0xff2ffffff), // Button color
              ),
              onPressed: () {
                _pickImage();
              },
              child: const Text(
                'Sélectionner une photo de profil',
                style: TextStyle(
                  color: d_red,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Inscription',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextField(
                      controller: nom_controller,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        labelText: 'Nom ',
                        prefixIcon: Icon(
                          Icons.person,
                          color: d_red,
                          size: 30.0,
                        ),
                        border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextField(
                      controller: prenom_controller,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        labelText: 'Prénom ',
                        prefixIcon: Icon(
                          Icons.person,
                          color: d_red,
                          size: 30.0,
                        ),
                        border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email_controller,
                      style: const TextStyle(fontSize: 18.0),
                      onChanged: (val) {
                        validateEmail(val);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        labelText: 'Email ',
                        prefixIcon: Icon(
                          Icons.email,
                          color: d_red,
                          size: 30.0,
                        ),
                        border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextField(
                      controller: phone_controller,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        labelText: 'Téléphone ',
                        prefixIcon: Icon(
                          Icons.phone_android_rounded,
                          color: d_red,
                          size: 30.0,
                        ),
                        border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )),
               
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextField(
                      obscureText: true,
                      controller: motDepasse_controller,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        labelText: 'Mot de passe ',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: d_red,
                          size: 30.0,
                        ),
                        border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextField(
                      obscureText: true,
                      controller: ConfirmerMotDePasse_controller,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        labelText: 'Confirmer mot de passe  ',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: d_red,
                          size: 30.0,
                        ),
                        border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        String nom = nom_controller.text;
                        String prenom = prenom_controller.text;
                        String email = email_controller.text;
                        String role = role_controller.text;
                        String phone = phone_controller.text;
                        String passWord = motDepasse_controller.text;
                        String Confirmer = ConfirmerMotDePasse_controller.text;

                        UtilisateurProvider utilisateurprovider =
                            Provider.of<UtilisateurProvider>(context,
                                listen: false);

                        if (nom.isEmpty ||
                            prenom.isEmpty ||
                            email.isEmpty ||
                            passWord.isEmpty) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Formulaire'),
                                content: const Text(
                                    "Veuillez remplir tous les champs"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (Confirmer != passWord) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Erreur de mot de passe'),
                                content: const Text(
                                    'les mots de passe ne doivent pas etre differents'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Utilisateur updateUtilisateur;
                          try {
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(
                                      color: d_red,
                                    ),
                                    SizedBox(width: 20),
                                    Text("Modification en cours..."),
                                  ],
                                ),
                              ),
                            );
                            if (photo != null) {
                              updateUtilisateur =
                                  await Provider.of<UtilisateurService>(context,
                                          listen: false)
                                      .updateUtilisateur(
                                          idUtilisateur: utilisateurId,
                                          nom: nom,
                                          prenom: prenom,
                                          email: email,
                                          phone: phone,
                                          role: defaultRole,
                                          passWord: passWord,
                                          image: photo as File);
                            } else {
                              updateUtilisateur =
                                  await Provider.of<UtilisateurService>(context,
                                          listen: false)
                                      .updateUtilisateur(
                                idUtilisateur: utilisateurId,
                                nom: nom,
                                prenom: prenom,
                                email: email,
                                phone: phone,
                                role: defaultRole,
                                passWord: passWord,
                              );
                              print(updateUtilisateur.toString());
                            }

                            Provider.of<UtilisateurProvider>(context,
                                    listen: false)
                                .setUtilisateur(updateUtilisateur);
                            Provider.of<UtilisateurService>(context,
                                    listen: false)
                                .applyChange();
                                 ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            // Afficher le message de succès
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Modifier  avec succès"),
                              ),
                            );
                            Navigator.of(context).pop();
                            nom_controller.clear();
                            prenom_controller.clear();
                            email_controller.clear();
                            phone_controller.clear();
                            role_controller.clear();
                            motDepasse_controller.clear();
                            ConfirmerMotDePasse_controller.clear();
                          } catch (e) {
                            throw Exception(
                                'Impossible de modifier le profil $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: d_red,
                        // shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Modifier',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    _errorMessage,
                    style: const TextStyle(color: d_red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email ne doit pas être vide";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Email non valide";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
