import 'package:cosit_gestion/Page_admin/AddDepense.dart';
import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DepenseDetail.dart';
import 'package:cosit_gestion/Page_admin/updateDepense.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DepensePage extends StatefulWidget {
  const DepensePage({super.key});

  @override
  State<DepensePage> createState() => _DepensePageState();
}

const d_red = Colors.red;

class _DepensePageState extends State<DepensePage> {
  TextEditingController inputController = TextEditingController();
  late List<Depense>? depenseList = [];
  // bool isView = false;

  List colors = [Colors.green, Colors.yellow];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Dépense page",
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddDepense()));
                      },
                      child: const Text(
                        "+ Ajouter une depense",
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
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            //flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("assets/images/depense.png",
                                    width: 39, height: 39),
                                const Expanded(
                                  //flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Liste des dépenses :",
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
                          Expanded(child: rechercheEtTrier())
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: d_red,
                    ),
                    Consumer<DepenseService>(
                      builder: (context, depenseService, child) {
                        if (depenseService.lastAction !=
                            depenseService.action) {
                          return FutureBuilder(
                              future: depenseService.action == "all"
                                  ? depenseService.fetchDepense()
                                  : depenseService.action == "search"
                                      ? depenseService.searchDepenseByDesc()
                                      : depenseService.sortByMonthAndYear(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(
                                        radius: 20.0, color: d_red),
                                  );
                                }
                                if (snapshot.hasError) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Provider.of<DepenseService>(context,
                                            listen: false)
                                        .lastAction = depenseService.action;
                                    setState(() {});
                                  });
                                  return Center(
                                    child: Text(snapshot.error
                                        .toString()
                                        .replaceAll("Exception", "")),
                                  );
                                }
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Provider.of<DepenseService>(context,
                                          listen: false)
                                      .lastAction = depenseService.action;
                                  setState(() {});
                                });

                                depenseList = snapshot.data!;

                                return Column(
                                  children: depenseList!
                                      .map((Depense depense) => ListTile(
                                            onTap: () async {
                                              try {
                                                await DepenseService()
                                                    .marquerView(
                                                        depense.idDepense!);
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
                                                            depenses: depense)),
                                              );
                                            },
                                            leading: Image.asset(
                                              "assets/images/depense.png",
                                              width: 33,
                                              height: 33,
                                            ),
                                            title: Text(
                                              depense.description,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: depense.viewed
                                                    ? Colors.black
                                                    : const Color.fromARGB(
                                                        255, 139, 138, 138),
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${depense.dateDepense} - montant : ${depense.montantDepense.toString()} FCFA",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context) =>
                                                  <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.edit,
                                                      color: Colors.green,
                                                    ),
                                                    title: const Text(
                                                      "Modifier",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpdateDepense(
                                                                      depense:
                                                                          depense)));
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
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      await DepenseService()
                                                          .deleteDepense(depense
                                                              .idDepense!)
                                                          .then((value) => {
                                                                Provider.of<DepenseService>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .applyChange(),
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
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
                              });
                        } else {
                          Provider.of<DepenseService>(context, listen: false)
                              .lastAction = "";
                          if (depenseService.depensesListe.isNotEmpty) {
                            depenseList = depenseService.depensesListe;
                            return Column(
                              children: depenseList!
                                  .where((element) =>
                                      element.autorisationAdmin == true)
                                  .map((Depense depense) => ListTile(
                                        onTap: () async {
                                          try {
                                            await DepenseService().marquerView(
                                                depense.idDepense!);
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
                                                        depenses: depense)),
                                          );
                                        },
                                        leading: Image.asset(
                                          "assets/images/depense.png",
                                          width: 33,
                                          height: 33,
                                        ),
                                        title: Text(
                                          depense.description,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: depense.viewed
                                                ? Colors.black
                                                : const Color.fromARGB(
                                                    255, 139, 138, 138),
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${depense.dateDepense} - montant : ${depense.montantDepense.toString()} FCFA",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: PopupMenuButton<String>(
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context) =>
                                              <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                              child: ListTile(
                                                leading: const Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                                title: const Text(
                                                  "Modifier",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateDepense(
                                                                  depense:
                                                                      depense)));
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  await DepenseService()
                                                      .deleteDepense(
                                                          depense.idDepense!)
                                                      .then((value) => {
                                                            Provider.of<DepenseService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .applyChange(),
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                          })
                                                      .catchError((onError) => {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      "Erreur de suppression"),
                                                                  content:
                                                                      const Text(
                                                                    "Impossible de supprimer le depense ",
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'OK'),
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
                          } else {
                            return const Center(
                              child: Text("Aucune depense trouvé"),
                            );
                          }
                        }
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

  rechercheEtTrier() {
    final formkey = GlobalKey<FormState>();
    String description = "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              Provider.of<DepenseService>(context, listen: false).action =
                  "all";
              Provider.of<DepenseService>(context, listen: false).applyChange();
            },
            icon: const Icon(Icons.restart_alt, color: d_red)),
        IconButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32.0),
                                  topRight: Radius.circular(32.0)),
                              color: d_red),
                          child: Row(
                            children: [
                              Image.asset("assets/images/budget.png",
                                  width: 53, height: 53),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Rechercher une dépense",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            margin: const EdgeInsets.only(top: 15, bottom: 15),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(bottom: 15.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 8.0,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25))
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Form(
                                        key: formkey,
                                        child: Expanded(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Veuillez saisir une description";
                                              }
                                              description = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: IconButton(
                                          onPressed: () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              Provider.of<DepenseService>(
                                                      context,
                                                      listen: false)
                                                  .applySearch(description);
                                              Navigator.pop(context);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.search_sharp,
                                            color: d_red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Fermer",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: d_red),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  )),
          icon: const Icon(
            Icons.search,
            color: d_red,
          ),
        ),
        IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, right: 15),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    topRight: Radius.circular(32.0)),
                                color: d_red),
                            child: Row(
                              children: [
                                Image.asset("assets/images/depense.png",
                                    width: 53, height: 53),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Trier les  depenses",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            margin: const EdgeInsets.only(top: 15, bottom: 15),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.only(bottom: 15.0),
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: TextField(
                                      controller: inputController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Sélectionner la date',

                                        prefixIcon: const Icon(
                                          Icons.date_range,
                                          color: d_red,
                                          size: 30.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        contentPadding: const EdgeInsets
                                            .symmetric(
                                            vertical: 10,
                                            horizontal:
                                                15), // Adjust the padding as needed
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2100));
                                        if (pickedDate != null) {
                                          print(pickedDate);
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          print(formattedDate);
                                          setState(() {
                                            inputController.text =
                                                formattedDate;
                                          });
                                        } else {}
                                      },
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Provider.of<DepenseService>(context,
                                                listen: false)
                                            .applyTrie(inputController.text);
                                        inputController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Trie",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Fermer",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: d_red),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
            icon: const Icon(
              Icons.sort_sharp,
              color: d_red,
            ))
      ],
    );
  }
}
