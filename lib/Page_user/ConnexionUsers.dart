import 'dart:convert';

import 'package:cosit_gestion/Page_user/BottomNavigatioPage.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ConnexionUsers extends StatefulWidget {
  const ConnexionUsers({super.key});

  @override
  State<ConnexionUsers> createState() => _ConnexionUsersState();
}

const d_red = Colors.red;

class _ConnexionUsersState extends State<ConnexionUsers> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController motDePasseController = TextEditingController();
  String _errorMessage = '';

  String name = '';
  String email = '';
  String image = '';

  Future<void> loginUser() async {
    final String email = emailController.text;
    final String passWord = motDePasseController.text;
    const String baseUrl = 'http://10.0.2.2:8080/utilisateur/login';

    UtilisateurProvider utilisateurProvider =
        Provider.of<UtilisateurProvider>(context, listen: false);

    if (email.isEmpty || passWord.isEmpty) {
      const String errorMessage = "Veuillez remplir tous les champs ";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content: const Text(errorMessage),
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
      return;
    }

    final Uri apiUrl = Uri.parse('$baseUrl?email=$email&passWord=$passWord');

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Connexion en cours')),
              content: CupertinoActivityIndicator(
                color: d_red,
                radius: 22,
              ),
              actions: <Widget>[
                // Pas besoin de bouton ici
              ],
            );
          },
        );

        await Future.delayed(Duration(milliseconds: 60));

        Navigator.of(context).pop();
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        emailController.clear();
        motDePasseController.clear();

        Utilisateur utilisateur = Utilisateur(
          nom: responseBody['nom'],
          prenom: responseBody['prenom'],
          image: responseBody['image'],
          email: email,
          role: responseBody['role'],
          phone: responseBody['phone'],
          passWord: passWord,
          idUtilisateur: responseBody['idUtilisateur'],
        );

        utilisateurProvider.setUtilisateur(utilisateur);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()));
      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Connexion echouer !')),
              content: const Text("Email ou mot de passe incorrect"),
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
      }
    } catch (e) {
      Navigator.of(context)
          .pop(); // Fermer le AlertDialog avec la barre de progression
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Erreur')),
            content:
                const Text("Une erreur s'est produite. Veuillez réessayer."),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 170,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 115),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Image.asset('assets/images/logo.png')),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Text(
                  'Connexion en tant que Employer',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
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
                            // borderSide:
                            //     BorderSide(color: Colors.black, width: 2.0),
                            ),
                      ),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    child: TextField(
                      controller: motDePasseController,
                      obscureText: true,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        hintText: 'Mot de passe',
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
                          horizontal: 40, vertical: 30),
                      child: ElevatedButton(
                        onPressed: loginUser,
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: d_red,
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Text(
                          'Connexion',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ),
              ]),
            ),
          ],
        ),
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
