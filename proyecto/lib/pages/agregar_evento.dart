import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto/services/fb_services.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({super.key});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _fechaHoraController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();

  String? _categoriaSeleccionada;
  DateTime? _fechaHoraReal;

  List<QueryDocumentSnapshot>? _categorias;
  bool _cargandoCategorias = true;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    final snapshot = await FsService().categorias();
    setState(() {
      _categorias = snapshot.docs;
      _cargandoCategorias = false;
    });
  }

  Future<void> _seleccionarFechaHora(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada == null) return;

    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horaSeleccionada == null) return;

    final DateTime fechaFinal = DateTime(
      fechaSeleccionada.year,
      fechaSeleccionada.month,
      fechaSeleccionada.day,
      horaSeleccionada.hour,
      horaSeleccionada.minute,
    );

    setState(() {
      _fechaHoraReal = fechaFinal;
      _fechaHoraController.text =
          DateFormat('dd/MM/yyyy HH:mm').format(fechaFinal);
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _fechaHoraController.dispose();
    _lugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoCategorias) {
      return Center(
        child: CircularProgressIndicator(color: Color(0xFF00838F)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB22222), Color(0xFF051E34)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _header(),

                      const SizedBox(height: 12),

                      _campoTitulo(),
                      const SizedBox(height: 16),

                      _campoFechaHora(context),
                      const SizedBox(height: 16),

                      _campoLugar(),
                      const SizedBox(height: 16),

                      _campoCategoria(),
                      const SizedBox(height: 24),

                      _botonGuardar(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF051E34), Color(0xFF00838F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(MdiIcons.plusBox, color: Colors.white, size: 30),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            "Nuevo Evento",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _campoTitulo() {
    return TextFormField(
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
          value == null || value.isEmpty ? "Ingrese un título" : null,
    );
  }

  Widget _campoFechaHora(BuildContext context) {
    return TextFormField(
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
          value == null || value.isEmpty ? "Seleccione fecha y hora" : null,
    );
  }

  Widget _campoLugar() {
    return TextFormField(
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
          value == null || value.isEmpty ? "Ingrese el lugar" : null,
    );
  }

  Widget _campoCategoria() {
    return DropdownButtonFormField<String>(
      value: _categoriaSeleccionada,
      items: _categorias!.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nombre']),
        );
      }).toList(),
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
      validator: (value) =>
          value == null ? "Seleccione una categoría" : null,
    );
  }

  Widget _botonGuardar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00838F), Color(0xFFB22222)],
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
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            // Guardamos los datos primero en variables locales
            final titulo = _tituloController.text;
            final fecha = _fechaHoraReal!;
            final lugar = _lugarController.text;
            final categoria = _categoriaSeleccionada!;         

            // Muestra confirmación inmediata
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Evento agregado"),
                content: Text("El evento fue agregado correctamente."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  )
                ],
              ),
            );

            // Limpia el formulario
            _formKey.currentState!.reset();
            _tituloController.clear();
            _fechaHoraController.clear();
            _lugarController.clear();
            _categoriaSeleccionada = null;
            
            FsService().agregarEvento(
              titulo,
              fecha,
              lugar,
              categoria,
            );
          },
          icon: Icon(MdiIcons.contentSave, color: Colors.white),
          label: Text("Guardar", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}