import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Salaire.dart';
import 'package:flutter/material.dart';

class SalaireDetail extends StatefulWidget {
  final Salaire salaires;

  const SalaireDetail({Key? key, required this.salaires}) : super(key: key);

  @override
  State<SalaireDetail> createState() => _SalaireDetailState();
}

class _SalaireDetailState extends State<SalaireDetail> {
  late Salaire salaire;

  @override
  void initState() {
    salaire = widget.salaires;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomCard(
              title: "Détails salaire",
              imagePath: "assets/images/wallet-budget-icon.png",
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                height: 430,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: salaire.utilisateur.image == null ||
                                salaire.utilisateur.image?.isEmpty == true
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 50,
                                child: Text(
                                  "${salaire.utilisateur.prenom.substring(0, 1).toUpperCase()}${salaire.utilisateur.nom.substring(0, 1).toUpperCase()}",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              )
                            : Image.network(
                                salaire.utilisateur.image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildDetailRow("Description", salaire.description),
                    _buildDetailRow(
                        "Montant", "${salaire.montant.toInt()} Fcfa"),
                    _buildDetailRow("Employé",
                        "${salaire.utilisateur.nom} ${salaire.utilisateur.prenom}"),
                    _buildDetailRow("Date de paiement", salaire.date),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
