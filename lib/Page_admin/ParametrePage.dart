import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/ParametreDepense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({super.key});

  @override
  State<ParametrePage> createState() => _ParametrePageState();
}

const d_red = Colors.red;

class _ParametrePageState extends State<ParametrePage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController libelleController = TextEditingController();
  TextEditingController montantController = TextEditingController();
  late Future<List<ParametreDepense>> listFuture;
  late List<ParametreDepense> parametreListe = [];

  @override
  void initState() {
    super.initState();
    listFuture = getData();
  }

  Future<List<ParametreDepense>> getData() async {
    final response = await DepenseService().fetchParametre();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Page parametrage",
              imagePath: "assets/images/depense.png",
              children: Column(
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        openDialog();
                      },
                      child: const Text(
                        "Parametrer un montant",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
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
                                Icon(
                                  Icons.settings,
                                  color: d_red,
                                ),
                                const Expanded(
                                  //flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Parametre dépense ",
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
                    Consumer<DepenseService>(
                      builder: (context, depenseService, child) {
                        return FutureBuilder(
                            future: listFuture,
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
                                  child: Text("Aucun parametre trouvé"),
                                );
                              } else {
                                parametreListe = snapshot.data!;
                                return Column(
                                  children: parametreListe
                                      .map((e) => ListTile(
                                            leading: Icon(
                                              Icons.settings,
                                              color: d_red,
                                            ),
                                            title: Text(
                                              e.description,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            subtitle: Text(
                                              e.montantSeuil.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context) =>
                                                  <PopupMenuEntry<String>>[
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
                                                              FontWeight.bold),
                                                    ),
                                                    onTap: () async {
                                                      await Provider.of<
                                                                  DepenseService>(
                                                              context,
                                                              listen: false)
                                                          .deleteparametre(
                                                              e.idParametre!)
                                                          .then((value) => {
                                                                Provider.of<DepenseService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                setState(() {
                                                                  listFuture =
                                                                      DepenseService()
                                                                          .fetchParametre();
                                                                }),
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
                  Icon(Icons.settings, color: d_red),
                  const SizedBox(width: 10),
                  const Text(
                    "Ajouter un parametre",
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
                      controller: libelleController,
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
                      controller: montantController,
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
                        ElevatedButton.icon(
                          onPressed: () async {
                            final String desc = libelleController.text;
                            final String montant = montantController.text;
                            if (formkey.currentState!.validate()) {
                              try {
                                await DepenseService()
                                    .AddParametres(
                                        description: desc,
                                        montantSeuil: montant)
                                    .then((value) => {
                                          Provider.of<DepenseService>(context,
                                                  listen: false)
                                              .applyChange(),
                                          libelleController.clear(),
                                          montantController.clear(),
                                          setState(() {
                                            listFuture = DepenseService()
                                                .fetchParametre();
                                          }),
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
