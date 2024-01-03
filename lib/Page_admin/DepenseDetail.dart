import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:flutter/material.dart';


class DepenseDetail extends StatefulWidget {
  final Depense depenses;

  const DepenseDetail({super.key, required this.depenses});

  @override
  State<DepenseDetail> createState() => _DepenseDetailState();
}

class _DepenseDetailState extends State<DepenseDetail> {
  late Depense depense;
  bool _showJustification =
      false; // État pour contrôler la visibilité de la pièce justificative

  // Ajout des styles globaux
  final TextStyle labelStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
      overflow: TextOverflow.ellipsis);

  final TextStyle valueStyle = const TextStyle(
      fontSize: 18, color: Colors.black, overflow: TextOverflow.ellipsis);

  @override
  void initState() {
    super.initState();
    depense = widget.depenses;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          // Afficher le bouton seulement s'il y a une justification
          label == "Justification" && depense.image != null
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showJustification = !_showJustification;
                    });
                  },
                  child: Text(
                    _showJustification ? "Masquer" : "Afficher",
                    style: const TextStyle(color: d_red),
                  ),
                )
              : Text(
                  value,
                  style: valueStyle,
                ),
        ],
      ),
    );
  }

  void _showImage() {
    setState(() {
      depense.image == null || depense.image?.isEmpty == true
          ? Text("Aucune justification", style: valueStyle)
          : Image.network("http://10.0.2.2/${depense.image}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomCard(
              title: "Détails du dépense",
              imagePath: "assets/images/depense.png",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Container(
                height: 480,
                width: 350,
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text("Justification", style: labelStyle),
                        ), // Utilisez l'état pour décider d'afficher ou masquer la pièce justificative
                        TextButton(
                            onPressed: _showImage, child: const Text("Voir"))
                      ],
                    ),
                    _buildDetailRow("Description", depense.description),
                    _buildDetailRow("Date du dépense", depense.dateDepense),
                    _buildDetailRow(
                        "Catégorie", depense.categorieDepense.libelle),
                    _buildDetailRow("Bureau ", depense.bureau.adresse),
                    _buildDetailRow("Montant ",
                        "${depense.montantDepense.toString()} FCFA"),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                    const Text(
                      "Dépense faite par:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                        "${depense.admin!.nom.toUpperCase()} ${depense.admin!.prenom.toUpperCase()}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Budget concerné:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(depense.budget.description,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
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
