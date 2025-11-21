import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/services/fb_services.dart'; //para formatear la fecha y hora

class AgregarProducto extends StatefulWidget {
  const AgregarProducto({super.key});

  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _fechaHoraController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  String? _categoriaSeleccionada;

  final TextEditingController _autor =
      TextEditingController(); // Simula usuario actual

  Future<void> _seleccionarFechaHora(BuildContext context) async {
    // Seleccionar la fecha
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      // Seleccionar la hora
      final TimeOfDay? horaSeleccionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (horaSeleccionada != null) {
        final DateTime fechaHoraFinal = DateTime(
          fechaSeleccionada.year,
          fechaSeleccionada.month,
          fechaSeleccionada.day,
          horaSeleccionada.hour,
          horaSeleccionada.minute,
        );

        final String fechaFormateada = DateFormat(
          'dd/MM/yyyy HH:mm',
        ).format(fechaHoraFinal);

        setState(() {
          _fechaHoraController.text = fechaFormateada;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FsService().categorias(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF00838F)),
          );
        }
        List<DropdownMenuItem<String>> items = snapshot.data!.docs.map((doc) {
          return DropdownMenuItem<String>(
            value: doc.id, // Guardas el ID real de la categoría
            child: Text(doc['nombre']),
          );
        }).toList();

        return Container(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB22222), Color(0xFF051E34)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF051E34),
                                            Color(0xFF00838F),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        MdiIcons.plusBox,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Nuevo Producto",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // TÍTULO
                              TextFormField(
                                controller: _tituloController,
                                decoration: InputDecoration(
                                  labelText: "Título",
                                  prefixIcon: Icon(MdiIcons.text),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "Ingrese un título"
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // FECHA Y HORA (selector)
                              TextFormField(
                                controller: _fechaHoraController,
                                readOnly: true,
                                onTap: () => _seleccionarFechaHora(context),
                                decoration: InputDecoration(
                                  labelText: "Fecha y hora",
                                  prefixIcon: Icon(MdiIcons.calendarClock),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "Seleccione fecha y hora"
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // LUGAR
                              TextFormField(
                                controller: _lugarController,
                                decoration: InputDecoration(
                                  labelText: "Lugar",
                                  prefixIcon: Icon(MdiIcons.mapMarker),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "Ingrese el lugar"
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // CATEGORÍA
                              DropdownButtonFormField<String>(
                                initialValue: _categoriaSeleccionada,
                                items: items,
                                onChanged: (valor) {
                                  setState(() {
                                    _categoriaSeleccionada = valor;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Categoría",
                                  prefixIcon: Icon(MdiIcons.tag),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) => value == null
                                    ? "Seleccione una categoría"
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // AUTOR
                              TextFormField(
                                controller: _autor,
                                decoration: InputDecoration(
                                  labelText: "Autor",
                                  prefixIcon: Icon(MdiIcons.account),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // BOTÓN GUARDAR (gradient)
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF00838F),
                                        Color(0xFFB22222),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await FsService().agregarEvento(
                                          titulo: _tituloController.text,
                                          fechaHora: DateFormat(
                                            'dd/MM/yyyy HH:mm',
                                          ).parse(_fechaHoraController.text),
                                          lugar: _lugarController.text,
                                          categoriaId: _categoriaSeleccionada!,
                                          autor: _autor.text,
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Producto agregado correctamente",
                                            ),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(
                                      MdiIcons.contentSave,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Guardar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
