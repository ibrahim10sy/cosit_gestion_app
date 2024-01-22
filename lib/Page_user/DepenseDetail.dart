import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/Page_user/CustomAppBars.dart';
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
              overflow: TextOverflow.ellipsis,
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
                    overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBars(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text("Justification", style: labelStyle),
                        ),
                        // Utilisez l'état pour décider d'afficher ou masquer la pièce justificative
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showJustification = !_showJustification;
                            });
                          },
                          icon: Icon(
                            _showJustification
                                ? Icons.visibility_off_sharp
                                : Icons.remove_red_eye,
                            color: d_red,
                          ),
                          label: Text(
                            _showJustification ? 'Masquer' : 'Voir',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Flexible(
                          child: Visibility(
                        visible: _showJustification,
                        child:
                            depense.image != null && depense.image!.isNotEmpty
                                ? Image.network(
                                    depense.image!,
                                    width: 200,
                                    height: 210,
                                    scale: 1,
                                    fit: BoxFit.contain,
                                  )
                                : const Text(
                                    textAlign: TextAlign.center,
                                    "Aucune justificatif"),
                      )),
                    ),
                    _buildDetailRow("Description", depense.description),
                    _buildDetailRow("Date du dépense", depense.dateDepense),
                    _buildDetailRow(
                        "Catégorie", depense.sousCategorie.libelle),
                    _buildDetailRow("Bureau ", depense.bureau.adresse),
                    _buildDetailRow("Montant ",
                        "${depense.montantDepense.toString()} FCFA"),
                    const SizedBox(height: 10),
                    const Divider( 
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                    const Center(
                      child: Text(
                        "Dépense faite par:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                          "${depense.utilisateur!.nom.toUpperCase()} ${depense.utilisateur!.prenom.toUpperCase()}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        "Budget concerné:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(depense.budget.description,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold)),
                    ),
                     const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'Statut d\'Autorisation : ${_getStatusText(depense.autorisationAdmin)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

   String _getStatusText(bool? status) {
    return status == true ? 'Oui' : 'Non';
  }
}
