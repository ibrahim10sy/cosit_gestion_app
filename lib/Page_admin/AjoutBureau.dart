import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/updateBureau.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/service/BureauService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjoutBureau extends StatefulWidget {
  const AjoutBureau({super.key});

  @override
  State<AjoutBureau> createState() => _AjoutBureauState();
} 

const d_red = Colors.red;

class _AjoutBureauState extends State<AjoutBureau> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  late List<Bureau> bureauList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Bureaux",
              imagePath: "assets/images/house.png",
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
                          "+ Ajouter un bureau",
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
                                Image.asset("assets/images/house.png",
                                    width: 39, height: 39),
                                const Expanded(
                                  //flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Liste des bureaux",
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
                    Consumer<BureauService>(
                      builder: (context, bureauService, child) {
                        return FutureBuilder(
                            future: bureauService.fetchBureau(),
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
                                  child: Text("Aucun bureau trouvé"),
                                );
                              } else {
                                bureauList = snapshot.data!;
                                return Column(
                                  children: bureauList
                                      .map((Bureau bur) => ListTile(
                                            leading: Image.asset(
                                                "assets/images/house.png",
                                                width: 33,
                                                height: 33),
                                            title: Text(
                                              bur.nom,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            subtitle: Text(
                                              bur.adresse,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context) =>
                                                  <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.edit,
                                                      color: Colors.green,
                                                    ),
                                                    title: const Text(
                                                      "Modifier",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onTap: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  content: UpdateBureau(bureau: bur)));
                                                      Navigator.of(context)
                                                          .pop();

                                                      // Navigator.of(context)
                                                      //     .pop();
                                                    },
                                                  ),
                                                ),
                                                const PopupMenuDivider(),
                                                PopupMenuItem<String>(
                                                  
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
                                                              FontWeight.bold),
                                                    ),
                                                    onTap: () async {
                                                      
                                                      await Provider.of<
                                                                  BureauService>(
                                                              context,
                                                              listen: false)
                                                          .deleteBureau(
                                                              bur.idBureau!)
                                                          .then((value) => {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop()
                                                              })
                                                          .catchError(
                                                              (onError) => {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text("Erreur de suppression"),
                                                                            content:
                                                                                const Text(
                                                                              "Impossible de supprimer le bureau ",
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop()
                                                                  });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                );
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
                    "assets/images/house.png",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Ajouter un bureau",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir les champs";
                        }
                        return null;
                      },
                      controller: nomController,
                      decoration: InputDecoration(
                        hintText: "Nom",
                        prefixIcon: const Icon(Icons.house),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir les champs";
                        }
                        return null;
                      },
                      controller: adresseController,
                      decoration: InputDecoration(
                        hintText: "Adresse",
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final String nom = nomController.text;
                            final String adresse = adresseController.text;
                            if (formkey.currentState!.validate()) {
                              try {
                                await BureauService()
                                    .addBureau(nom: nom, adresse: adresse)
                                    .then((value) => {
                                          Provider.of<BureauService>(context,
                                                  listen: false)
                                              .applyChange(),
                                          nomController.clear(),
                                          adresseController.clear(),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Ajouter",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Ferme la boîte de dialogue
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: d_red,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Annuler",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
