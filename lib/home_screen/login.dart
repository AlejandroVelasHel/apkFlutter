
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Componentes/input.dart';
import 'package:flutter_application_1/home_screen/index.dart';
import 'package:flutter_application_1/models/usuarios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginViewComponent extends StatefulWidget {
  const LoginViewComponent({Key? key}) : super(key: key);

  @override
  State<LoginViewComponent> createState() => _LoginViewComponentState();
}

class _LoginViewComponentState extends State<LoginViewComponent> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); // Agregar una clave global para el formulario

  // Correo y contraseña para ingresar
  final String _validEmail = 'correo@ejemplo.com';
  final String _validPassword = '123';

  @override
  void initState() {
    super.initState();
    _getUsuarios();
  }

  DataModelUsuario? _dataModelUsuario;

  _getUsuarios() async {
    _isLoading = true;
    try {
      String url = 'https://coff-v-art-api.onrender.com/api/user';
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        _dataModelUsuario = DataModelUsuario.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        color: Color.fromARGB(192, 255, 253, 224),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asociar el formulario con la clave global
          child: Column(
            children: [
              Image.asset('../assets/burdeo_logo.png'),
              const SizedBox(height: 16.0),
              InputCampo(
                label: 'Correo Electrónico',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  } else if (!value.contains('@')) {
                    return 'Por favor ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              InputCampo(
                label: 'Contraseña',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // validamos credenciales
                    final enteredEmail = _emailController.text.trim();
                    final enteredPassword = _passwordController.text.trim();
                    int positionUsuario = -1;

                    // Search the email and password in the list
                    for (int i = 0;
                        i < _dataModelUsuario!.usuarios.length;
                        i++) {
                      if (_dataModelUsuario!.usuarios[i].email ==
                              enteredEmail &&
                          _dataModelUsuario!.usuarios[i].password ==
                              enteredPassword) {
                        positionUsuario = i;
                        break;
                      }
                    }

                    // If the email and password is correct
                    if (positionUsuario != -1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MyList(),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Correo o contraseña errados')),
                      );
                    }

                    // if (enteredEmail == _validEmail &&
                    //     enteredPassword == _validPassword) {
                    //   Text('Hola');
                    //   // Navigator.of(context).pushReplacement(MaterialPageRoute
                    //   // (builder: (context) => const WelcomeView(),
                    //   // ),
                    //   // );
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //         content: Text('Correo o contraseña errados')),
                    //   );
                    // }
                  }
                },
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}