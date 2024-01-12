import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/model/Depense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailDemande extends StatefulWidget {
  final Depense depense;
  const DetailDemande({super.key, required this.depense});

  @override
  State<DetailDemande> createState() => _DetailDemandeState();
}
const d_red = Colors.red;
class _DetailDemandeState extends State<DetailDemande> {
   late Depense depenses;

   @override
  void initState() {
    super.initState();
     depenses = widget.depense;
  }
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
      appBar: AppBar(
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: d_red,
        title: const Text(
          'Détails de la demande',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [Colors.blue, Colors.white],
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // const Divider(),
              const ListTile(
                title: Text(
                  'Demande faite par:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '${widget.depense.utilisateur!.nom.toUpperCase()} ${widget.depense.utilisateur!.prenom.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Motif : ${widget.depense.description}',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                title: Text(
                  'Montant demandé: ${widget.depense.montantDepense} FCFA',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                title: Text(
                  'Date de Demande: ${widget.depense.dateDepense}',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
               
              ListTile(
                title: Text(
                  'Statut Autorisation Admin: ${_getStatusText(widget.depense.autorisationAdmin)}',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(bool? status) {
    return status == true ? 'Oui' : 'Non';
  }
}