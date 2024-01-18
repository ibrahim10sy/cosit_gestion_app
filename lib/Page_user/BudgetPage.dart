import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/BudgetDetail.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/model/Budget.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/BudgetService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

const d_red = Colors.red;

class _BudgetPageState extends State<BudgetPage> {
  late List<Budget> budgets = [];

  late Utilisateur utilisateur;

  @override
  void initState() {
    super.initState();
    utilisateur =
        Provider.of<UtilisateurProvider>(context, listen: false).utilisateur!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBars(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              title: "Budget",
              subTitle: "Budget total alloué :",
              imagePath: "assets/images/wallet-budget-icon.png",
              children: Column(
                children: [
                  Consumer<BudgetService>(
                      builder: (context, budgetService, child) {
                    return FutureBuilder(
                        future: budgetService
                            .getBudgetTotalByUser(utilisateur.idUtilisateur!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text("${snapshot.data?["Total"]} FCFA",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold));
                          } else {
                            return const CupertinoActivityIndicator(
                                radius: 20.0,
                                color:
                                    d_red); //const CircularProgressIndicator();
                          }
                        });
                  })
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
                      child: Expanded(
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
                    ),
                    const Divider(
                      height: 1,
                      color: d_red,
                    ),
                    Consumer<BudgetService>(
                      builder: (context, budgetService, child) {
                        return FutureBuilder(
                            future: budgetService
                                .fetchBudgetByUser(utilisateur.idUtilisateur!),
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
                                  child: Text("Aucun budget trouvé"),
                                );
                              } else {
                                budgets = snapshot.data!;
                                return Column(
                                  children: budgets
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
                                                            budgets: bud,
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
                                            "Montant: ${bud.montant} FCFA-Restant: ${bud.montantRestant} FCFA",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              }
                            });
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
}
