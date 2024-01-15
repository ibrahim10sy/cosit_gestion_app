import 'package:cosit_gestion/Page_admin/AjoutSalaire.dart';
import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/SalaireDetail.dart';
import 'package:cosit_gestion/Page_admin/UpdateSalaire.dart';
import 'package:cosit_gestion/model/Salaire.dart';
import 'package:cosit_gestion/service/SalaireService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalairePage extends StatefulWidget {
  const SalairePage({super.key});

  @override
  State<SalairePage> createState() => _SalairePageState();
}

const d_red = Colors.red;

class _SalairePageState extends State<SalairePage> {
  late List<Salaire> salaireListe = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Salaires",
              subTitle: "Dépense total des salaires :",
              imagePath: "assets/images/piece.png",
              children: Column(
                children: [
                  Consumer<SalaireService>(
                      builder: (context, salaireService, child) {
                    return FutureBuilder(
                        future: salaireService.getSalireTotal(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text("${snapshot.data?["Total"]} FCFA",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold));
                          } else {
                            return CupertinoActivityIndicator(
                                radius: 20.0, color: d_red);
                            //const CircularProgressIndicator();
                          }
                        });
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      // padding: const EdgeInsets.only(top: 190, left: 20),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AjoutSalaire()));
                        },
                        child: const Text(
                          "+ Ajouter un salaire",
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                // 10% padding on each side
                vertical: 15,
              ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Text("Liste des salaires",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const Divider(
                      height: 1,
                      color: d_red,
                    ),
                    Consumer<SalaireService>(
                      builder: (context, salaireService, child) {
                        return FutureBuilder(
                            future: salaireService.fetchSalaire(),
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
                                  child: Text("Aucun salaire trouvé"),
                                );
                              } else {
                                salaireListe = snapshot.data!;
                                return Column(
                                    children: salaireListe
                                        .map((Salaire salaire) => Column(
                                              children: [
                                                ListTile(
                                                  leading: Image.asset(
                                                      "assets/images/budget.png",
                                                      width: 33,
                                                      height: 33),
                                                  title: Text(
                                                    ("Paiement de Mr ${salaire.utilisateur.nom.toUpperCase()} ${salaire.utilisateur.prenom.toUpperCase()}"),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "Date de paiement ${salaire.date}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 15,
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
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .remove_red_eye_outlined),
                                                            title: const Text(
                                                              "Apercu",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          SalaireDetail(
                                                                              salaires: salaire)));
                                                            }),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                            Icons
                                                                .edit_calendar_sharp,
                                                            color: Colors.green,
                                                          ),
                                                          title: const Text(
                                                            "Modifier",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        UpdateSalaire(
                                                                            salaires:
                                                                                salaire)));
                                                          },
                                                        ),
                                                      ),
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
                                                                        SalaireService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteSalaire(
                                                                    salaire
                                                                        .idSalaire!)
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
                                                                                    "Impossible de supprimer le salaire ",
                                                                                  ),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: const Text('OK'))
                                                                                  ],
                                                                                );
                                                                              })
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(),
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
}
