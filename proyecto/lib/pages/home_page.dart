import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/pages/listar_eventos.dart';
import 'package:proyecto/pages/listar_mis_eventos.dart';
import 'package:proyecto/pages/agregar_evento.dart';
import 'package:proyecto/widgets/logo_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              "Bienvenido",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: const LogoAppbar(),
          ),

          endDrawer: isDesktop
              ? null
              : Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB22222), Color(0xFF00838F)],
                          ),
                        ),
                        child: Text(
                          'Menú',
                          style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20),
                        ),
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.calendarText),
                        title: const Text('Eventos'),
                        selected: _selectedIndex == 0,
                        onTap: () {
                          Navigator.pop(context);
                          _onItemSelected(0);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.accountClock),
                        title: const Text('Mis eventos'),
                        selected: _selectedIndex == 1,
                        onTap: () {
                          Navigator.pop(context);
                          _onItemSelected(1);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.logout),
                        title: const Text('Cerrar Sesión'),
                        onTap: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                        },
                      ),
                    ],
                  ),
                ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24.0, right: 24.0), // mover arriba e izquierda
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D47A1), // Azul profundo
                    Color(0xFF1565C0), // Azul medio
                    Color(0xFF0277BD), // Cian azulado
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
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
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemSelected,
                  labelType: NavigationRailLabelType.all,
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

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _pages[_selectedIndex],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}