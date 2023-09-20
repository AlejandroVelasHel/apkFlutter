
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pay {
  String id;
  int numeroContrato;
  double montoPagado;
  DateTime fechaPago;

  Pay({
    required this.id,
    required this.numeroContrato,
    required this.montoPagado,
    required this.fechaPago,
  });

  factory Pay.fromJson(Map<String, dynamic> json) {
    return Pay(
      id: json['_id'],
      numeroContrato: json['numeroContrato'],
      montoPagado: json['montoPagado'].toDouble(),
      fechaPago: DateTime.parse(json['fechaPago']),
    );
  }
}

class PayList extends StatefulWidget {
  const PayList({Key? key}) : super(key: key);

  @override
  State<PayList> createState() => _PayListState();
}

class _PayListState extends State<PayList> {
  bool _isLoading = true;
  List<Pay> payments = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url = 'https://coff-v-art-api.onrender.com/api/pay';
      http.Response res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(res.body);
        final List<dynamic> paysList = responseBody['pays'];

        setState(() {
          _isLoading = false;
          payments = paysList
              .map((data) => Pay.fromJson(data))
              .toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final TextEditingController _numeroContrato = TextEditingController();
  final TextEditingController _montoPagado = TextEditingController();
  Pay? _selectedPayment; // Nuevo campo para almacenar el pago seleccionado

  _createPayment() async {
    try {
      final response = await http.post(
        Uri.parse('https://coff-v-art-api.onrender.com/api/pay'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'numeroContrato': int.parse(_numeroContrato.text),
          'montoPagado': double.parse(_montoPagado.text),
        }),
      );

      if (response.statusCode == 201) {
        final nuevoPago = Pay.fromJson(jsonDecode(response.body));
        setState(() {
          payments.add(nuevoPago);
          _numeroContrato.clear();
          _montoPagado.clear();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _editPayment(Pay payment) async {
    try {
      final response = await http.put(
        Uri.parse('https://coff-v-art-api.onrender.com/api/pay/${payment.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'numeroContrato': payment.numeroContrato,
          'montoPagado':payment.montoPagado,
          'fechaPago': payment.fechaPago.toIso8601String(), 
        }),
      );

      if (response.statusCode == 200) {
        final updatedPayment = Pay.fromJson(jsonDecode(response.body));
        setState(() {
        // Actualizar el pago en la lista
        payment.montoPagado = updatedPayment.montoPagado;
        payment.fechaPago = updatedPayment.fechaPago;

        // Limpiar los campos de texto
        _numeroContrato.clear();
        _montoPagado.clear();
        _selectedPayment = null;
      });
    }
  } catch (e) {
    debugPrint('Error al editar el pago: $e');
  }
}

  _deletePayment(Pay payment) async {
    try {
      final response = await http.delete(
        Uri.parse('https://coff-v-art-api.onrender.com/api/pay/${payment.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          payments.remove(payment); 
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
        title: const Text('Lista Pagos'),
        backgroundColor: Colors.red[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Número de Contrato')),
                  DataColumn(label: Text('Monto Pagado')),
                  DataColumn(label: Text('Fecha de Pago')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (var payment in payments)
                    DataRow(
                      cells: [
                        DataCell(Text(payment.numeroContrato.toString())),
                        DataCell(Text(payment.montoPagado.toStringAsFixed(2))),
                        DataCell(Text(payment.fechaPago.toLocal().toString())),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Editar pago
                                  _selectedPayment = payment;
                                  _numeroContrato.text =
                                      payment.numeroContrato.toString();
                                  _montoPagado.text =
                                      payment.montoPagado.toString();
                                },
                                child: const Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Fondo rojo
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Eliminar pago
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar Pago'),
                                        content: const Text(
                                            '¿Estás seguro de que deseas eliminar este pago?'),
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
                                              _deletePayment(payment);
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
              return AlertDialog(
                title: const Text('Registrar Pago'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _numeroContrato,
                      decoration: const InputDecoration(
                        labelText: 'Número de Contrato',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _montoPagado,
                      decoration: const InputDecoration(
                        labelText: 'Monto Pagado',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
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
                      if (_selectedPayment == null) {
                        _createPayment();
                      } else {
                        _editPayment(_selectedPayment!);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(_selectedPayment == null
                        ? 'Registrar Pago'
                        : 'Editar Pago'),
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