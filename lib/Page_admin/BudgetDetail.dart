import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DepenseDetail.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetDetail extends StatefulWidget {
  final Budget budget;
  const BudgetDetail({super.key, required this.budget});

  @override
  State<BudgetDetail> createState() => _BudgetDetailState();
}

const d_red = Colors.red;

class _BudgetDetailState extends State<BudgetDetail> {
  TextEditingController inputController = TextEditingController();
  late Future<List<Depense>> _depenseListe;
  late Future<Map<String, dynamic>> montantDepense;
  late List<Depense> depenseList = [];
  late Budget budgets;
  int? budgetID;
  int? restant;

  Future<List<Depense>> getDepenseByBudget() async {
    final response =
        await DepenseService().fetchDepensesByBudget(budgets.idBudget!);

    return response;
  }

  Future<Map<String, dynamic>> getMontant() async {
    final response =
        await DepenseService().getSommeDepenseTotalByBudget(budgetID!);
    return response;
  }

  @override
  void initState() {
    super.initState();
    budgets = widget.budget;
    budgetID = budgets.idBudget;
    budgets.printInfo();
    setState(() {
      restant = budgets.montantRestant;
      _depenseListe = getDepenseByBudget();
    });
    montantDepense = getMontant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          CustomCard(
              subTitle: "${budgets.montant} FCFA,",
              title: "Montant du budget",
              imagePath: "assets/images/budget.png",
              children: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align to the start (left)
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Montant restant :",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${budgets.montantRestant} FCFA    ",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: DepenseService()
                              .getSommeDepenseTotalByBudget(budgets.idBudget!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              debugPrint("Boucle 1");
                              return Column(
                                children: [
                                  const Text(
                                    "Total dépensé",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("${snapshot.data?["Total"]} FCFA",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold))
                                ],
                              );
                            } else {
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  radius: 20.0,
                                  color: d_red,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            openDialog();
                          },
                          icon: const Icon(
                            Icons.info_outlined,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ],
              )),
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
              child: ListView(children: [
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
                FutureBuilder(
                    future: _depenseListe,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                              radius: 20.0, color: d_red),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text("Aucune dépense trouvé pour ce budget"),
                          ),
                        );
                      } else {
                        debugPrint("Boucle 2");

                        depenseList = snapshot.data!;
                        return Column(
                          children: depenseList
                              .map((Depense depense) => ListTile(
                                    onTap: () async {
                                      try {
                                        await DepenseService()
                                            .marquerView(depense.idDepense!);
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
                                            builder: (context) => DepenseDetail(
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
                                      depense.dateDepense,
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
                                                                listen: false)
                                                            .applyChange(),
                                                        setState(() {
                                                          _depenseListe =
                                                              DepenseService()
                                                                  .fetchDepensesByBudget(
                                                                      budgetID!);
                                                        }),
                                                        Navigator.of(context)
                                                            .pop(),
                                                      })
                                                  .catchError((onError) => {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
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
                      }
                    })
              ]),
            ),
          )
        ])));
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
                                Image.asset("assets/images/budget.png",
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
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //       blurRadius: 8.0,
                                      //       color:
                                      //           Color.fromRGBO(0, 0, 0, 0.25))
                                      // ]
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/budget.png",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Détail du budget",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: d_red,
                      ))
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow("Date de début", budgets.dateDebut),
              _buildDetailRow("Date de fin", budgets.dateFin ?? ""),
              _buildDetailRow("Montant", "${budgets.montant} FCFA"),
              _buildDetailRow(
                  "Montant restant", "${budgets.montantRestant} FCFA"),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              Center(
                child: const Text(
                  "Description:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  budgets.description,
                  style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Budget alloué à:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  budgets.utilisateur != null
                      ? "${budgets.utilisateur!.nom.toUpperCase()} ${budgets.utilisateur!.prenom.toUpperCase()}"
                      : "${budgets.admin.nom.toUpperCase()} ${budgets.admin.prenom.toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
