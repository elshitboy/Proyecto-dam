import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
	const LoginPage({super.key});

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	TextEditingController emailCtrl = TextEditingController();
	TextEditingController passwordCtrl = TextEditingController();
	String msgError = '';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			resizeToAvoidBottomInset: false,
			body: Container(
				padding: const EdgeInsets.all(20),
				decoration: const BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topRight,
						end: Alignment.bottomLeft,
						colors: [Color(0xFFFFC107), Color(0xFF00838F), Color(0xFF051E34)],
						stops: [0.0, 0.5, 1.0],
					),
				),
				child: Container(
					margin: const EdgeInsets.only(top: 50),
					decoration: BoxDecoration(
						color: const Color(0xAAFFFFFF),
						borderRadius: BorderRadius.circular(15),
					),
					child: Form(
						child: Container(
							margin: const EdgeInsets.symmetric(vertical: 180, horizontal: 20),
							color: Colors.white,
													child: ListView(
												padding: const EdgeInsets.symmetric(vertical: 6),
												children: [
                        // firebase icon
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 8, bottom: 6),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFFC107), Color(0xFFFF6F00), Color(0xFFFFC107)],
                              ),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFFFFC107).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Center(
                              child: Icon(MdiIcons.firebase, color: Colors.white, size: 44),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),													// email
													Container(
														margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
														child: TextFormField(
															controller: emailCtrl,
															keyboardType: TextInputType.emailAddress,
															decoration: InputDecoration(
																prefixIcon: Icon(Icons.email, color: Colors.orange.shade700),
																hintText: 'Email',
																filled: true,
																fillColor: Colors.white,
																contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
																border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFC107), width: 1.5)),
																enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFC107), width: 1.5)),
																focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2)),
															),
														),
													),

													// password
													Container(
														margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
														child: TextFormField(
															controller: passwordCtrl,
															obscureText: true,
															decoration: InputDecoration(
																prefixIcon: Icon(Icons.lock, color: Colors.orange.shade700),
																hintText: 'Password',
																filled: true,
																fillColor: Colors.white,
																contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
																border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFC107), width: 1.5)),
																enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFC107), width: 1.5)),
																focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2)),
															),
														),
													),

													// boton iniciar sesion (mantener lógica Firebase)
													Container(
														margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
														width: double.infinity,
														child: FilledButton(
															style: FilledButton.styleFrom(
																backgroundColor: Colors.white,
																padding: const EdgeInsets.symmetric(vertical: 14),
																shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
															),
															child: Container(
																decoration: const BoxDecoration(
																	gradient: LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFF6F00)]),
																	borderRadius: BorderRadius.all(Radius.circular(8)),
																),
																padding: const EdgeInsets.symmetric(vertical: 6),
																child: const Center(child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
															),
															onPressed: () async {
																try {
																	await FirebaseAuth.instance
																			.signInWithEmailAndPassword(
																				email: emailCtrl.text.trim(),
																				password: passwordCtrl.text.trim(),
																			);
																} on FirebaseAuthException catch (ex) {
																	setState(() {
																		switch (ex.code) {
																			case 'channel-error':
																				msgError = "Ingrese sus credenciales";
																				break;
																			case 'invalid-email':
																				msgError = "Email no válido";
																				break;
																			case 'invalid-credential':
																				msgError = "Credenciales no válidas";
																				break;
																			case 'user-disabled':
																				msgError = "Cuenta desactivada";
																				break;
																			default:
																				msgError = "Error desconodido";
																		}
																	});
																}
															},
														),
													),

													// errores
													if (msgError.isNotEmpty)
														Container(
															width: double.infinity,
															alignment: Alignment.center,
															padding: const EdgeInsets.symmetric(horizontal: 20),
															child: Text(msgError, style: const TextStyle(color: Colors.red)),
														),

													const SizedBox(height: 10),

													// Google sign-in button (visual)
													Container(
														margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
														child: OutlinedButton.icon(
															onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulación: iniciar sesión con Google'))),
															icon: Icon(MdiIcons.google, color: Colors.blue.shade600),
															label: const Text('Continuar con Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
															style: OutlinedButton.styleFrom(
																backgroundColor: Colors.white,
																side: const BorderSide(color: Color(0xFF4285F4), width: 1.5),
																padding: const EdgeInsets.symmetric(vertical: 12),
																shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
															),
														),
													),
												],
											),
						),
					),
				),
			),
		);
	}
}
