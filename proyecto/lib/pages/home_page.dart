import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/pages/agregar_producto.dart';
import 'package:proyecto/pages/listar_eventos.dart';
import 'package:proyecto/widgets/logo_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ListarEventos(),
    // Center(
    //   child: Text(
    //     'Bienvenidos a la pagina de Carlos y Camilo, el inico sera el listar',
    //     style: TextStyle(fontSize: 18),
    //   ),
    // ),
    AgregarProducto(),
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
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Bienvenido",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: const LogoAppbar(),
          ),
          endDrawer: constraints.maxWidth >= 800
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.homeAnalytics),
                        title: Text('Inicio'),
                        selected: _selectedIndex == 0,
                        onTap: () {
                          Navigator.pop(context);
                          _onItemSelected(0);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.newBox),
                        title: Text('Agregar'),
                        selected: _selectedIndex == 1,
                        onTap: () {
                          Navigator.pop(context);
                          _onItemSelected(1);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.logout),
                        title: const Text('Cerrar Sesion'),
                        selected: _selectedIndex == 2,
                        onTap: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          _onItemSelected(2);
                        },
                      ),
                    ],
                  ),
                ),
          body: Row(
            children: [
              if (constraints.maxWidth >= 800)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(MdiIcons.homeAnalytics),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(MdiIcons.newBox),
                      label: Text('Agregar'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(MdiIcons.logout),
                      label: Text('Cerrar Sesion'),
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
