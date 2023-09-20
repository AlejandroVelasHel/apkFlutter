import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());


class DataModel {
  DataModel({
    required this.payments
  });
  
  List<Pay> payments;

  factory DataModel.fromJson(Map<String, dynamic> json)=> DataModel(
    payments: List<Pay>.from(json["payments"].map((x)=> Pay.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "payments": List<dynamic>.from(payments.map((x)=> x.toJson()))
  };
}
class Pay {
  final String id;
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


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'numeroContrato': numeroContrato,
      'montoPagado': montoPagado,
      'fechaPago': fechaPago.toIso8601String(),
    };
  }
}
