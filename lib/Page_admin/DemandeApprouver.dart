import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DepenseDetail.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemandeApprouve extends StatefulWidget {
  const DemandeApprouve({super.key});

  @override
  State<DemandeApprouve> createState() => _DemandeApprouveState();
}

const d_red = Colors.red;

class _DemandeApprouveState extends State<DemandeApprouve> {
  late List<Depense> listDemande = [];
  late Future<List<Depense>> futureDemande;

  // Future<List<Demande>> getListDemande() async {
  //   final response = await DemandeService().getDemande();
  //   return response;
  // }

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
            const CustomCard(
              title: "Demande approuvé",
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
                                      "Demandes approuver:",
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
                                            element.autorisationAdmin == true &&
                                            element.utilisateur != null)
                                        .isEmpty
                                    ? Center(
                                        child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            "Aucune demande approuvé  trouvé"),
                                      )
                                    : Column(
                                        children: listDemande
                                            .where((element) =>
                                                element.autorisationAdmin ==
                                                    true &&
                                                element.utilisateur != null)
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
}
