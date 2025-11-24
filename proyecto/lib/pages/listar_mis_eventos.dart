import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/pages/detalle_evento.dart';
import 'package:proyecto/pages/eventos_tile.dart';
import 'package:proyecto/services/fb_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListarMisEventos extends StatefulWidget {
  const ListarMisEventos({super.key});

  @override
  State<ListarMisEventos> createState() => _ListarMisEventosState();
}

class _ListarMisEventosState extends State<ListarMisEventos> {
  Future<void> refrescar() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final emailActual = FirebaseAuth.instance.currentUser!.email;

    return RefreshIndicator(
      onRefresh: () => refrescar(),
      color: Color(0xFFFFFFFF),
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
        padding: EdgeInsets.all(5),
        child: StreamBuilder(
          stream: FsService().eventosUsuarioAct(emailActual!),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFFFFFFFF)),
              );
            }

            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.inbox,
                      size: 80,
                      color: Color(0xFFFFFFFF).withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tienes eventos registrados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Crea tu primer evento presionando el botón +',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFFFFF).withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Color(0xFFFFFFFF).withValues(alpha: 0.2),
                thickness: 1,
                height: 1,
              ),
              padding: EdgeInsets.only(bottom: 15),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var evento = docs[index];               

                return Dismissible(
                  key: Key(evento.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Color(0xFFFF2020),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(13),
                    child: Icon(MdiIcons.trashCan, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirmar eliminación"),
                        content: Text(
                          "¿Estás seguro de que deseas eliminar este evento?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(false),
                            child: Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(true),
                            child: Text("Eliminar"),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    await FsService().borrarEventoPorId(evento.id);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${evento['titulo']} eliminado'),
                        backgroundColor: Color(0xFFB22222),
                      ),
                    );
                  },
                  child: EventoListTile(
                  evento: evento,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleEvento(evento: evento),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}