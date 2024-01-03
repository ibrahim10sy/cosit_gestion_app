import 'package:cosit_gestion/Page_admin/AjoutBureau.dart';
import 'package:cosit_gestion/Page_admin/BudgetPage.dart';
import 'package:cosit_gestion/Page_admin/CategorieDepensePage.dart';
import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_admin/DepensePage.dart';
import 'package:cosit_gestion/Page_admin/StatistiquesDepense.dart';
import 'package:cosit_gestion/Page_admin/UtilisateurPage.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/service/BudgetService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}
const d_red = Colors.red;

class _AccueilState extends State<Accueil> {
   late Future<Map<String, dynamic>> future;

  late Admin admin;
  @override
  void initState() {
    super.initState();
    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
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
                              .getBudgetTotalByAdmin(admin.idAdmin!),
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
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: [
                    _buildAccueilCard("Budgets", "budget.png", 1),
                    _buildAccueilCard("Dépenses", "depense.png", 2),
                    _buildAccueilCard("Catégories", "categorie.png", 3),
                    _buildAccueilCard(
                        "Statistiques", "statistique_logo.png", 4),
                    _buildAccueilCard("Employer", "employe.png", 5),
                    _buildAccueilCard("Bureaux", "house.png", 6),
                    // _buildAccueilCard("Statistique", "statistique_logo.png", 4)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildAccueilCard(String titre, String imgLocation, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (index == 6) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AjoutBureau()));
          } else if (index == 5) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UtilisateurPage()));
          } else if (index == 4) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Statistique()));
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategorieDepensePage()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DepensePage()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BudgetPage()));
          }
        },
        borderRadius: BorderRadius.circular(28),
        highlightColor: d_red,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/$imgLocation"),
              Text(
                titre,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
