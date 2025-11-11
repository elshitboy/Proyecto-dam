import 'package:flutter/material.dart';

class AgregarProducto extends StatelessWidget {
  const AgregarProducto({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Página para agregar productos',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
