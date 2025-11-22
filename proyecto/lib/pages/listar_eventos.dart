import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/pages/detalle_evento.dart';
import 'package:proyecto/pages/eventos_tile.dart';
import 'package:proyecto/services/fb_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListarEventos extends StatefulWidget {
  const ListarEventos({super.key});

  @override
  State<ListarEventos> createState() => _ListarEventosState();
}

class _ListarEventosState extends State<ListarEventos> {
  Future<void> refrescar() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refrescar(),
      child: Container(
        padding: EdgeInsets.all(5),
        child: StreamBuilder(
          stream: FsService().eventos(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFF00838F)),
              );
            }
      
            var docs = snapshot.data!.docs;
      
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var evento = docs[index];
      
                return evento['autor'] == FirebaseAuth.instance.currentUser!.email ? Dismissible(
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
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Eliminar"),
                          ),
                        ],
                      ),
                    );
                  },
      
                  onDismissed: (direction) async {
                    // Validación por seguridad
                    if (!evento.exists) return;
      
                    await FsService().borrarEventoPorId(evento.id);
      
                    if (!mounted) return;
      
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${evento['titulo']} eliminado'),
                        backgroundColor: Color(0xFF00838F),
                      ),
                    );
                  },
      
                  child: EventoListTile(
                    evento: evento,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleEvento(evento: evento),
                        ),
                      );
                    },
                  ),
                ) 
                : 
                EventoListTile(
                  evento: evento,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          DetalleEvento(evento: evento),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
