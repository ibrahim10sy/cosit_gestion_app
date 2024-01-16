import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DemandeApprouver.dart';
import 'package:cosit_gestion/Page_admin/DepenseDetail.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DemandePage extends StatefulWidget {
  const DemandePage({super.key});

  @override
  State<DemandePage> createState() => _DemandePageState();
}

const d_red = Colors.red;

class _DemandePageState extends State<DemandePage> {
  late List<Depense> listDemande = [];
  late Future<List<Depense>> futureDemande;

  @override
  void initState() {
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
              title: "Demande",
              imagePath: "assets/images/demande.png",
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
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DemandeApprouve()));
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Voir demande approuvé",
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
                                Image.asset("assets/images/demande.png",
                                    width: 39, height: 39),
                                const Expanded(
                                  //flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Demandes non approuver:",
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
                          // IconButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         futureDemande = DemandeService().getDemande();
                          //       });
                          //     },
                          //     icon: const Icon(
                          //       Icons.refresh,
                          //       color: d_red,
                          //     ))
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
                            future: depenseService.fetchDepense(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(
                                      radius: 20.0, color: d_red),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error
                                      .toString()
                                      .replaceAll("Exception", "")),
                                );
                              }
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("Aucune demande trouvé"),
                                );
                              } else {
                                listDemande = snapshot.data!;

                                return listDemande
                                        .where((element) =>
                                            element.autorisationAdmin == false)
                                        .isEmpty
                                    ? Center(
                                        child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            "Aucune demande trouvé"),
                                      )
                                    : Column(
                                        children: listDemande
                                            .where((element) =>
                                                element.autorisationAdmin ==
                                                false)
                                            .map((Depense depense) => ListTile(
                                                  onTap: () async {
                                                    try {
                                                      await DepenseService()
                                                          .marquerView(depense
                                                              .idDepense!);
                                                      print(depense.idDepense);
                                                    } catch (error) {
                                                      print(error.toString());
                                                    }
                                                    setState(() {
                                                      depense.viewed = true;
                                                    });
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DepenseDetail(
                                                                  depenses:
                                                                      depense)),
                                                    );
                                                  },
                                                  leading: Image.asset(
                                                    "assets/images/depense.png",
                                                    width: 33,
                                                    height: 33,
                                                  ),
                                                  title: Text(
                                                    depense.description,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: depense.viewed
                                                          ? Colors.black
                                                          : const Color
                                                              .fromARGB(255,
                                                              139, 138, 138),
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "${depense.dateDepense} - montant : ${depense.montantDepense.toString()}",
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
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                          title: const Text(
                                                            "Valider",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            if (depense.montantDepense >
                                                                    depense
                                                                        .budget
                                                                        .montantRestant ||
                                                                depense.budget
                                                                        .montantRestant ==
                                                                    0) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Center(
                                                                        child: Text(
                                                                            'Erreur')),
                                                                    content:
                                                                        const Text(
                                                                            "Le montant du budget est epuisé ou montant inférieur"),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'OK'),
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              final snack =
                                                                  SnackBar(
                                                                backgroundColor:
                                                                    d_red,
                                                                content: Text(
                                                                    "Démande validé",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snack);
                                                               try {
                                                                await DepenseService()
                                                                    .approuverDepense(
                                                                        depense
                                                                            .idDepense!);
                                                                print(depense
                                                                    .idDepense);
                                                              } catch (error) {
                                                                print(error
                                                                    .toString());
                                                              }
                                                              setState(() {
                                                                depense.autorisationAdmin = true;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
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
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await DepenseService()
                                                                .deleteDepense(
                                                                    depense
                                                                        .idDepense!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<DepenseService>(context, listen: false)
                                                                              .applyChange(),
                                                                          Navigator.of(context)
                                                                              .pop(),
                                                                        })
                                                                .catchError(
                                                                    (onError) =>
                                                                        {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                title: const Text("Erreur de suppression"),
                                                                                content: const Text(
                                                                                  "Impossible de supprimer le depense ",
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: const Text('OK'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ),
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
            ),
          ],
        ),
      ),
    );
  }

  void openDialog() {}
}
