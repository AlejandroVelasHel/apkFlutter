import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen/index.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 252, 251), // Fondo gris
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        '../asset/burdeo_logo.png', // Ruta de tu imagen de logo
                        height: 120,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.red), // Texto en rojo
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white, // Fondo blanco
                            border: OutlineInputBorder(),
                            labelText: "Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.red), // Texto en rojo
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white, // Fondo blanco
                            border: OutlineInputBorder(),
                            labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final route = MaterialPageRoute(
                                builder: (context) => MyList());
                            Navigator.push(context, route);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill input')),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 250, 250), // Fondo gris
    );
  }
}
