import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Demande.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

const d_red = Colors.red;

class DetailDemandeAdmin extends StatefulWidget {
  final Demande demande;

  const DetailDemandeAdmin({Key? key, required this.demande}) : super(key: key);

  @override
  State<DetailDemandeAdmin> createState() => _DetailDemandeAdminState();
}

class _DetailDemandeAdminState extends State<DetailDemandeAdmin> {
  late Demande demandes;
  late Admin admins;

  @override
  void initState() {
    super.initState();
    demandes = widget.demande;
  
    admins = Provider.of<AdminProvider>(context, listen: false).admin!;
    demandes.printInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  '${widget.demande.utilisateur.nom.toUpperCase()} ${widget.demande.utilisateur.prenom.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Motif : ${widget.demande.motif}',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                title: Text(
                  'Montant demandé: ${widget.demande.montantDemande} FCFA',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                title: Text(
                  'Date de Demande: ${widget.demande.dateDemande}',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                title: Text(
                  'Statut Autorisation Directeur: ${_getStatusText(widget.demande.autorisationDirecteur)}',
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              ListTile(
                title: Text(
                  'Statut Autorisation Admin: ${_getStatusText(widget.demande.autorisationAdmin)}',
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
