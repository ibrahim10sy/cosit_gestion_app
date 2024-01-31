import 'dart:convert';
import 'dart:io';
 
import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/model/SousCategorie.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/service/BureauService.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:cosit_gestion/service/SousCategorieService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:provider/provider.dart';

class AddDepense extends StatefulWidget {
  const AddDepense({super.key});

  @override
  State<AddDepense> createState() => _AddDepenseState();
}

const d_red = Colors.red;

class _AddDepenseState extends State<AddDepense> {
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController montant_control = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Admin admin;
  late SousCategorie sousCategorie;
  late Bureau bureau;
  late Budget budget;
  late Future<List<SousCategorie>> _categorie;
  late Future<List<Bureau>> _bureau;
  late Future<List<Budget>> _budgets;
  int? catValue;
  int? bureauValue;
  int? budgetValue;
  String? imageSrc;
  File? photo;
  int? adminID;

  @override
  void initState() {
    super.initState();
    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
    adminID = admin.idAdmin;
    _bureau = getBureau();
    _budgets = fetchBudgets(adminID!);
    _categorie = getCategorie();
  }

  Future<List<Bureau>> getBureau() async {
    return BureauService().fetchBureau();
  }

  Future<List<SousCategorie>> getCategorie() async {
    return SousCategorieService().fetchAllSousCategorie();
  }

  Future<List<Budget>> fetchBudgets(int id) async {
    final response = await http
        .get(Uri.parse('https://depenses-cosit.com/Budget/listeByAdmin/$id'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      List<Budget> budgets = data.map((item) => Budget.fromJson(item)).toList();
      return budgets;
    } else {
      throw Exception('Aucun budget trouvé  ${response.statusCode}');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/share.png',
                              width: 23,
                            ),
                            Expanded(
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
                                              "Choisir un budget",
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
                                            .where((element) =>
                                                element.utilisateur == null)
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
                                              "Choisir un bureau",
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Fichier choisi :${photo.toString()}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: d_red),
                        ),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            CircularProgressIndicator(
                                              color: d_red,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Envoi en cours..."),
                                          ],
                                        ),
                                      ),
                                    );
                                    if (photo != null) {
                                      await DepenseService().addDepenseByAdmin(
                                          description: description,
                                          montantDepense: montants.toString(),
                                          dateDepense: date,
                                          admin: admin,
                                          sousCategorie: sousCategorie,
                                          bureau: bureau,
                                          budget: budget,
                                          image: photo as File);
                                    } else {
                                      await DepenseService().addDepenseByAdmin(
                                          description: description,
                                          montantDepense: montants.toString(),
                                          dateDepense: date,
                                          admin: admin,
                                          sousCategorie: sousCategorie,
                                          bureau: bureau,
                                          budget: budget);
                                    }
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    // Afficher le message de succès
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Dépense ajouté avec succès"),
                                      ),
                                    );
                                    Provider.of<DepenseService>(context,
                                            listen: false)
                                        .applyChange();
                                    descriptionController.clear();
                                    montant_control.clear();
                                    dateController.clear();
                                    // Réinitialiser les valeurs des variables de sélection
                                    setState(() {
                                      bureauValue = null;
                                      budgetValue = null;
                                      catValue = null;
                                    });
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
