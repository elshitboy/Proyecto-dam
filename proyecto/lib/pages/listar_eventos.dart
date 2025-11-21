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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: StreamBuilder(
        stream: FsService().eventos(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF00838F)),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var evento = snapshot.data!.docs[index];
              return Dismissible(
                key: Key(evento.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Color(0xFFFF2020),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(13),
                  child: Icon(MdiIcons.trashCan, color: Color(0xFFFFFFFF)),
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
                  await FsService().borrarEventoPorId(evento.id);
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
                      MaterialPageRoute(builder: (context) => DetalleEvento()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
