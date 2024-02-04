import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DetailNotifAdmin.dart';
import 'package:cosit_gestion/model/SendNotification.dart';
import 'package:cosit_gestion/service/SendNotifService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

const d_red = Colors.red;

class _EmailPageState extends State<EmailPage> {
  late List<SendNotification> listeNotif = [];
  late Future<List<SendNotification>> futureNotifications;

  Future<List<SendNotification>> getNotif() async {
    final response = await SendNotifService().getNotification();
    return response;
  }

  @override
  void initState() {
    super.initState();
    futureNotifications = getNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomCard(
                title: "Notifications",
                imagePath: "assets/images/notif.png",
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
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                //flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset("assets/images/notif.png",
                                        width: 39, height: 39),
                                    const Expanded(
                                      //flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          "Les notifications :",
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
                                      futureNotifications =
                                          SendNotifService().getNotification();
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
                        Consumer<SendNotifService>(
                          builder: (context, sendService, child) {
                            return FutureBuilder(
                                future: futureNotifications,
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
                                      child: Text("Aucune notification trouvé"),
                                    );
                                  } else {
                                    listeNotif = snapshot.data!;
                                    return Column(
                                      children: listeNotif
                                          .map(
                                              (SendNotification send) =>
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailNotifAdmin(
                                                                    notification:
                                                                        send,
                                                                  )));
                                                    },
                                                    leading: Image.asset(
                                                        "assets/images/notif.png",
                                                        width: 33,
                                                        height: 33),
                                                    title: const Text(
                                                      "Alerte demande",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    subtitle: Text(
                                                      "Expediteur :${send.utilisateur.prenom} ${send.utilisateur.nom}-${send.date}",
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
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
                                                              await SendNotifService()
                                                                  .deleteNotif(send
                                                                      .idNotification!)
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            Provider.of<SendNotifService>(context, listen: false).applyChange(),
                                                                            setState(() {
                                                                              futureNotifications = SendNotifService().getNotification();
                                                                            }),
                                                                            Navigator.of(context).pop(),
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
                  ))
            ],
          ),
        ));
  }
}
