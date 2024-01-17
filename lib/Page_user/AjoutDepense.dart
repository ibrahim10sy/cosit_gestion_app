import 'dart:io';

import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/ParametreDepense.dart';
import 'package:cosit_gestion/model/SousCategorie.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/BudgetService.dart';
import 'package:cosit_gestion/service/BureauService.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:cosit_gestion/service/SousCategorieService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
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
  late SousCategorie sousCategorie;
  late ParametreDepense parametreDepense;
  late ParametreDepense parametreDepense1;
  late Bureau bureau;
  late Budget budget;
  late Future<List<ParametreDepense>> _parametre;
  late Future<List<SousCategorie>> _categorie;
  late Future<List<Bureau>> _bureau;
  late Future<List<Budget>> _budgets;
  int? catValue;
  int? bureauValue;
  int? budgetValue;
  String? imageSrc;
  File? photo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    utilisateur =
        Provider.of<UtilisateurProvider>(context, listen: false).utilisateur!;
    _bureau = getBureau();
    _categorie = getCategorie();
    _budgets = getBudget(utilisateur.idUtilisateur!);
    _parametre = getData();
    fetchData();
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<File?> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    return File(image.path);
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await getImage(source);
    if (image != null) {
      setState(() {
        this.photo = image;
        imageSrc = image.path;
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    final BuildContext context = this.context;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: AlertDialog(
            title: Text('Choisir une source'),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40),
                      Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Fermer le dialogue
                    _pickImage(ImageSource.gallery);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.image, size: 40),
                      Text('Galerie photo'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchData() async {
    // Récupérez les données depuis l'API
    List<ParametreDepense> data = await getData();

    if (data.isNotEmpty) {
      parametreDepense = data[0];
      parametreDepense.printInfo();
    } else {
      print("Aucune donnée n'a été récupérée depuis l'API.");
    }
  }

  Future<List<ParametreDepense>> getData() async {
    final response = await DepenseService().fetchParametre();

    return response;
  }

  Future<List<Bureau>> getBureau() async {
    return BureauService().fetchBureau();
  }

  Future<List<SousCategorie>> getCategorie() async {
    return SousCategorieService().fetchAllSousCategorie();
  }

  Future<List<Budget>> getBudget(int id) async {
    return BudgetService().fetchBudgetByUser(id);
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
                                future: _budgets,
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
                                              "Sélectionner un budget",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          items: const [],
                                          onChanged: (value) {}),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    List<Budget> budgets = snapshot.data!;

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
                                        items: budgets
                                            .map((e) => DropdownMenuItem(
                                                  value: e.idBudget,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(e.description),
                                                  ),
                                                ))
                                            .toList(),
                                        value: budgetValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            budgetValue = newValue;
                                            budget = budgets.firstWhere(
                                                (element) =>
                                                    element.idBudget ==
                                                    newValue);
                                            debugPrint(
                                                "Budget sélectionnée ${budget.toString()}");
                                          });
                                        },
                                      ),
                                    );
                                  }
                                  return DropdownButton(
                                      hint: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          "Choisir un budget",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      items: const [],
                                      onChanged: (value) {});
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
                                      color: d_red,
                                    ),
                                  ))),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                                future: _bureau,
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
                                              "Sélectionner un bureau",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          items: const [],
                                          onChanged: (value) {}),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    List<Bureau> bureaux = snapshot.data!;

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
                                        items: bureaux
                                            .map((e) => DropdownMenuItem(
                                                  value: e.idBureau,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(e.adresse),
                                                  ),
                                                ))
                                            .toList(),
                                        value: bureauValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            bureauValue = newValue;
                                            bureau = bureaux.firstWhere(
                                                (element) =>
                                                    element.idBureau ==
                                                    newValue);
                                            debugPrint(
                                                "Bureau sélectionnée ${budget.toString()}");
                                          });
                                        },
                                      ),
                                    );
                                  }
                                  return DropdownButton(
                                      hint: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          "Choisir un bureau",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      items: const [],
                                      onChanged: (value) {});
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
                                      color: d_red,
                                    ),
                                  ))),
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
                                              "Sélectionner une catégorie",
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
                                        value: catValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            catValue = newValue;
                                            sousCategorie = sousCategories
                                                .firstWhere((element) =>
                                                    element.idSousCategorie ==
                                                    newValue);
                                            debugPrint(
                                                "Sous categorie sélectionnée ${budget.toString()}");
                                          });
                                        },
                                      ),
                                    );
                                  }
                                  return DropdownButton(
                                      hint: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          "Choisir une catégorie",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      items: const [],
                                      onChanged: (value) {});
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
                            child: OutlinedButton(
                              onPressed: () {
                                _showImageSourceDialog();
                              },
                              child: const Text(
                                'Ajouter une piéce',
                                style: TextStyle(
                                    color: d_red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Fichier choisi : ${photo.toString()}",
                        style: const TextStyle(color: d_red),
                        overflow: TextOverflow.ellipsis,
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
                                  int? mt = int.tryParse(montant);
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

                                  if (montants >=
                                      parametreDepense.montantSeuil) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('Alert')),
                                          content: const Text(
                                              "Pour les dépenses dont le montant est supérieur ou égale au montant seuil une demande doit être envoyée"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                               
                                              },
                                              child: const Text('OK'),
                                            )
                                          ],
                                        );
                                      },
                                    );

                                    try {
                                      if (photo != null) {
                                        await DepenseService().addDepenseByUser(
                                          description: description,
                                          montantDepense: montants.toString(),
                                          dateDepense: date,
                                          utilisateur: utilisateur,
                                          image: photo as File,
                                          sousCategorie: sousCategorie,
                                          bureau: bureau,
                                          budget: budget,
                                          parametreDepense: parametreDepense,
                                        );
                                      } else {
                                        await DepenseService().addDepenseByUser(
                                          description: description,
                                          montantDepense: montants.toString(),
                                          dateDepense: date,
                                          utilisateur: utilisateur,
                                          sousCategorie: sousCategorie,
                                          bureau: bureau,
                                          budget: budget,
                                          parametreDepense: parametreDepense,
                                        );
                                      }

                                      descriptionController.clear();
                                      montant_control.clear();
                                      dateController.clear();
                                      setState(() {
                                        bureauValue = null;
                                        budgetValue = null;
                                        catValue = null;
                                        photo = null;
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Center(
                                                child: Text('Succès')),
                                            content: const Text(
                                                "Demande envoyé avec succèss"),
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
                                    } catch (e) {
                                      final String errorMessage = e.toString();
                                      print(errorMessage);
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       title: const Center(
                                      //           child: Text('Erreur')),
                                      //       content: Text(
                                      //           'Budget epuisé ou montant inférieur'),
                                      //       actions: <Widget>[
                                      //         TextButton(
                                      //           onPressed: () {
                                      //             Navigator.of(context).pop();
                                      //           },
                                      //           child: const Text('OK'),
                                      //         ),
                                      //       ],
                                      //     );
                                      //   },
                                      // );
                                    }
                                  } else {
                                    
                                    try {
                                      EasyLoading.show(
                                          status: 'Envoie en cours');
                                      // Vérification si une photo est fournie
                                      if (photo != null) {
                                        await DepenseService().addDepenseByUser(
                                          description: description,
                                          montantDepense: montants.toString(),
                                          dateDepense: date,
                                          utilisateur: utilisateur,
                                          image: photo as File,
                                          sousCategorie: sousCategorie,
                                          bureau: bureau,
                                          budget: budget,
                                          parametreDepense: parametreDepense,
                                        );
                                      } else {
                                        // Si aucune photo n'est fournie
                                        await DepenseService().addDepenseByUser(
                                          description: description,
                                          montantDepense: montants.toString(),
                                          dateDepense: date,
                                          utilisateur: utilisateur,
                                          sousCategorie: sousCategorie,
                                          bureau: bureau,
                                          budget: budget,
                                          parametreDepense: parametreDepense,
                                        );
                                      }
                                      Navigator.of(context).pop(context);
                                      // Afficher une boîte de dialogue indiquant le succès de l'opération
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return AlertDialog(
                                      //         title: const Center(
                                      //             child: Text('Succès')),
                                      //         content: const Text(
                                      //             "Dépense ajoutée avec succès"),
                                      //         actions: <Widget>[
                                      //           TextButton(
                                      //             onPressed: () {
                                      //               Navigator.of(context)
                                      //                   .pop(context);
                                      //             },
                                      //             child: const Text('OK'),
                                      //           )
                                      //         ],
                                      //       );
                                      //     });

                                      // Effacement des champs de saisie et réinitialisation des états
                                      descriptionController.clear();
                                      montant_control.clear();
                                      dateController.clear();
                                      setState(() {
                                        bureauValue = null;
                                        budgetValue = null;
                                        catValue = null;
                                        photo = null;
                                      });

                                      // Application des changements
                                      Provider.of<DepenseService>(context,
                                              listen: false)
                                          .applyChange();
                                    } catch (e) {
                                      final String errorMessage = e.toString();
                                      print(errorMessage);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Center(
                                                child: Text('Erreur')),
                                            content: Text(
                                                'Budget epuisé ou montant inférieur'),
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
