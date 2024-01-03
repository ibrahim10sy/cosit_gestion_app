import 'package:cosit_gestion/Page_admin/BottomNavigationPage.dart';
import 'package:cosit_gestion/Page_admin/Connexion.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/provider/UtilisateurProvider.dart.dart';
import 'package:cosit_gestion/service/AdminService.dart';
import 'package:cosit_gestion/service/BottomNavigationService.dart';
import 'package:cosit_gestion/service/BudgetService.dart';
import 'package:cosit_gestion/service/BureauService.dart';
import 'package:cosit_gestion/service/CategorieService.dart';
import 'package:cosit_gestion/service/DemandeService.dart';
import 'package:cosit_gestion/service/DepenseService.dart';
import 'package:cosit_gestion/service/ProcedureService.dart';
import 'package:cosit_gestion/service/SalaireService.dart';
import 'package:cosit_gestion/service/SendNotifService.dart';
import 'package:cosit_gestion/service/SousCategorieService.dart';
import 'package:cosit_gestion/service/UtilisateurService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UtilisateurProvider()),
    ChangeNotifierProvider(create: (context) => UtilisateurService()),
    ChangeNotifierProvider(create: (context) => BudgetService()),
    ChangeNotifierProvider(create: (context) => AdminProvider()),
    ChangeNotifierProvider(create: (context) => AdminServcie()),
    ChangeNotifierProvider(create: (context) => BureauService()),
    ChangeNotifierProvider(create: (context) => SalaireService()),
    ChangeNotifierProvider(create: (context) => CategorieService()),
    ChangeNotifierProvider(create: (context) => DepenseService()),
    ChangeNotifierProvider(create: (context) => DemandeService()),
    ChangeNotifierProvider(create: (context) => SousCategorieService()),
    ChangeNotifierProvider(create: (context) => ProcedureService()),
    ChangeNotifierProvider(create: (context) => SendNotifService()),
    ChangeNotifierProvider(create: (context) => BottomNavigationService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/BottomNavigationPage': (context) => const BottomNavigationPage()
      },
      home: const Connexion(),
    );
  }
}
