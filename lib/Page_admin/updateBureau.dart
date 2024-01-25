import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Bureau.dart';
import 'package:cosit_gestion/service/BureauService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateBureau extends StatefulWidget {
  final Bureau bureau;
  const UpdateBureau({super.key, required this.bureau});

  @override
  State<UpdateBureau> createState() => _UpdateBureauState();
}

const d_red = Colors.red;

class _UpdateBureauState extends State<UpdateBureau> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  late Bureau bureaux;

  @override
  void initState() {
    super.initState();
    bureaux = widget.bureau;
    nomController.text = bureaux.nom;
    adresseController.text = bureaux.adresse;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    "Modifier un bureau",
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
                                    .updateBureau(idBureau: bureaux.idBureau!, nom: nom, adresse: adresse)
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
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Modifier",
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
    );
  }
}
