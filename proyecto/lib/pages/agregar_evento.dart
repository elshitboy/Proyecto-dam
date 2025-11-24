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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF00838F),
              onPrimary: Color(0xFFFFFFFF),
              onSurface: Color(0xFF000000),
            ),
          ),
          child: child!,
        );
      },
    );

    if (fechaSeleccionada == null) return;

    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF00838F),
              onPrimary: Color(0xFFFFFFFF),
              onSurface: Color(0xFF000000),
            ),
          ),
          child: child!,
        );
      },
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
      _fechaHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(fechaFinal);
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
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D47A1), // Azul profundo
            Color(0xFF1565C0), // Azul medio
            Color(0xFF0277BD), // Cian azulado
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(child: CircularProgressIndicator(color: Color(0xFFFFFFFF)))
      );
    }

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
                  child: Icon(MdiIcons.calendarPlus, color: Color(0xFFFFFFFF), size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  'Nuevo Evento',
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // Azul profundo
              Color(0xFF1565C0), // Azul medio
              Color(0xFF0277BD), // Cian azulado
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withValues(alpha:0.35),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Color(0xFF0D47A1).withValues(alpha:0.15),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  color: Color(0xFFFFFFFF).withValues(alpha:0.98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _header(),
                          SizedBox(height: 20),
                          _campoTitulo(),
                          SizedBox(height: 18),
                          _campoFechaHora(context),
                          SizedBox(height: 18),
                          _campoLugar(),
                          SizedBox(height: 18),
                          _campoCategoria(),
                          SizedBox(height: 30),
                          _botonGuardar(context),
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
  }

  Widget _header() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1565C0).withValues(alpha:0.4),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(MdiIcons.plusBox, color: Color(0xFFFFFFFF), size: 30),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Registrar Nuevo Evento",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D47A1),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(
          color: Color(0xFF1565C0).withValues(alpha:0.2),
          thickness: 1.5,
        ),
      ],
    );
  }

  Widget _campoTitulo() {
    return TextFormField(
      controller: _tituloController,
      decoration: _inputEstilo("Título", MdiIcons.text),
      validator: (value) =>
          value == null || value.isEmpty ? "Ingrese un título" : null,
    );
  }

  Widget _campoFechaHora(BuildContext context) {
    return TextFormField(
      controller: _fechaHoraController,
      readOnly: true,
      onTap: () => _seleccionarFechaHora(context),
      decoration: _inputEstilo("Fecha y hora", MdiIcons.calendarClock,
          suffix: Icon(Icons.keyboard_arrow_down)),
      validator: (value) =>
          value == null || value.isEmpty ? "Seleccione fecha y hora" : null,
    );
  }

  Widget _campoLugar() {
    return TextFormField(
      controller: _lugarController,
      decoration: _inputEstilo("Lugar", MdiIcons.mapMarker),
      validator: (value) =>
          value == null || value.isEmpty ? "Ingrese el lugar" : null,
    );
  }

  Widget _campoCategoria() {
    return DropdownButtonFormField<String>(
      initialValue: _categoriaSeleccionada,
      items: _categorias!.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nombre'], style: TextStyle(fontSize: 16)),
        );
      }).toList(),
      onChanged: (valor) => setState(() => _categoriaSeleccionada = valor),
      decoration: _inputEstilo("Categoría", MdiIcons.tag),
      validator: (value) => value == null ? "Seleccione una categoría" : null,
    );
  }

  InputDecoration _inputEstilo(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF1565C0)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Color(0xFFF8FBFF),
      labelStyle: TextStyle(
        color: Color(0xFF455A64),
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: Color(0xFFB0BEC5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFE3F2FD), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFE3F2FD), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFF1565C0), width: 2.5),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  Widget _botonGuardar(BuildContext context) {
    return SizedBox(
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
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final titulo = _tituloController.text.trim();
            final fecha = _fechaHoraReal!;
            final lugar = _lugarController.text.trim();
            final categoria = _categoriaSeleccionada!;

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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

            _formKey.currentState!.reset();
            _tituloController.clear();
            _fechaHoraController.clear();
            _lugarController.clear();
            _categoriaSeleccionada = null;

            FsService().agregarEvento(titulo, fecha, lugar, categoria);
          },
          icon: Icon(MdiIcons.contentSave, color: Color(0xFFFFFFFF)),
          label: Text("Guardar", style: TextStyle(color:Color(0xFFFFFFFF))),
        ),
      ),
    );
  }
}