import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Componentes/input.dart';
import 'package:flutter_application_1/models/categoria.dart';
import 'package:http/http.dart' as http;

Future<AlbumC> createAlbum(String nombre, String descripcion) async {
  final response = await http.post(
    Uri.parse('https://coff-v-art-api.onrender.com/api/categoria'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nombre': nombre,
      'descripcion': descripcion,
    }),
  );

  if (response.statusCode == 201) {
    return AlbumC.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class AlbumC {
  final String id;
  final String nombre;
  final String descripcion;

  const AlbumC({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory AlbumC.fromJson(Map<String, dynamic> json) {
    return AlbumC(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}

class Categorias extends StatefulWidget {
  const Categorias({Key? key}) : super(key: key);

  @override
  State<Categorias> createState() {
    return _CategoriasState();
  }
}

class _CategoriasState extends State<Categorias> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();

  Future<AlbumC>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Categoria'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputCampo(
          label: "Nombre: ",
          controller: _nombre,
          obscureText: false,
          validator: (value) => value!.isEmpty ? "Ingrese el nombre" : null,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 10),
        InputCampo(
          label: "Descripción: ",
          controller: _descripcion,
          obscureText: false,
          validator: (value) =>
              value!.isEmpty ? "Ingrese la descripción" : null,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_nombre.text, _descripcion.text);
            });
          },
          child: const Text('Crear Categoria'),
        ),
      ],
    );
  }

  FutureBuilder<AlbumC> buildFutureBuilder() {
    return FutureBuilder<AlbumC>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.nombre);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class CategoriaList extends StatefulWidget {
  const CategoriaList({Key? key}) : super(key: key);

  @override
  State<CategoriaList> createState() => _CategoriaListState();
}

class _CategoriaListState extends State<CategoriaList> {
  bool _isLoading = true;

  List<Categoria> categorias = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url = 'https://coff-v-art-api.onrender.com/api/categoria';
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          _isLoading = false;
          categorias = DataModel2.fromJson(json.decode(res.body)).categorias;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _crearCategoria() async {
    try {
      final response = await http.post(
        Uri.parse('https://coff-v-art-api.onrender.com/api/categoria'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
        }),
      );

      if (response.statusCode == 201) {
        final nuevaCategoria = Categoria.fromJson(jsonDecode(response.body));
        setState(() {
          categorias.add(nuevaCategoria);
          _nombreController.clear();
          _descripcionController.clear();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _editarCategoria(Categoria categoria) async {
    try {
      final response = await http.put(
        Uri.parse('https://coff-v-art-api.onrender.com/api/categoria'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "_id": categoria.id,
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
        }),
      );

      if (response.statusCode == 200) {
        final categoriaActualizada =
            Categoria.fromJson(jsonDecode(response.body));
        setState(() {
          categoria.nombre = categoriaActualizada.nombre;
          categoria.descripcion = categoriaActualizada.descripcion;
          _nombreController.clear();
          _descripcionController.clear();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _eliminarCategoria(Categoria categoria) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://coff-v-art-api.onrender.com/api/categoria/${categoria.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          categorias.remove(categoria);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Lista Categorias')),
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      width: 100, // Ajusta el tamaño según tus necesidades
                      child: Text('Nombre'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 200, // Ajusta el tamaño según tus necesidades
                      child: Text('Descripción'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100, // Ajusta el tamaño según tus necesidades
                      child: Text('Acciones'),
                    ),
                  ),
                ],
                rows: [
                  for (var categoria in categorias)
                    DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width:
                                100, // Ajusta el tamaño según tus necesidades
                            child: Text(categoria.nombre),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width:
                                200, // Ajusta el tamaño según tus necesidades
                            child: Text(categoria.descripcion),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      _nombreController.text = categoria.nombre;
                                      _descripcionController.text =
                                          categoria.descripcion;
                                      return AlertDialog(
                                        title: const Text('Editar Categoría'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _nombreController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Nombre'),
                                            ),
                                            TextFormField(
                                              controller:
                                                  _descripcionController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Descripción'),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancelar'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red, // Fondo rojo
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _editarCategoria(categoria);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Guardar'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red, // Fondo rojo
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Fondo rojo
                                ),
                                child:
                                    const Icon(Icons.edit, color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar Categoría'),
                                        content: const Text(
                                            '¿Estás seguro de que deseas eliminar esta categoría?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancelar'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red, // Fondo rojo
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _eliminarCategoria(categoria);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Eliminar'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red, // Fondo rojo
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Fondo rojo
                                ),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              _nombreController.clear();
              _descripcionController.clear();
              return AlertDialog(
                title: const Text('Crear Categoría'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    TextFormField(
                      controller: _descripcionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ), // Fondo rojo
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _crearCategoria();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Crear'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ), // Fondo rojo
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}