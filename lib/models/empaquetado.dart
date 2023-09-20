// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());


class DataModel {
  DataModel({
    required this.empaquetados
  });
  
  List<Empaquetado> empaquetados;

  factory DataModel.fromJson(Map<String, dynamic> json)=> DataModel(
    empaquetados: List<Empaquetado>.from(json["empaquetados"].map((x)=> Empaquetado.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "empaquetados": List<dynamic>.from(empaquetados.map((x)=> x.toJson()))
  };
}


class Empaquetado {
  String id;
  String insumo;
  String productoFinal;
  int cantidad;
  DateTime fechaInicio;
  bool estado;

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
   Map<String, dynamic> toJson() => {
    '_id': id,
    'insumo': insumo,
    'productoFinal': productoFinal,
    'cantidad': cantidad,
    'fechaInicio': fechaInicio.toIso8601String(), // Convierte la fecha a un formato ISO
    'estado': estado,
  };
}
