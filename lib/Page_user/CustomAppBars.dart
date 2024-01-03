import 'package:badges/badges.dart' as badges;
import 'package:cosit_gestion/Page_user/EmailPage.dart';
import 'package:cosit_gestion/Page_user/ProfilUtilisateur.dart';
import 'package:cosit_gestion/model/SendNotification.dart';
import 'package:cosit_gestion/model/Utilisateur.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/SendNotifService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBars extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBars({super.key});

  @override
  State<CustomAppBars> createState() => _CustomAppBarsState();
   @override
  Size get preferredSize => const Size.fromHeight(150.0);
}
const d_red = Colors.red;
class _CustomAppBarsState extends State<CustomAppBars> {
  late Utilisateur utilisateur;

  late Future<List<SendNotification>> _notif;
  late List<SendNotification> listNotif = [];

  @override
  void initState() {
    super.initState();
    _notif = getNotif();
    utilisateur =
        Provider.of<UtilisateurProvider>(context, listen: false).utilisateur!;
  }

  Future<List<SendNotification>> getNotif() async {
    try {
      final response = await SendNotifService().fetchData(utilisateur.idUtilisateur!);
      setState(() {
        listNotif = response;
      });
      return response;
    } catch (error) {
      print('Erreur lors de la récupération des notifications: $error');
      return listNotif = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 28),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(31),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 7.0,
                  color: Color.fromRGBO(
                      0, 0, 0, 0.25) //Color.fromRGBO(47, 144, 98, 1)
                  )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilUtilisateur()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<UtilisateurProvider>(
                    builder: (context, userService, child) {
                  final user = userService.utilisateur;
                  return Row(
                    children: [
                      user?.image == null || user?.image?.isEmpty == true
                          ? CircleAvatar(
                              backgroundColor: d_red,
                              radius: 30,
                              child: Text(
                                "${user!.prenom.substring(0, 1).toUpperCase()}${user.nom.substring(0, 1).toUpperCase()}",
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "http://10.0.2.2/${user!.image!}"),
                              radius: 30,
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "${user.prenom.toUpperCase()} ${user.nom.toUpperCase()}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailPageUser()));
                      },
                      child: badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -2, end: -2),
                        badgeContent: Text(
                          "${listNotif.length}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Color.fromRGBO(240, 176, 2, 1),
                          size: 40,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}