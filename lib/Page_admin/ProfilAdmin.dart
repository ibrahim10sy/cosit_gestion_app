import 'package:cosit_gestion/Page_admin/Connexion.dart';
import 'package:cosit_gestion/Page_admin/UpdateProfil.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

const d_red = Colors.red;

class _ProfilAdminState extends State<ProfilAdmin> {
  late Admin admin;
  @override
  void initState() {
    super.initState();

    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
  }

  void seDeconnecter() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Connexion()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d_red,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: d_red,
        title: const Text(
          "Profil",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        topRight: Radius.circular(
                            80.0), // Arrondir le coin supérieur droit
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 160),
                        Consumer<AdminProvider>(
                            builder: (context, adminProvider, child) {
                          final admins = adminProvider.admin;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Nom : ${admins!.nom.toUpperCase()} ${admins.prenom.toUpperCase()}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Email : ${admins.email}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Phone : ${admins.phone}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.red, width: 1)),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: d_red,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateProfil(
                                                        admin: admin)));
                                      },
                                      label: const Text(
                                        "Modifier profil",
                                        style: TextStyle(
                                            color: d_red, fontSize: 20),
                                      ))),
                              // Padding(
                              //     padding: const EdgeInsets.all(10.0),
                              //     child: OutlinedButton.icon(
                              //         style: OutlinedButton.styleFrom(
                              //             side: const BorderSide(
                              //                 color: Colors.red, width: 1)),
                              //         icon: const Icon(
                              //           Icons.logout,
                              //           color: d_red,
                              //         ),
                              //         onPressed: seDeconnecter,
                              //         label: const Text(
                              //           "Se déconnecter",
                              //           style: TextStyle(
                              //               color: d_red, fontSize: 20),
                              //         ))),
                            ],
                          );
                        })
                      ],
                    ),
                  ))),
            ],
          ),
          Positioned(child: Consumer<AdminProvider>(
            builder: (context, adminProvider, child) {
              final admins = adminProvider.admin;
              return admins?.image == null || admins?.image?.isEmpty == true
                  ? CircleAvatar(
                      backgroundColor: d_red,
                      radius: 120,
                      child: Text(
                        "${admins!.prenom.substring(0, 1).toUpperCase()}${admins.nom.substring(0, 1).toUpperCase()}",
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: SizedBox(
                        width: 210.0,
                        height: 210.0,
                        child: Image.network(
                         admins!.image!,
                          // fit: BoxFit.fill,
                          fit: BoxFit
                              .cover, // ou BoxFit.contain, BoxFit.fill, etc.
                          // scale: 0.5,
                        ),
                      ));
            },
          ))
        ],
      ),
    );
  }
}
