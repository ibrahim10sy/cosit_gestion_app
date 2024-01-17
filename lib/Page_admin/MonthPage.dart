import 'package:cosit_gestion/model/Admin.dart';
import 'package:cosit_gestion/model/Procedure.dart';
import 'package:cosit_gestion/provider/AdminProvider.dart';
import 'package:cosit_gestion/service/ProcedureService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

var d_red = Colors.red;
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class _MonthPageState extends State<MonthPage> {
  List<Procedure> procedures = [];
  late Future<List<Procedure>> _procedureList;
  late Future<List<Procedure>> _procedureListe;
  int _currentPage = 1;
  int _pageSize = 5;
  List<Procedure> _data = [];
  bool _isLoading = false;
  var procedureService = ProcedureService();
  late Admin admin;

  @override
  void initState() {
    super.initState();
    admin = Provider.of<AdminProvider>(context, listen: false).admin!;
    getProcedure();
  }

  Future<List<Procedure>> getProcedure() async {
    setState(() {
      _isLoading = true;
    });
    final response = await procedureService.getDepenseTotalByMois();
    setState(() {
      _data.addAll(response);
      _isLoading = false;
    });
    return response;
  }

  void _loadMoreData() {
    if (!_isLoading) {
      setState(() {
        _currentPage++;
      });
      getProcedure();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PaginatedDataTable(
                        header: const Text('Les dépenses par mois'),
                        rowsPerPage: _pageSize,
                        availableRowsPerPage: const [5, 10, 15, 25],
                        onRowsPerPageChanged: (value) {
                          setState(() {
                            _pageSize = value!;
                          });
                        },
                        columns: const [
                          DataColumn(
                              label: Text(
                            'Date',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Catégorie',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Montant',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )),
                          DataColumn(
                              label: Text(
                            'Bureau',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )),
                        ],
                        source: _DataSource(data: _data),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "DÉPENSES TOTAL PAR CATÉGORIE PAR MOIS",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: d_red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 150,
                    width: 70,
                    child: FutureBuilder(
                      future: procedureService.getDepenseTotalByMois(),
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
                            child: Text(snapshot.error.toString()),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Aucune statistique disponible !"),
                          );
                        } else {
                          procedures = snapshot.data!;

                          debugPrint(
                              "libelle! : $procedures.libelle!Categorie");
                          debugPrint("total $procedures");
                          return procedures.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
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
                                          color: Colors.amberAccent,
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
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: PieChart(
                                    swapAnimationDuration:
                                        const Duration(milliseconds: 2000),
                                    swapAnimationCurve: Curves.easeInOutQuint,
                                    PieChartData(
                                        startDegreeOffset: 100,
                                        sectionsSpace: 0.5,
                                        centerSpaceRadius: 40,
                                        sections: procedures.map((e) {
                                          double pourcentage = (double.tryParse(
                                                      e.total_depenses
                                                          .toString()) ??
                                                  0.0) /
                                              procedures.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      (double.tryParse(element
                                                              .total_depenses
                                                              .toString()) ??
                                                          0.0));
                                          String pourcentageString =
                                              '${(pourcentage * 100).toStringAsFixed(1)}%';
                                          return PieChartSectionData(
                                            value: double.tryParse(
                                                e.total_depenses.toString()),
                                            title: pourcentageString,
                                            showTitle: true,
                                            radius: 30,
                                            color: _getColorFromCategory(
                                                e.libelle!),
                                          );
                                        }).toList()),
                                  ),
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
                        _buildLegendItem("Materiel", Colors.amberAccent),
                        _buildLegendItem("Maintenance",
                            const Color.fromARGB(141, 6, 68, 240)),
                        _buildLegendItem(
                            "Frais", const Color.fromARGB(255, 56, 196, 21)),
                        _buildLegendItem(
                            "Projet", const Color.fromARGB(141, 143, 77, 77)),
                        _buildLegendItem("Electricité", Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
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
      return const Color.fromARGB(255, 56, 196, 21);
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

class _DataSource extends DataTableSource {
  final List<Procedure> data;

  _DataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(
        item.mois!,
        style: TextStyle(color: Colors.black, fontSize: 16),
      )),
      DataCell(Text(
        item.libelle!,
        style: TextStyle(color: Colors.black, fontSize: 16),
      )),
      DataCell(Text(
        item.total_depenses.toString(),
        style: TextStyle(color: Colors.black, fontSize: 16),
      )),
      DataCell(Text(
        item.nom_bureau!,
        style: TextStyle(color: Colors.black, fontSize: 16),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
