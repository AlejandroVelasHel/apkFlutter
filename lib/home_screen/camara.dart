import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar fotos'),
         backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botón para tomar una foto
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Tomar foto'),
            ),
            // Imagen tomada
            if (_image != null) Image.file(_image!),
          ],
        ),
      ),
    );
  }

  // Tomar una foto
  Future<void> _takePhoto() async {
    // Obtener la imagen tomada
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return; // Se canceló la operación

    // Guardar la imagen en el dispositivo
    setState(() {
      _image = File(image.path);
    });
  }
}
