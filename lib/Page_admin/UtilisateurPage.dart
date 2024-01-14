import 'package:cosit_gestion/Page_admin/AjoutUtilisateur.dart';
import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/UpdaterUtilisateur.dart';
import 'package:cosit_gestion/Page_admin/UtilisateurDetail.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/service/UtilisateurService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UtilisateurPage extends StatefulWidget {
  const UtilisateurPage({super.key});

  @override
  State<UtilisateurPage> createState() => _UtilisateurPageState();
}

const d_red = Colors.red;

class _UtilisateurPageState extends State<UtilisateurPage> {
  late List<Utilisateur> utilisateurListe = [];
  late Future<List<Utilisateur>> _futureListe;
  var utilisateurService = UtilisateurService();

  Future<List<Utilisateur>> getUser() async {
    return utilisateurService.fetchData();
  }

  @override
  void initState() {
    _futureListe = getUser();
    debugPrint(_futureListe.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCard(
                title: "Employeés",
                imagePath: "assets/images/employe.png",
                children: Column(children: [
                  const SizedBox(
                    height: 65,
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
                                  builder: (context) =>
                                      const AjoutUtilisateur()));
                        },
                        child: const Text(
                          "+ Ajouter un employée",
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        padding: EdgeInsets.all(8.0),
                        child: Text("Liste des employées",
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
                      Consumer<UtilisateurService>(
                          builder: (context, utilisateurServices, child) {
                        return FutureBuilder(
                            future: utilisateurServices.fetchData(),
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
                                  child: Text("Aucun employé trouvé"),
                                );
                              } else {
                                utilisateurListe = snapshot.data!;
                                return utilisateurListe.isEmpty
                                    ? Center(
                                        child: Text("Aucun employé trouvé"),
                                      )
                                    : Column(
                                        children: utilisateurListe
                                            .map((Utilisateur user) => Column(
                                                  children: [
                                                    ListTile(
                                                      splashColor: Colors.white,
                                                      leading: user.image ==
                                                                  null || 
                                                              user.image
                                                                      ?.isEmpty ==
                                                                  true
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  d_red,
                                                              radius: 30,
                                                              child: Text(
                                                                "${user.prenom.substring(0, 1).toUpperCase()}${user.nom.substring(0, 1).toUpperCase()}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      2,
                                                                ),
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      user.image!),
                                                              radius: 30,
                                                            ),
                                                      title: Text(
                                                        "${user.prenom.toUpperCase()} ${user.nom.toUpperCase()}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        user.role.toUpperCase(),
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      trailing: PopupMenuButton<
                                                          String>(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                                leading: const Icon(
                                                                    Icons
                                                                        .remove_red_eye_outlined),
                                                                title:
                                                                    const Text(
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
                                                                              UtilisateurDetail(utilisateur: user)));
                                                                }),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .edit_calendar_sharp,
                                                                color: Colors
                                                                    .green,
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
                                                                            UpdaterUtilisateur(
                                                                              utilisateurs: user,
                                                                            )));
                                                              },
                                                            ),
                                                          ),
                                                          const PopupMenuDivider(),
                                                          PopupMenuItem<String>(
                                                            // value: localizations
                                                            //     .demoMenuRemove,
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons.delete,
                                                                color: d_red,
                                                              ),
                                                              title: const Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color:
                                                                        d_red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              onTap: () async {
                                                                await Provider.of<
                                                                            UtilisateurService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deleteUser(user
                                                                        .idUtilisateur!)
                                                                    .then(
                                                                        (value) =>
                                                                            {
                                                                              Navigator.of(context).pop()
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
                                                                                        "Impossible de supprimer l'employer car il est déjà associé  à un salaire",
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
                                                    const Divider(), // Ajoute une ligne horizontale entre les ListTiles
                                                  ],
                                                ))
                                            .toList(),
                                      );
                              }
                            });
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
