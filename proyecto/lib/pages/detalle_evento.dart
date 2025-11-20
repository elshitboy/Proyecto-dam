import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetalleEvento extends StatelessWidget {
  const DetalleEvento({super.key});

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
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Título del Evento',
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
                value: 'Nombre del Autor',
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: MdiIcons.calendar,
                label: 'Fecha',
                value: '20/11/2025',
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: MdiIcons.timer,
                label: 'Hora',
                value: '14:30',
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: MdiIcons.mapMarker,
                label: 'Lugar',
                value: 'Ubicación del evento',
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
                  color: Colors.grey,
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
