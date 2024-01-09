import 'package:cosit_gestion/Page_admin/CustomAppBar.dart';
import 'package:cosit_gestion/Page_admin/CustomCard.dart';
import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Procedure.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/service/ProcedureService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  List<Procedure> procedures = [];
  late Future<List<Procedure>> _procedureList;
  late Future<List<Procedure>> _procedureListe;
  var procedureService = ProcedureService();
  late Admin admin;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
    _procedureListe = getProcedure();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<Procedure>> getProcedure() async {
    final response = await procedureService.getDepenseTotal();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomCard(
              title: "Statistiques",
              imagePath: "assets/images/statistique.png",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Container(
                height: 380,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(40, 15, 15, 15),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                  children: [
                    Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(40, 18, 18, 18),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                "DÉPENSES TOTAL PAR CATÉGORIE",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: d_red,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 70,
                                  child: FutureBuilder(
                                    future: procedureService.getDepenseTotal(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CupertinoActivityIndicator(
                                            radius: 20.0,
                                            color: d_red,
                                          ),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text(snapshot.error.toString()),
                                        );
                                      }

                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: Text(
                                              "Aucune statistique disponible !"),
                                        );
                                      } else {
                                        procedures = snapshot.data!;

                                        debugPrint(
                                            "libelle! : $procedures.libelle!Categorie");
                                        debugPrint("total $procedures");
                                        return procedures.isEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: PieChart(
                                                  PieChartData(
                                                    startDegreeOffset: 80,
                                                    sectionsSpace: 0.3,
                                                    centerSpaceRadius: 40,
                                                    sections: [
                                                      PieChartSectionData(
                                                        value: 80,
                                                        color: Colors.grey,
                                                        radius: 30,
                                                        showTitle: false,
                                                      ),
                                                      PieChartSectionData(
                                                        value: 35,
                                                        color: Colors.blue,
                                                        radius: 30,
                                                        showTitle: false,
                                                      ),
                                                      PieChartSectionData(
                                                        value: 35,
                                                        color:
                                                            Colors.amberAccent,
                                                        radius: 30,
                                                        showTitle: false,
                                                      ),
                                                      PieChartSectionData(
                                                        value: 8,
                                                        color: Colors.pink,
                                                        radius: 30,
                                                        showTitle: false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : PieChart(
                                                swapAnimationDuration:
                                                    const Duration(
                                                        milliseconds: 2000),
                                                swapAnimationCurve:
                                                    Curves.easeInOutQuint,
                                                PieChartData(
                                                    startDegreeOffset: 100,
                                                    sectionsSpace: 0.5,
                                                    centerSpaceRadius: 40,
                                                    sections:
                                                        procedures.map((e) {
                                                      double pourcentage = (double
                                                                  .tryParse(e
                                                                      .total_depenses
                                                                      .toString()) ??
                                                              0.0) /
                                                          procedures.fold(
                                                              0,
                                                              (previousValue,
                                                                      element) =>
                                                                  previousValue +
                                                                  (double.tryParse(element
                                                                          .total_depenses
                                                                          .toString()) ??
                                                                      0.0));
                                                      String pourcentageString =
                                                          '${(pourcentage * 100).toStringAsFixed(1)}%';
                                                      return PieChartSectionData(
                                                        value: double.tryParse(e
                                                            .total_depenses
                                                            .toString()),
                                                        title:
                                                            pourcentageString,
                                                        showTitle: true,
                                                        radius: 30,
                                                        color:
                                                            _getColorFromCategory(
                                                                e.libelle!),
                                                      );
                                                    }).toList()),
                                              );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 55),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildLegendItem("Courses", Colors.grey),
                                      _buildLegendItem(
                                          "Materiel", Colors.amberAccent),
                                      _buildLegendItem(
                                          "Maintenan..",
                                          const Color.fromARGB(
                                              141, 6, 68, 240)),
                                      _buildLegendItem(
                                          "Frais",
                                          const Color.fromARGB(
                                              255, 56, 196, 21)),
                                      _buildLegendItem("Materiel", Colors.pink),
                                      _buildLegendItem(
                                          "Projet",
                                          const Color.fromARGB(
                                              141, 143, 77, 77)),
                                      _buildLegendItem(
                                          "Electricité", Colors.red),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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

  List<Widget> _buildLegend(List<Procedure> pro) {
    return pro.map((Procedure p) {
      return Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: _getColorFromCategory(p.libelle!),
          ),
          const SizedBox(width: 10),
          Text(p.libelle!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 30),
        ],
      );
    }).toList();
  }

  Color _getColorFromCategory(String libelle) {
    switch (libelle) {
      case 'Transport' || 'Transport':
        return const Color.fromARGB(255, 228, 150, 150);
      case 'Courses' || 'Courses':
        return Colors.grey;
      case 'Projet' || 'projet':
        return const Color.fromARGB(141, 143, 77, 77);
      case 'Frais' || 'frais':
        return Colors.blue;
      case 'Electricite' || 'electricité':
        return Colors.pink;
      case 'Maintenance' || 'maintenance':
        return const Color.fromARGB(141, 6, 68, 240);
      case 'Materiel' || 'materiel':
        return Colors.amberAccent;
      case 'Autres':
        return const Color.fromARGB(255, 223, 72, 185);
      default:
        return const Color.fromARGB(255, 156, 148, 148);
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          color: color,
          margin: const EdgeInsets.only(right: 5),
        ),
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }
}
