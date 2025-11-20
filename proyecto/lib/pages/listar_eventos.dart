import 'package:flutter/material.dart';
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
              return EventoListTile(
                evento: evento,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetalleEvento()),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
