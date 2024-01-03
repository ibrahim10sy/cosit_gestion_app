import 'dart:convert';

import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/DemandeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AjoutDemande extends StatefulWidget {
  const AjoutDemande({super.key});

  @override
  State<AjoutDemande> createState() => _AjoutDemandeState();
}

const d_red = Colors.red;

class _AjoutDemandeState extends State<AjoutDemande> {
  TextEditingController motifController = TextEditingController();
  TextEditingController montant_control = TextEditingController();

  late Admin admin;
  late Future _admin;
  int? adminValue;
  late Utilisateur utilisateur;

  @override
  void initState() {
    super.initState();
    _admin = http.get(Uri.parse('http://10.0.2.2:8080/Admin/list'));

    utilisateur =
        Provider.of<UtilisateurProvider>(context, listen: false).utilisateur!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBars(),
      body: SingleChildScrollView(
        child: Column(children: [
          const CustomCard(
            title: "Demande ",
            imagePath: 'assets/images/demande.png',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              height: 390,
              width: 350,
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
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Text(
                      'Motif :',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: d_red),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 15),
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xfff9f7f7),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 7,
                            color: Color.fromRGBO(0, 0, 0, 0.25))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: TextField(
                        controller: motifController,
                        maxLines: 3,
                        decoration: const InputDecoration.collapsed(
                            hintText: "Motif de la demande"),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/share.png',
                            width: 23,
                          ),
                          const Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Montant :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red),
                                )),
                          ),
                          Expanded(
                              flex: 2,
                              child: TextField(
                                controller: montant_control,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: 'montant',
                                  prefixIcon: const Icon(
                                    Icons.attach_money_sharp,
                                    color: d_red,
                                    size: 30.0,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          15), // Adjust the padding as needed
                                ),
                              )),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/categorie.png',
                          width: 23,
                        ),
                        const Expanded(
                            flex: 2,
                            child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text("Admin",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red,
                                    )))),
                        Expanded(
                          flex: 4,
                          child: FutureBuilder(
                              future: _admin,
                              builder: (_, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return DropdownButton(
                                      value: "Selectionner",
                                      items: const [],
                                      dropdownColor: d_red,
                                      onChanged: (value) {});
                                }
                                if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                if (snapshot.hasData) {
                                  final response =
                                      json.decode(snapshot.data.body) as List;

                                  final admins = response
                                      .map((e) => Admin.fromMap(e))
                                      .toList();
                                  return DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                          ), //border of dropdown button
                                          borderRadius: BorderRadius.circular(
                                              20), //border raiuds of dropdown button
                                          boxShadow: const <BoxShadow>[
                                            //apply shadow on Dropdown button
                                            BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0,
                                                    0.57), //shadow for button
                                                blurRadius:
                                                    0) //blur radius of shadow
                                          ]),
                                      child: DropdownButton(
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: d_red,
                                          ),
                                          items: admins
                                              .map((e) => DropdownMenuItem(
                                                  value: e.idAdmin,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        '${e.nom} ${e.prenom}'),
                                                  )))
                                              .toList(),
                                          value: adminValue,
                                          onChanged: (newValue) {
                                            setState(() {
                                              adminValue = newValue;
                                              admin = admins.firstWhere(
                                                  (element) =>
                                                      element.idAdmin ==
                                                      newValue);
                                              debugPrint(
                                                  "Cate sélectionnée ${admin.idAdmin!}");
                                            });
                                          }));
                                }
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ), //border of dropdown button
                                      borderRadius: BorderRadius.circular(
                                          20), //border raiuds of dropdown button
                                      boxShadow: const <BoxShadow>[
                                        //apply shadow on Dropdown button
                                        BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0,
                                                0.57), //shadow for button
                                            blurRadius:
                                                0) //blur radius of shadow
                                      ]),
                                  child: DropdownButton(
                                      items: const [], onChanged: (value) {}),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                              onPressed: () async {
                                final motif = motifController.text;
                                final montant = montant_control.text;

                                if (motif.isEmpty || montant.isEmpty) {
                                  const String errorMessage =
                                      "Tous les champs doivent être remplis";
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Center(child: Text('Erreur')),
                                        content: const Text(errorMessage),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  final snackBar = SnackBar(
                                    content: const Text(
                                      'Validation en cours ...',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    backgroundColor:
                                        d_red, // Couleur de fond du SnackBar

                                    duration: const Duration(seconds: 14),
                                    action: SnackBarAction(
                                      label: 'Validation',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  try {
                                    await DemandeService()
                                        .addDemande(
                                            motif: motif,
                                            montantDemande: montant,
                                            utilisateur: utilisateur,
                                            admin: admin)
                                        .then((value) => {
                                              Provider.of<DemandeService>(
                                                      context,
                                                      listen: false)
                                                  .applyChange(),
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Center(
                                                        child: Text('Succès')),
                                                    content: const Text(
                                                        "Demande faite avec succès"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(context);
                                                        },
                                                        child: const Text('OK'),
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                              motifController.clear(),
                                              montant_control.clear()
                                            })
                                        .catchError(
                                            (onError) => {print(onError)});
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              label: const Text("Valider",
                                  style: TextStyle(color: Colors.white)),
                            )),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Annuler",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
//  Provider.of<DemandeService>(context,
//                                           listen: false)
//                                       .applyChange();
//                                   motifController.clear();
//                                   montant_control.clear();