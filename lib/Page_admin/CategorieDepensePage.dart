import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/SousCategorieDepensePage.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/CategorieDepense.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/service/CategorieService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
     
class CategorieDepensePage extends StatefulWidget {
  const CategorieDepensePage({super.key});

  @override
  State<CategorieDepensePage> createState() => _CategorieDepensePageState();
}

const d_red = Colors.red;

class _CategorieDepensePageState extends State<CategorieDepensePage> {
  late List<CategorieDepense> categorie = [];
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  late Admin admin;
  @override
  void initState() {
    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Catégorie",
              imagePath: "assets/images/categorie.png",
              children: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      // padding: const EdgeInsets.only(top: 190, left: 20),
                      child: TextButton(
                        onPressed: () {
                          openDialog();
                        },
                        child: const Text(
                          "+ Ajouter une catégorie",
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              ),
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            //flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("assets/images/categorie.png",
                                    width: 39, height: 39),
                                const Expanded(
                                  //flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Liste des catégories :",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: d_red),
                                      //overflow: TextOverflow.visible,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Expanded(child: rechercheEtTrier())
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: d_red,
                    ),
                    Consumer<CategorieService>(
                      builder: (context, categorieService, child) {
                        return FutureBuilder(
                            future: categorieService
                                .fetchCategorieByAdmin(admin.idAdmin!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(
                                      radius: 20.0, color: d_red),
                                );
                              }
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("Aucune catégorie trouvé"),
                                );
                              } else {
                                categorie = snapshot.data!;
                                return Column(
                                    children: categorie
                                        .map((CategorieDepense categories) =>
                                            Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SousCategoriePage(
                                                                    categorieDepense:
                                                                        categories)));
                                                  },
                                                  splashColor: Colors.white,
                                                  leading: Image.asset(
                                                      "assets/images/categorie.png",
                                                      width: 33,
                                                      height: 33),
                                                  title: Text(
                                                    categories.libelle,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  trailing:
                                                      PopupMenuButton<String>(
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (context) =>
                                                        <PopupMenuEntry<
                                                            String>>[
                                                      const PopupMenuDivider(),
                                                      PopupMenuItem<String>(
                                                        // value: localizations
                                                        //     .demoMenuRemove,
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons.delete,
                                                            color: d_red,
                                                          ),
                                                          title: const Text(
                                                            "Supprimer",
                                                            style: TextStyle(
                                                                color: d_red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          onTap: () async {
                                                            await Provider.of<
                                                                        CategorieService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteCategorie(
                                                                    categories
                                                                        .idCategoriedepense!)
                                                                .then(
                                                                    (value) => {
                                                                          Navigator.of(context)
                                                                              .pop()
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Text("Erreur de suppression"),
                                                                                  content: const Text(
                                                                                    "Ce catégorie est déjà associé à une dépense ",
                                                                                  ),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: const Text('OK'))
                                                                                  ],
                                                                                );
                                                                              }),
                                                                          Navigator.of(context)
                                                                              .pop()
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                        .toList());
                              }
                            });
                      },
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

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/categorie.png",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Ajouter une catégorie",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Libellé',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez remplir les champs";
                          }
                          return null;
                        },
                        controller: libelleController,
                        decoration: InputDecoration(
                          hintText: "Libellé",
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final String libelle = libelleController.text;
                              if (formkey.currentState!.validate()) {
                                try {
                                  await CategorieService()
                                      .addCategorieByAdmin(
                                          libelle: libelle, admin: admin)
                                      .then((value) => {
                                            Provider.of<CategorieService>(
                                                    context,
                                                    listen: false)
                                                .applyChange(),
                                            libelleController.clear(),
                                            Navigator.of(context).pop()
                                          })
                                      .catchError((onError) =>
                                          {print(onError.toString())});
                                } catch (e) {
                                  final String errorMessage = e.toString();
                                  print(errorMessage);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Ajouter",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Ferme la boîte de dialogue
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: d_red,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Annuler",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
