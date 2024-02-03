import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/Page_user/DepenseDetail.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BudgetDetail extends StatefulWidget {
  final Budget budgets;
  const BudgetDetail({super.key, required this.budgets});

  @override
  State<BudgetDetail> createState() => _BudgetDetailState();
}

const d_red = Colors.red;

class _BudgetDetailState extends State<BudgetDetail> {
  late Future<List<Depense>> _depenseListe;
  late Future<Map<String, dynamic>> montantDepense;
  late List<Depense> depenseList = [];
  late Budget budget;
  int? budgetID;

  Future<List<Depense>> getDepenseByBudget() async {
    final response =
        await DepenseService().fetchDepensesByBudget(budget.idBudget!);

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
    budget = widget.budgets;
    budgetID = budget.idBudget;
    budget.printInfo();
    _depenseListe = getDepenseByBudget();
    montantDepense = getMontant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBars(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              // subTitle: "${budget.montant} FCFA,",
              title: "Détail du budget",
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
                              "Montant Total :",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${budget.montant} FCFA    ",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                              "${budget.montantRestant} FCFA    ",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // FutureBuilder(
                        //   future: DepenseService()
                        //       .getSommeDepenseTotalByBudget(budget.idBudget!),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       debugPrint("Boucle 1");
                        //       return Column(
                        //         children: [
                        //           const Text(
                        //             "Total dépensé",
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 15,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           Text("${snapshot.data?["Total"]} FCFA",
                        //               style: const TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 22,
                        //                   fontWeight: FontWeight.bold))
                        //         ],
                        //       );
                        //     } else {
                        //       return const Center(
                        //         child: CupertinoActivityIndicator(
                        //           radius: 20.0,
                        //           color: Colors.white,
                        //         ),
                        //       );
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          openDialog();
                        },
                        icon: const Icon(
                          Icons.info_outlined,
                          color: Colors.white,
                        )),
                  )
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CupertinoActivityIndicator(
                                radius: 20.0, color: d_red),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child:
                                  Text("Aucune dépense trouvé pour ce budget"),
                            ),
                          );
                        } else {
                          debugPrint("Boucle 2");

                          depenseList = snapshot.data!;
                          return Column(
                            children: depenseList
                                .map((Depense depense) => ListTile(
                                      leading: Image.asset(
                                        "assets/images/depense.png",
                                        width: 33,
                                        height: 33,
                                      ),
                                      title: Text(
                                        depense.description,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
                                                Icons.edit_calendar_sharp,
                                                color: Colors.green,
                                              ),
                                              title: const Text(
                                                "Aperçu",
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
                                                          DepenseDetail(
                                                              depenses:
                                                                  depense)),
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
          ],
        ),
      ),
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
              _buildDetailRow("Date de début", budget.dateDebut),
              _buildDetailRow("Date de fin", budget.dateFin ?? ""),
              _buildDetailRow("Montant", "${budget.montant} FCFA"),
              _buildDetailRow(
                  "Montant restant", "${budget.montantRestant} FCFA"),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              const Text(
                "Description:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                budget.description,
                style: const TextStyle(fontSize: 14),
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
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
