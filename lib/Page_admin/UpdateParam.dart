import 'package:cosit_gestion/model/ParametreDepense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UpdateParam extends StatefulWidget {
  final ParametreDepense parametreDepense;
  const UpdateParam({super.key, required this.parametreDepense});

  @override
  State<UpdateParam> createState() => _UpdateParamState();
}

const d_red = Colors.red;

class _UpdateParamState extends State<UpdateParam> {
  final formkey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController monController = TextEditingController();
  late ParametreDepense paramDepense;

  @override
  void initState() {
    super.initState();
    paramDepense = widget.parametreDepense;
    descController.text = paramDepense.description;
    monController.text = paramDepense.montantSeuil.toString();
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
              Icon(Icons.settings, color: d_red),
              const SizedBox(width: 10),
              const Text(
                "Modifier un parametre",
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
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    // prefixIcon: const Icon(Icons.describe),
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
                  controller: monController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: "Montant",
                    // prefixIcon: const Icon(Icons.describe),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final String desc = descController.text;
                          final String montant = monController.text;
                          if (formkey.currentState!.validate()) {
                            try {
                              await DepenseService()
                                  .UpdateParametres(
                                      idParametre: paramDepense.idParametre!,
                                      description: desc,
                                      montantSeuil: montant)
                                  .then((value) => {
                                        Provider.of<DepenseService>(context,
                                                listen: false)
                                            .applyChange(),
                                        descController.clear(),
                                        monController.clear(),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text(
                          "Modifier",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Ferme la boîte de dialogue
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: d_red,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text(
                          "Annuler",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
