import 'package:cosit_gestion/model/SendNotification.dart';
import 'package:flutter/material.dart';

const d_red = Colors.red;

class DetailNotification extends StatelessWidget {
  final SendNotification notification;
  late SendNotification sendNotifications;
   DetailNotification({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: d_red,
        title: const Text(
          'Détails de la Notification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Message:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 2),
            Text(
              textAlign: TextAlign.justify,
              notification.message,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'depense approuver par :',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'Nom: ${notification.admin?.nom.toUpperCase()}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              'Prénom: ${notification.admin?.prenom.toUpperCase()}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              'Email: ${notification.admin.email}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'depense:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'Motif : ${notification.depense.description}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              'Montant demandé: ${notification.depense.montantDepense} FCFA',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              'Date de depense: ${notification.depense.dateDepense}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
           
            Text(
              'Statut Autorisation Admin: ${_getStatusText(notification.depense?.autorisationAdmin)}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(bool? status) {
    return status == true ? 'Oui' : 'Non';
  }
}
