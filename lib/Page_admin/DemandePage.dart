import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DemandeApprouver.dart';
import 'package:cosit_gestion/Page_admin/DetailDemande.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/service/DemandeService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemandePage extends StatefulWidget {
  const DemandePage({super.key});

  @override
  State<DemandePage> createState() => _DemandePageState();
}

const d_red = Colors.red;

class _DemandePageState extends State<DemandePage> {
  late List<Demande> listDemande = [];
  late Future<List<Demande>> futureDemande;

  Future<List<Demande>> getListDemande() async {
    final response = await DemandeService().getDemande();
    return response;
  }

  @override
  void initState() {
    super.initState();
    futureDemande = getListDemande();
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
                width: 350,
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
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  futureDemande = DemandeService().getDemande();
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
                            future: futureDemande,
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
                                return Column(
                                  children: listDemande
                                      .where((element) =>
                                          element.autorisationAdmin == false)
                                      .map((Demande demande) => Column(
                                            children: [
                                              ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailDemandeAdmin(
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
                                                  trailing: Checkbox(
                                                    value: demande
                                                            .autorisationAdmin ??
                                                        false,
                                                    onChanged:
                                                        (newValue) async {
                                                      final snackBar = SnackBar(
                                                        content: const Text(
                                                          'Validation en cours ...',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        //  width: 10 0,

                                                        backgroundColor:
                                                            d_red, // Couleur de fond du SnackBar
                                                        elevation:
                                                            5, // Élévation du SnackBar
                                                        // shape:
                                                        //     RoundedRectangleBorder(
                                                        //   borderRadius:
                                                        //       BorderRadius.circular(
                                                        //           10), // Contour arrondi
                                                        // ),
                                                        duration:
                                                            const Duration(
                                                                seconds: 16),
                                                        action: SnackBarAction(
                                                          label: 'Validation',
                                                          textColor:
                                                              Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);

                                                      try {
                                                        await DemandeService()
                                                            .approuveAdmin(
                                                              idDemande: demande
                                                                  .idDemande!,
                                                              admin:
                                                                  demande.admin,
                                                              utilisateur: demande
                                                                  .utilisateur,
                                                            )
                                                            .then((value) => {
                                                                  Provider.of<DemandeService>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .applyChange(),
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: const Center(
                                                                            child:
                                                                                Text('Succès')),
                                                                        content:
                                                                            const Text("Demande approuvé avec succès"),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('OK'),
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                })
                                                            .catchError(
                                                                (onError) => {
                                                                      print(
                                                                          "Erreur survenue $onError")
                                                                    });
                                                      } catch (e) {
                                                        print(
                                                            "Erreur survenue $e");
                                                      }
                                                    },
                                                    activeColor: d_red,
                                                  )),
                                              const Divider(),
                                            ],
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

//  IconButton(
//     onPressed: () async {
//       await DemandeService()
//           .deleteDemande(demande
//               .idDemande!)
//           .then((value) => {
//                 Provider.of<DemandeService>(
//                         context,
//                         listen:
//                             false)
//                     .applyChange(),
//                 setState(() {
//                   futureDemande =
//                       DemandeService()
//                           .getDemande();
//                 })
//               })
//           .catchError(
//               (onError) => {
//                     print(
//                         onError)
//                   });
//     },
//     icon: const Icon(
//       Icons.delete,
//       color: d_red,
//     )),
