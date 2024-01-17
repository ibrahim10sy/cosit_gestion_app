import 'package:cosit_gestion/Page_user/DayPage.dart';
import 'package:cosit_gestion/Page_user/MonthPage.dart';
import 'package:cosit_gestion/Page_user/YearPage.dart';
import 'package:cosit_gestion/model/Procedure.dart';
import 'package:flutter/material.dart';

class Statistique extends StatefulWidget {
  const Statistique({super.key});

  @override
  State<Statistique> createState() => _StatistiqueState();
}

var d_red = Colors.red;
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class _StatistiqueState extends State<Statistique>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Procedure> procedures = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    // _animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "Statistique",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            // elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: d_red, borderRadius: BorderRadius.circular(12)),
              child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  controller: tabController,
                  padding: EdgeInsets.all(10),
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  tabs: [
                    Tab(
                        child: Text("Jour",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black))),
                    Tab(
                        child: Text("Mois",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black))),
                    Tab(
                        child: Text("Années",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black))),
                  ]),
            ),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              DayPage(),
              // Page pour la section Mois
              MonthPage(),
              // // Page pour la section Année
              YearPage(),
            ]),
          )
        ],
      ),
    );
  }
}
