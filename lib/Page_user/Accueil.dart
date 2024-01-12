import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CategoriePage.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
import 'package:cosit_gestion/Page_user/DemandePage.dart';
import 'package:cosit_gestion/Page_user/DepensePage.dart';
import 'package:cosit_gestion/Page_user/Statistique.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
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
        appBar: CustomAppBars(),
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
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: [
                    _buildAccueilCard("Demande", "demande.png", 1),
                    _buildAccueilCard("Dépenses", "depense.png", 2),
                    _buildAccueilCard("Catégories", "categorie.png", 3),
                    _buildAccueilCard(
                        "Statistiques", "statistique_logo.png", 4),

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
          if (index == 4) {
            Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const Statistique()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CategoriePage()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DepensePage()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DemandePages()));
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
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.25, // Set width to 80% of the screen width
                  child: Image.asset(
                    "assets/images/$imgLocation",
                    fit: BoxFit
                        .cover, // You can adjust the BoxFit based on your needs
                  ),
                ),
                Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
