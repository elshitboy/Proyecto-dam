import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetalleEvento extends StatelessWidget {
  final String eventoId;

  const DetalleEvento({super.key, required this.eventoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00838F),
        title: Text(
          'Detalle del Evento',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('eventos')
            .doc(eventoId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF00838F)),
            );
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;

          var fechaHora = (data['fechaHora'] as Timestamp).toDate();
          String fecha = DateFormat('dd/MM/yyyy').format(fechaHora);
          String hora = DateFormat('HH:mm').format(fechaHora);

          return Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['titulo'] ?? 'Sin título',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00838F),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDetailRow(
                    icon: MdiIcons.account,
                    label: 'Autor',
                    value: data['autor'] ?? 'Desconocido',
                  ),
                  SizedBox(height: 16),
                  _buildDetailRow(
                    icon: MdiIcons.calendar,
                    label: 'Fecha',
                    value: fecha,
                  ),
                  SizedBox(height: 16),
                  _buildDetailRow(
                    icon: MdiIcons.timer,
                    label: 'Hora',
                    value: hora,
                  ),
                  SizedBox(height: 16),
                  _buildDetailRow(
                    icon: MdiIcons.mapMarker,
                    label: 'Lugar',
                    value: data['lugar'] ?? 'Sin lugar',
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00838F),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Volver al Inicio',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF00838F), size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
