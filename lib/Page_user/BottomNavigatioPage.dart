import 'package:cosit_gestion/Page_user/Accueil.dart';
import 'package:cosit_gestion/Page_user/BudgetPage.dart';
import 'package:cosit_gestion/Page_user/CategoriePage.dart';
import 'package:cosit_gestion/Page_user/DemandePage.dart';
import 'package:cosit_gestion/Page_user/DepensePage.dart';
import 'package:cosit_gestion/service/BottomNavigationService.dart';
import 'package:cosit_gestion/service/BudgetService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

const d_red = Colors.red;

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int activePageIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  List pages = <Widget>[
    const Accueil(),
    const BudgetPage(),
    const DepensePage(),
    const DemandePages()
  ];
  void _changeActivePageValue(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  void _onItemTap(int index) {
    Provider.of<BottomNavigationService>(context, listen: false)
        .changeIndex(index);
    Provider.of<BudgetService>(context, listen: false).applyChange();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[activePageIndex].currentState!.maybePop();
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Consumer<BottomNavigationService>(
          builder: (context, bottomService, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _changeActivePageValue(bottomService.pageIndex);
            });
            return Stack(
              children: [
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                _buildOffstageNavigator(2),
                _buildOffstageNavigator(3)
              ],
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: d_red),
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/home_svg.svg",
                    width: 29,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                        (activePageIndex == 0) ? d_red : d_red,
                        BlendMode.srcIn),
                  ),
                  label: "Accueil"),
               BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/moneyTotal.svg",
                  width: 29,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                      (activePageIndex == 0) ? d_red : d_red, BlendMode.srcIn),
                ),
                label: "Budgets",
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/wallet_budget.svg",
                    width: 29,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                        (activePageIndex == 0) ? d_red : d_red,
                        BlendMode.srcIn),
                  ),
                  label: "Depense"),
              const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.folder_outlined,
                    color: d_red,
                    size: 28,
                  ),
                  label: "Demande"),
            ],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            selectedItemColor: d_red,
            currentIndex: activePageIndex,
            onTap: _onItemTap,
          ),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const Accueil(),
          const BudgetPage(),
          const DepensePage(),
          const DemandePages()
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: activePageIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
