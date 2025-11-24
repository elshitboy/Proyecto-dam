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
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 0,
              color: Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(evento['titulo']),
                subtitle: Text("Cargando..."),
              ),
            ),
          );
        }

        var categoria = snapshot.data!;
        DateTime fecha = (evento['fechaHora'] as Timestamp).toDate();
        String fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(fecha);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withValues(alpha: 0.15),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Color(0xFFFFFFFF).withValues(alpha: 0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF00838F), width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/categorias/${categoria['foto']}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                evento['titulo'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF000000),
                ),
              ),
              subtitle: Text(
                "${categoria['nombre']} - $fechaFormateada",
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 13,
                ),
              ),
              trailing: Icon(MdiIcons.chevronRight, color: Color(0xFF00838F), size: 24),
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
}
