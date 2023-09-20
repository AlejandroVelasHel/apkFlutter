import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Empaquetado {
   String id;
   String insumo;
   String productoFinal;
   int cantidad;
   DateTime fechaInicio;
   String estado;

  Empaquetado({
    required this.id,
    required this.insumo,
    required this.productoFinal,
    required this.cantidad,
    required this.fechaInicio,
    required this.estado,
  });

  factory Empaquetado.fromJson(Map<String, dynamic> json) {
    return Empaquetado(
      id: json['_id'],
      insumo: json['insumo'],
      productoFinal: json['productoFinal'],
      cantidad: json['cantidad'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      estado: json['estado'],
    );
  }
}

class EmpaquetadosList extends StatefulWidget {
  const EmpaquetadosList({super.key});

  @override
  State<EmpaquetadosList> createState() => _EmpaquetadosListState();
}

class _EmpaquetadosListState extends State<EmpaquetadosList> {
  bool _isLoading = true;
  List<Empaquetado> empaquetados = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url = 'https://coff-v-art-api.onrender.com/api/empaquetado';
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          _isLoading = false;
          empaquetados = (json.decode(res.body)['empaquetados'] as List)
              .map((data) => Empaquetado.fromJson(data))
              .toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _crearInsumo() async {
    try {
      final response = await http.post(
        Uri.parse('https://coff-v-art-api.onrender.com/api/empaquetado'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'insumo': _insumo.text,
          'productoFinal': _productoFinal.text,
          'cantidad': int.parse(_cantidad.text),
          'fechaInicio': _fechaInicio.text,
          'estado': _estado.text,
        }),
      );

      if (response.statusCode == 201) {
        final nuevoEmpaquetado =
            Empaquetado.fromJson(jsonDecode(response.body));
        setState(() {
          empaquetados.add(nuevoEmpaquetado);
          _insumo.clear();
          _productoFinal.clear();
          _cantidad.clear();
          _fechaInicio.clear();
          _estado.clear();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _editarInsumo(Empaquetado empaquetado) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://coff-v-art-api.onrender.com/api/empaquetado/${empaquetado.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          '_id': empaquetado.id,
          'insumo': _insumo.text,
          'productoFinal': _productoFinal.text,
          'cantidad': int.parse(_cantidad.text),
          'fechaInicio': _fechaInicio.text,
          'estado': _estado.text,
        }),
      );

      if (response.statusCode == 200) {
        final empaquetadoActualizado =
            Empaquetado.fromJson(jsonDecode(response.body));
        setState(() {
          empaquetado.insumo = empaquetadoActualizado.insumo;
          empaquetado.productoFinal = empaquetadoActualizado.productoFinal;
          empaquetado.cantidad = empaquetadoActualizado.cantidad;
          empaquetado.fechaInicio = empaquetadoActualizado.fechaInicio;
          empaquetado.estado = empaquetadoActualizado.estado;
          _insumo.clear();
          _productoFinal.clear();
          _cantidad.clear();
          _fechaInicio.clear();
          _estado.clear();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _eliminarInsumo(Empaquetado empaquetado) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://coff-v-art-api.onrender.com/api/empaquetado/${empaquetado.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          empaquetados.remove(empaquetado);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final TextEditingController _insumo = TextEditingController();
  final TextEditingController _productoFinal = TextEditingController();
  final TextEditingController _cantidad = TextEditingController();
  final TextEditingController _fechaInicio = TextEditingController();
  final TextEditingController _estado = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Empaquetados'),
        backgroundColor: Colors.red[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Insumo')),
                  DataColumn(label: Text('Producto Final')),
                  DataColumn(label: Text('Cantidad')),
                  DataColumn(label: Text('Fecha de Inicio')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (var empaquetado in empaquetados)
                    DataRow(
                      cells: [
                        DataCell(Text(empaquetado.insumo)),
                        DataCell(Text(empaquetado.productoFinal)),
                        DataCell(Text(empaquetado.cantidad.toString())),
                        DataCell(Text(
                            empaquetado.fechaInicio.toLocal().toString())),
                        DataCell(Text(empaquetado.estado)),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Editar insumo
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      _insumo.text = empaquetado.insumo;
                                      _productoFinal.text =
                                          empaquetado.productoFinal;
                                      _cantidad.text =
                                          empaquetado.cantidad.toString();
                                      _fechaInicio.text =
                                          empaquetado.fechaInicio.toLocal().toString();
                                      _estado.text = empaquetado.estado;
                                      return AlertDialog(
                                        title: const Text('Editar Empaquetado'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _insumo,
                                              decoration:
                                                  const InputDecoration(labelText: 'Insumo'),
                                            ),
                                            TextFormField(
                                              controller: _productoFinal,
                                              decoration: const InputDecoration(
                                                  labelText: 'Producto Final'),
                                            ),
                                            TextFormField(
                                              controller: _cantidad,
                                              decoration: const InputDecoration(
                                                  labelText: 'Cantidad'),
                                              keyboardType: TextInputType.number,
                                            ),
                                            TextFormField(
                                              controller: _fechaInicio,
                                              decoration:
                                                  const InputDecoration(labelText: 'Fecha de Inicio'),
                                            ),
                                            TextFormField(
                                              controller: _estado,
                                              decoration:
                                                  const InputDecoration(labelText: 'Estado del empaquetado'),
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
                                              _editarInsumo(empaquetado);
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
                                child: const Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Fondo rojo
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Eliminar insumo
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar Empaquetado'),
                                        content:
                                            const Text('¿Estás seguro de que deseas eliminar este empaquetado?'),
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
                                              _eliminarInsumo(empaquetado);
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
                                child: const Text('Eliminar'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Fondo rojo
                                ),
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
              _insumo.clear();
              _productoFinal.clear();
              _cantidad.clear();
              _fechaInicio.clear();
              _estado.clear();
              return AlertDialog(
                title: const Text('Crear Empaquetado'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _insumo,
                      decoration: const InputDecoration(labelText: 'Insumo'),
                    ),
                    TextFormField(
                      controller: _productoFinal,
                      decoration:
                          const InputDecoration(labelText: 'Producto Final'),
                    ),
                    TextFormField(
                      controller: _cantidad,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _fechaInicio,
                      decoration: const InputDecoration(labelText: 'Fecha de Inicio'),
                    ),
                    TextFormField(
                      controller: _estado,
                      decoration: const InputDecoration(labelText: 'Estado'),
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
                      _crearInsumo();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Crear Empaquetado'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Fondo rojo
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red, // Fondo rojo
      ),
    );
  }
}