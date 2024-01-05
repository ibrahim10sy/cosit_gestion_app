import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/Page_user/DetailDemande.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/DemandeService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemandeListe extends StatefulWidget {
  const DemandeListe({super.key});

  @override
  State<DemandeListe> createState() => _DemandeListeState();
}

const d_red = Colors.red;

class _DemandeListeState extends State<DemandeListe> {
  late List<Demande> listDemande = [];
  late Future<List<Demande>> futureDemande;
  late Utilisateur utilisateur;

  Future<List<Demande>> getListDemande(int idUtilisateur) async {
    final response = await DemandeService().fetchDemande(idUtilisateur);
    return response;
  }

  @override
  void initState() {
    super.initState();
    utilisateur =
        Provider.of<UtilisateurProvider>(context, listen: false).utilisateur!;
    futureDemande = getListDemande(utilisateur.idUtilisateur!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBars(),
      body: SingleChildScrollView(
        child: Column(children: [
          const CustomCard(
            title: "Demande ",
            imagePath: 'assets/images/demande.png',
            subTitle: "Les demandes approuvés",
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
                                      "Les demandes approuver:",
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
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  futureDemande = DemandeService()
                                      .fetchDemande(utilisateur.idUtilisateur!);
                                });
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: d_red,
                              ))
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: d_red,
                    ),
                    Consumer<DemandeService>(
                      builder: (context, demandeService, child) {
                        return FutureBuilder(
                            future: demandeService
                                .fetchDemande(utilisateur.idUtilisateur!),
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
                                  child: Text("Aucune demande trouvé"),
                                );
                              } else {
                                listDemande = snapshot.data!;
                                print('Consumer: ');
                                return Column(
                                    children: listDemande
                                        .where((element) =>
                                            element.autorisationAdmin == true)
                                        .map((Demande demande) => Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailDemande(
                                                                    demande:
                                                                        demande)));
                                                  },
                                                  leading: Image.asset(
                                                      "assets/images/demande.png",
                                                      width: 33,
                                                      height: 33),
                                                  title: Text(
                                                    demande.motif,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  subtitle:
                                                      Text(demande.dateDemande),
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
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            await DemandeService()
                                                                .deleteDemande(
                                                                    demande
                                                                        .idDemande!)
                                                                .then(
                                                                    (value) => {
                                                                          Provider.of<DemandeService>(context, listen: false)
                                                                              .applyChange(),
                                                                          setState(
                                                                              () {
                                                                            futureDemande =
                                                                                DemandeService().getDemande();
                                                                          })
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
                                                                              Text(onError.toString()),
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                  },
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ))
                                        .toList());
                              }
                            });
                      },
                    )
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
