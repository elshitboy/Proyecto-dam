import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/services/fb_services.dart';


class EventoListTile extends StatelessWidget {
  final QueryDocumentSnapshot evento;
  final VoidCallback onTap;

  const EventoListTile({required this.evento, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FsService().categoriaPorId(evento['categoriaId']),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ListTile(title: Text(evento['titulo']), subtitle: Text("Cargando..."));
        }

        var categoria = snapshot.data!;
        DateTime fecha = (evento['fechaHora'] as Timestamp).toDate();
        String fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(fecha);

        return ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 3),
            ),
            child: ClipOval(child: Image.asset("assets/images/categorias/${categoria['foto']}", fit: BoxFit.cover)),
          ),
          title: Text(evento['titulo']), 
          subtitle: Text("${categoria['nombre']} - ${fechaFormateada}"), 
          trailing: Icon(MdiIcons.chevronRight), 
          onTap: onTap
        );
      },
    );
  }
}
