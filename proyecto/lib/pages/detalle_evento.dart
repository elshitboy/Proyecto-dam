import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/services/fb_services.dart';

class DetalleEvento extends StatelessWidget {
  final QueryDocumentSnapshot evento;
  
  const DetalleEvento({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1565C0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF0D47A1).withValues(alpha:0.4),
                blurRadius: 16,
                offset: Offset(0, 8),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Color(0xFF000000).withValues(alpha:0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFFFFF).withValues(alpha:0.15),
                  ),
                  child: Icon(MdiIcons.fileDocument, color: Color(0xFFFFFFFF), size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  'Detalle del Evento',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            leading: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFFFFF).withValues(alpha:0.15),
              ),
              child: IconButton(
                icon: Icon(MdiIcons.arrowLeft, color: Color(0xFFFFFFFF), size: 24),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FsService().categoriaPorId(evento['categoriaId']),        
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF1565C0),
                    Color(0xFF0277BD),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFFFFFF)),
              ),
            );
          }

          var categoria = snapshot.data!;

          var fechaHora = (evento['fechaHora'] as Timestamp).toDate();
          String fecha = DateFormat('dd/MM/yyyy').format(fechaHora);
          String hora = DateFormat('HH:mm').format(fechaHora);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1565C0),
                  Color(0xFF0277BD),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título principal
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha:0.25),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      color: Color(0xFFFFFFFF).withValues(alpha:0.98),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(MdiIcons.formatTitle, color: Color(0xFFFFFFFF), size: 24),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                evento['titulo'] ?? 'Sin título',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tarjeta de detalles
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha:0.25),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      color: Color(0xFFFFFFFF).withValues(alpha:0.98),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              icon: MdiIcons.account,
                              label: 'Autor',
                              value: evento['autor'] ?? 'Desconocido',
                            ),
                            Divider(color: Color(0xFFE3F2FD), thickness: 1.5, height: 24),
                            _buildDetailRow(
                              icon: MdiIcons.calendar,
                              label: 'Fecha',
                              value: fecha,
                            ),
                            Divider(color: Color(0xFFE3F2FD), thickness: 1.5, height: 24),
                            _buildDetailRow(
                              icon: MdiIcons.timer,
                              label: 'Hora',
                              value: hora,
                            ),
                            Divider(color: Color(0xFFE3F2FD), thickness: 1.5, height: 24),
                            _buildDetailRow(
                              icon: MdiIcons.mapMarker,
                              label: 'Lugar',
                              value: evento['lugar'] ?? 'Sin lugar',
                            ),
                            Divider(color: Color(0xFFE3F2FD), thickness: 1.5, height: 24),
                            _buildDetailRow(
                              icon: MdiIcons.tag,
                              label: 'Categoría',
                              value: categoria['nombre'] ?? 'Sin categoría',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Imagen de categoría
                  Center(
                    child: Container(
                      width: 320,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withValues(alpha:0.35),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          "assets/images/categorias/${categoria['foto']}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  // Botón volver
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF1565C0).withValues(alpha:0.35),
                            blurRadius: 14,
                            offset: Offset(0, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: Icon(MdiIcons.arrowLeft, color: Color(0xFFFFFFFF)),
                        label: Text(
                          'Volver al Inicio',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
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
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Color(0xFFFFFFFF), size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF90A4AE),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
