import 'dart:async';

import 'package:cosit_gestion/DelayAnimation.dart';
import 'package:cosit_gestion/Page_admin/Connexion.dart';
import 'package:flutter/material.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const Connexion(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 180,
            ),
            DelayedAnimation(
              delay: 1800,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 110),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const DelayedAnimation(
              delay: 2000,
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Bienvenue sur l'application gestion de dépense de COSIT",
                  style: TextStyle(
                      color: Colors.black, fontSize: 22, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
