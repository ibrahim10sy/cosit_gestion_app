import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Salaire.dart';
import 'package:cosit_gestion/model/SousCategorie.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/service/SalaireService.dart';
import 'package:cosit_gestion/service/SousCategorieService.dart';
import 'package:cosit_gestion/service/UtilisateurService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:provider/provider.dart';

class UpdateSalaire extends StatefulWidget {
  final Salaire salaires;

  const UpdateSalaire({super.key, required this.salaires});

  @override
  State<UpdateSalaire> createState() => _UpdateSalaireState();
}

const d_red = Colors.red;

class _UpdateSalaireState extends State<UpdateSalaire> {
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController montant_control = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Future<List<Utilisateur>> _utilisateur;
  late Future<List<SousCategorie>> _categorie;
  late Utilisateur user;
  late SousCategorie sousCategorie;

  String employe = "";
  int? userValue;
  int? catValue;
  late Salaire salaire;

  Future<List<SousCategorie>> getCategorie() async {
    return SousCategorieService().fetchAllSousCategorie();
  }

  Future<List<Utilisateur>> getUser() async {
    return UtilisateurService().fetchData();
  }

  @override
  void initState() {
    salaire = widget.salaires;
    descriptionController.text = salaire.description;
    montant_control.text = salaire.montant.toString();
    userController.text = salaire.utilisateur.toString();
    dateController.text = salaire.date;
    employe = salaire.utilisateur.toString();
    _utilisateur = getUser();
    _categorie = getCategorie();
    // Initialisation les valeurs des listes déroulantes
    userValue = salaire.utilisateur.idUtilisateur;
    catValue = salaire.sousCategorie.idSousCategorie;
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    montant_control.dispose();
    userController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomCard(
              title: "Modifier salaire",
              imagePath: "assets/images/piece.png",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                height: 480,
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
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        'Description :',
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
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Une description"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/employe.png',
                            width: 23,
                          ),
                          const Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "Employée",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red),
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                                future: _utilisateur,
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
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: d_red,
                                          ),
                                          hint: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              "Choisir un employé",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          items: const [],
                                          onChanged: (value) {}),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    List<Utilisateur> utilisateur =
                                        snapshot.data!;

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
                                        // padding: const EdgeInsets.all(12),
                                                 value: userValue,
                                        items: utilisateur
                                            .map((e) => DropdownMenuItem(
                                                  value: e.idUtilisateur,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('${e.nom} ${e.prenom}'),
                                                  ),
                                                ))
                                            .toList(),
                               
                                        onChanged: (newValue) {
                                          setState(() {
                                            userValue = newValue;
                                            user = utilisateur.firstWhere(
                                                (element) =>
                                                    element.idUtilisateur ==
                                                    newValue);
                                            debugPrint(
                                                "User categorie sélectionnée ${user.toString()}");
                                          });
                                        },
                                      ),
                                    );
                                  }
                                  return DropdownButton(
                                      items: const [], onChanged: (value) {});
                                }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
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
                                child: Text(
                                  "Catégorie",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red),
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                                future: _categorie,
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
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: d_red,
                                          ),
                                          hint: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              "Choisir une catégorie",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          items: const [],
                                          onChanged: (value) {}),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    List<SousCategorie> sousCategories =
                                        snapshot.data!;

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
                                        // padding: const EdgeInsets.all(12),
                                             value: catValue,
                                        items: sousCategories
                                            .map((e) => DropdownMenuItem(
                                                  value: e.idSousCategorie,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(e.libelle),
                                                  ),
                                                ))
                                            .toList(),
                                    
                                        onChanged: (newValue) {
                                          setState(() {
                                            catValue = newValue;
                                            sousCategorie = sousCategories
                                                .firstWhere((element) =>
                                                    element.idSousCategorie ==
                                                    newValue);
                                            debugPrint(
                                                "Sous categorie sélectionnée ${catValue.toString()}");
                                          });
                                        },
                                      ),
                                    );
                                  }
                                  return DropdownButton(
                                      items: const [], onChanged: (value) {});
                                }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
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
                                  inputFormatters: [
                                    ThousandsFormatter(),
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
                                ))
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/calendrier.png',
                            width: 23,
                          ),
                          const Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Date:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red),
                                )),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: dateController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Sélectionner la date',

                                prefixIcon: const Icon(
                                  Icons.date_range,
                                  color: d_red,
                                  size: 30.0,
                                ),
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
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (pickedDate != null) {
                                  print(pickedDate);
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(formattedDate);
                                  setState(() {
                                    dateController.text = formattedDate;
                                  });
                                } else {}
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
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
                                  final description =
                                      descriptionController.text;
                                  final montant = montant_control.text;
                                  final date = dateController.text;
                                  String formattedMontant =
                                      montant_control.text.replaceAll(',', '');
                                  int montants = int.parse(formattedMontant);                                  
                                  if (description.isEmpty ||
                                      montant.isEmpty ||
                                      date.isEmpty) {
                                    const String errorMessage =
                                        "Tous les champs doivent être remplis";
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Erreur')),
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
                                  }

                                  try {
                                    await SalaireService().updateSalaire(
                                        idSalaire: salaire.idSalaire!,
                                        description: description,
                                        montant: montants.toString(),
                                        date: date,
                                        sousCategorie: sousCategorie,
                                        utilisateur: user);

                                    Provider.of<SalaireService>(context,
                                            listen: false)
                                        .applyChange();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Succès')),
                                          content: const Text(
                                              "Salaire modifié avec succès"),
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
                                    );

                                    descriptionController.clear();
                                    montant_control.clear();
                                    userController.clear();
                                    dateController.clear();
                                     // Réinitialiser les valeurs des variables de sélection
                                    setState(() {
                                      userValue = null;
                                      catValue = null;
                                    });
                                  } catch (e) {
                                    final String errorMessage = e.toString();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Erreur')),
                                          content: Text(errorMessage.replaceAll(
                                              "Exception:", "")),
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
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                label: const Text("Modifier",
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
            ),
          ],
        ),
      ),
    );
  }
}
