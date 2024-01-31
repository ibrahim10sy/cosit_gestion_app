import 'package:cosit_gestion/Page_user/Updateprofil.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilUtilisateur extends StatefulWidget {
  const ProfilUtilisateur({Key? key});

  @override
  State<ProfilUtilisateur> createState() => _ProfilUtilisateurState();
}

const d_red = Colors.red;

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {
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
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 160),
                      Consumer<UtilisateurProvider>(
                        builder: (context, userProvider, child) {
                          final user = userProvider.utilisateur;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Nom : ${user!.nom.toUpperCase()} ${user.prenom.toUpperCase()}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Email : ${user.email}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Phone : ${user.phone}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: d_red,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProfil(
                                          utilisateurs: user,
                                        ),
                                      ),
                                    );
                                  },
                                  label: const Text(
                                    "Modifier profil",
                                    style:
                                        TextStyle(color: d_red, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: Consumer<UtilisateurProvider>(
              builder: (context, userProvider, child) {
                final user = userProvider.utilisateur;
                return user?.image == null || user?.image?.isEmpty == true
                    ? CircleAvatar(
                        backgroundColor: d_red,
                        radius: 120,
                        child: Text(
                          "${user!.prenom.substring(0, 1).toUpperCase()}${user.nom.substring(0, 1).toUpperCase()}",
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
                            user!.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
