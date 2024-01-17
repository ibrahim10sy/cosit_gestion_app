import 'package:cosit_gestion/Page_admin/AjoutBudget.dart';
import 'package:cosit_gestion/Page_admin/BudgetDetail.dart';
import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/UpdateBudgets.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/service/BudgetService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

const d_red = Colors.red;

class _BudgetPageState extends State<BudgetPage> {
  late Future<Map<String, dynamic>> future;
  late List<Budget> BudgetList;
  late Future<List<Budget>> _futureListBudget;
  late List<Budget>? budgets = [];
  TextEditingController inputController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('yyyy-MM').format(picked);
      setState(() {
        inputController.text = formattedDate;
        selectedDate = picked;
      });
    }
  }

  late Admin admin;
  @override
  void initState() {
    super.initState();
    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Budget",
              subTitle: "Montant total alloué",
              imagePath: "assets/images/wallet-budget-icon.png",
              children: Column(
                children: [
                  Consumer<BudgetService>(
                      builder: (context, budgetService, child) {
                    return FutureBuilder(
                        future:
                            budgetService.getBudgetTotalByAdmin(admin.idAdmin!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text("${snapshot.data?["Total"]} FCFA",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold));
                          } else {
                            return const Center(
                              child: CupertinoActivityIndicator(
                                  radius: 20.0, color: d_red),
                            ); //const CircularProgressIndicator();
                          }
                        });
                  }),
                  const SizedBox(
                    height: 15,
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
                                  builder: (context) => const AjoutBudget()));
                        },
                        child: const Text(
                          "+ Ajouter un budget",
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
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
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              //flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/budget.png",
                                      width: 39, height: 39),
                                  const Expanded(
                                    //flex: 4,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        "Liste des budgets :",
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
                      Consumer<BudgetService>(
                        builder: (context, budgetService, child) {
                          if (budgetService.lastAction !=
                              budgetService.action) {
                            return FutureBuilder<List<Budget>>(
                                future: budgetService.action == "all"
                                    ? budgetService.fetchBudgets()
                                    : budgetService.action == "search"
                                        ? budgetService.searchBudgetByDesc()
                                        : budgetService.sortByMonthAndYear(),
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
                                      Provider.of<BudgetService>(context,
                                              listen: false)
                                          .lastAction = budgetService.action;
                                      setState(() {});
                                    });
                                    return Center(
                                      child: Text(snapshot.error
                                          .toString()
                                          .replaceAll("Exception", "")),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text("Aucun budget trouvé"),
                                    );
                                  }

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Provider.of<BudgetService>(context,
                                            listen: false)
                                        .lastAction = budgetService.action;
                                    setState(() {});
                                  });

                                  budgets = snapshot.data;
                                  return Column(
                                    children: budgets!
                                        .map(
                                          (Budget bud) => ListTile(
                                            leading: Image.asset(
                                              "assets/images/budget.png",
                                              width: 33,
                                              height: 33,
                                            ),
                                            title: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BudgetDetail(
                                                              budget: bud,
                                                            )));
                                              },
                                              child: Text(
                                                bud.description,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            subtitle: Text(
                                              "Montant: ${bud.montant} FCFA-Reste:${bud.montantRestant} FCFA",
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
                                                              updateBudgets(
                                                                  budget: bud),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const PopupMenuDivider(),
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
                                                      await Provider.of<
                                                                  BudgetService>(
                                                              context,
                                                              listen: false)
                                                          .deleteBudget(
                                                              bud.idBudget!)
                                                          .then((value) => {
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
                                                                            "Impossible de supprimer ce budget car il est associer à une dépense ",
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
                                          ),
                                        )
                                        .toList(),
                                  );
                                });
                          } else {
                            Provider.of<BudgetService>(context, listen: false)
                                .lastAction = "";
                            if (budgetService.budget.isNotEmpty) {
                              budgets = budgetService.budget;
                              return Column(
                                  children: budgets!
                                      .map((Budget bud) => ListTile(
                                          leading: Image.asset(
                                              "assets/images/budget.png",
                                              width: 33,
                                              height: 33),
                                          title: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BudgetDetail(
                                                            budget: bud,
                                                          )));
                                            },
                                            child: Text(bud.description,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          subtitle: Text(
                                            "Montant: ${bud.montant} FCFA-Reste: ${bud.montantRestant} FCFA",
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
                                                            FontWeight.bold),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                updateBudgets(
                                                                    budget:
                                                                        bud)));
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
                                                            FontWeight.bold),
                                                  ),
                                                  onTap: () async {
                                                    await Provider.of<
                                                                BudgetService>(
                                                            context,
                                                            listen: false)
                                                        .deleteBudget(
                                                            bud.idBudget!)
                                                        .then((value) => {
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
                                                                            "Impossible de supprimer ce budget car il est associer à une dépense ",
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
                                          )))
                                      .toList());
                            } else {
                              return const Center(
                                child: Text("Aucun budget trouvé"),
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ))
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
              Provider.of<BudgetService>(context, listen: false).action = "all";
              Provider.of<BudgetService>(context, listen: false).applyChange();
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
                                  "Rechercher un budget",
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
                                              Provider.of<BudgetService>(
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
                                    "Trier les  budgets",
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
                                        Provider.of<BudgetService>(context,
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
