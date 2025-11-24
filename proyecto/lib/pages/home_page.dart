import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/pages/listar_eventos.dart';
import 'package:proyecto/pages/listar_mis_eventos.dart';
import 'package:proyecto/pages/agregar_evento.dart';
import 'package:proyecto/services/google_auth.dart';
import 'package:proyecto/widgets/logo_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ListarEventos(),
    ListarMisEventos(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Eventos Disponibles",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
                fontSize: 22,
              ),
            ),
            leading: const LogoAppbar(),
            backgroundColor: Color(0xFFFFFFFF),
            elevation: 2,
            shadowColor: Color(0xFF000000).withValues(alpha: 0.1),
          ),

          endDrawer: isDesktop
              ? null
              : Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB22222), Color(0xFF00838F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
                        child: Text(
                          'Menú',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.calendarText, color: Color(0xFF00838F)),
                        title: const Text('Eventos'),
                        selected: _selectedIndex == 0,
                        selectedTileColor: Color(0xFFF0F8F8),
                        onTap: () {
                          Navigator.pop(context);
                          _onItemSelected(0);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.accountClock, color: Color(0xFF00838F)),
                        title: const Text('Mis eventos'),
                        selected: _selectedIndex == 1,
                        selectedTileColor: Color(0xFFF0F8F8),
                        onTap: () {
                          Navigator.pop(context);
                          _onItemSelected(1);
                        },
                      ),
                      Divider(color: Color(0xFFE0E0E0), thickness: 1),
                      ListTile(
                        leading: Icon(MdiIcons.logout, color: Color(0xFFD32F2F)),
                        title: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Color(0xFFD32F2F)),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          await GoogleAuthService().signOut();
                        },
                      ),
                    ],
                  ),
                ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24.0, right: 24.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB22222), Color(0xFF051E34)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AgregarEvento()),
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(Icons.add, color: Color(0xFFFFFFFF), size: 28),
              ),
            ),
          ),
          
          body: Row(
            children: [
              if (isDesktop) 
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: Offset(2, 0),
                      ),
                    ],
                  ),
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _onItemSelected,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.transparent,
                    selectedIconTheme: IconThemeData(color: Color(0xFF00838F), size: 24),
                    selectedLabelTextStyle: TextStyle(
                      color: Color(0xFF00838F),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    unselectedIconTheme: IconThemeData(color: Color(0xFFBBBBBB), size: 24),
                    unselectedLabelTextStyle: TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 12,
                    ),
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(MdiIcons.calendarText),
                        label: Text('Eventos'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(MdiIcons.accountClock),
                        label: Text('Mis Eventos'),
                      ),
                    ],
                  ),
                ),
              
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFB22222),
                          Color(0xFF00838F),
                          Color(0xFF051E34),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: _pages[_selectedIndex]
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}