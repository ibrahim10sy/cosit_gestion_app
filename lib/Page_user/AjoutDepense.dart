import 'dart:convert';
import 'dart:io';

import 'package:cosit_gestion/ImagePick.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/CategorieDepense.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AjoutDepense extends StatefulWidget {
  const AjoutDepense({super.key});

  @override
  State<AjoutDepense> createState() => _AjoutDepenseState();
}

const d_red = Colors.red;

class _AjoutDepenseState extends State<AjoutDepense> {
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController montant_control = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Utilisateur utilisateur;
  late CategorieDepense categorieDepense;
  late Bureau bureau;
  late Budget budget;
  late Future _categories;
  late Future _bureau;
  late Future _budget;
  int? catValue;
  int? bureauValue;
  int? budgetValue;
  String? imageSrc;
  File? photo;

  @override
  void initState() {
    super.initState();
    utilisateur =
        Provider.of<UtilisateurProvider>(context, listen: false).utilisateur!;
    _categories = http.get(Uri.parse(
        'http://10.0.2.2:8080/Categorie/listeByUser/${utilisateur.idUtilisateur}'));
    _bureau = http.get(Uri.parse('http://10.0.2.2:8080/Bureau/read'));
    _budget = http.get(Uri.parse('http://10.0.2.2:8080/Budget/listeByUser/${utilisateur.idUtilisateur}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBars(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomCard(
              title: "Ajout dépense",
              imagePath: "assets/images/depense.png",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                height: 500,
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
                                  child: Text("Catégorie",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: d_red,
                                      )))),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                                future: _categories,
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

                                    final mesCat = response
                                        .map((e) => CategorieDepense.fromMap(e))
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
                                            items: mesCat
                                                .map((e) => DropdownMenuItem(
                                                    value: e.idCategoriedepense,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(e.libelle),
                                                    )))
                                                .toList(),
                                            value: catValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                catValue = newValue;
                                                categorieDepense = mesCat
                                                    .firstWhere((element) =>
                                                        element
                                                            .idCategoriedepense ==
                                                        newValue);
                                                debugPrint(
                                                    "Cate sélectionnée ${categorieDepense.idCategoriedepense!}");
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
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/budget.png',
                            width: 23,
                          ),
                          const Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "Budgets",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red,
                                    ),
                                  ))),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                              future: _budget,
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

                                  final mesBudgets = response
                                      .map((e) => Budget.fromMap(e))
                                      .toList();
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.57),
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: DropdownButton(
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: d_red,
                                      ),
                                      items: mesBudgets
                                          .map((e) => DropdownMenuItem(
                                                value: e.idBudget,
                                                key: Key(e.idBudget.toString()),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(e.description),
                                                ),
                                              ))
                                          .toList(),
                                      value: budgetValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          budgetValue = newValue;
                                          budget = mesBudgets.firstWhere(
                                              (element) =>
                                                  element.idBudget == newValue);
                                          debugPrint(
                                              "Budget sélectionnée ${budget.description}");
                                        });
                                      },
                                    ),
                                  );
                                }
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.57),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: DropdownButton(
                                    items: const [],
                                    onChanged: (value) {},
                                  ),
                                );
                              },
                            ),
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
                            'assets/images/house.png',
                            width: 23,
                          ),
                          const Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "Bureau",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red),
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                              future: _bureau,
                              builder: (_, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return DropdownButton(
                                    value: "Sélectionner",
                                    items: const [],
                                    dropdownColor: d_red,
                                    onChanged: (value) {},
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                if (snapshot.hasData) {
                                  final response =
                                      json.decode(snapshot.data.body) as List;

                                  final mesBureau = response
                                      .map((e) => Bureau.fromMap(e))
                                      .toList();
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.57),
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: DropdownButton(
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: d_red,
                                      ),
                                      items: mesBureau
                                          .map((e) => DropdownMenuItem(
                                                value: e.idBureau,
                                                key: Key(e.idBureau.toString()),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Text(e.adresse),
                                                ),
                                              ))
                                          .toList(),
                                      value: bureauValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          bureauValue = newValue;
                                          bureau = mesBureau.firstWhere(
                                            (element) =>
                                                element.idBureau == newValue,
                                          );
                                          debugPrint(
                                              "Bureau sélectionnée ${bureau.idBureau}");
                                        });
                                      },
                                    ),
                                  );
                                }
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.57),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: DropdownButton(
                                    items: const [],
                                    onChanged: (value) {},
                                  ),
                                );
                              },
                            ),
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
                                    firstDate: DateTime(1950),
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
                                  'Justificatif',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: d_red),
                                )),
                          ),
                          Expanded(
                            flex: 2,
                            child: ImagePickerComponent(
                              onImageSelected: (File selectedImage) {
                                imageSrc = selectedImage.path;
                                photo = selectedImage;
                                print("Image selectionné $imageSrc");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                                  // double? montant = double.tryParse(montants);
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
                                    if (photo != null) {
                                      await DepenseService().addDepenseByUser(
                                          description: description,
                                          montantDepense: montant,
                                          dateDepense: date,
                                          utilisateur: utilisateur,
                                          image: photo,
                                          categorieDepense: categorieDepense,
                                          bureau: bureau,
                                          budget: budget);
                                    } else {
                                      await DepenseService().addDepenseByUser(
                                          description: description,
                                          montantDepense: montant,
                                          dateDepense: date,
                                          utilisateur: utilisateur,
                                          categorieDepense: categorieDepense,
                                          bureau: bureau,
                                          budget: budget);
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Succès')),
                                          content: const Text(
                                              "Depense ajoutée avec succès sans image"),
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
                                    Provider.of<DepenseService>(context,
                                            listen: false)
                                        .applyChange();
                                    descriptionController.clear();
                                    montant_control.clear();
                                    dateController.clear();
                                  } catch (e) {
                                    final String errorMessage = e.toString();
                                    print(errorMessage);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Erreur')),
                                          content: const Text(
                                              "Désolé Budget epuisé ou montant inférieur"),
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
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: const Text("Ajouter",
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
          ],
        ),
      ),
    );
  }
}
