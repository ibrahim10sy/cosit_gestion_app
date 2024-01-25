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

class updateCategorie extends StatefulWidget {
  final CategorieDepense categorieDepense;
  const updateCategorie({super.key, required this.categorieDepense});

  @override
  State<updateCategorie> createState() => _updateCategorieState();
}
const d_red = Colors.red;
class _updateCategorieState extends State<updateCategorie> {
   final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  late CategorieDepense cat;
  
  @override
  void initState() {
    super.initState();
    cat = widget.categorieDepense;
    libelleController.text = cat.libelle;
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
                "assets/images/categorie.png",
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                "Modifier catégorie",
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
                                  .updateCategorie(
                                    idCategoriedepense:cat.idCategoriedepense ,
                                      libelle: libelle)
                                  .then((value) => {
                                        Provider.of<CategorieService>(context,
                                                listen: false)
                                            .applyChange(),
                                        libelleController.clear(),
                                        Navigator.of(context).pop()
                                      })
                                  .catchError(
                                      (onError) => {print(onError.toString())});
                            } catch (e) {
                              final String errorMessage = e.toString();
                              print(errorMessage);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Modifier",
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
    );
  }
}
