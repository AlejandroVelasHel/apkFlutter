class Contract {
  final String nombreEmpresa;
  final int nit;
  final String direccion;
  final String nombreRepresentante;
  final String correoRepresentante;
  final String producto;
  String? comision; // Puede ser nulo
  final String duracion;
  String? cobro; // Puede ser nulo
  final DateTime fecha;
  final String estado;

  Contract({
    required this.nombreEmpresa,
    required this.nit,
    required this.direccion,
    required this.nombreRepresentante,
    required this.correoRepresentante,
    required this.producto,
    this.comision,
    required this.duracion,
    this.cobro,
    required this.fecha,
    required this.estado,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      nombreEmpresa: json['nombreEmpresa'],
      nit: json['NIT']!=null ? json['NIT'] as int : 0,
      direccion: json['direccion'],
      nombreRepresentante: json['nombreRepresentante'],
      correoRepresentante: json['correoRepresentante'],
      producto: json['producto'],
      comision: json['comision'],
      duracion: json['duracion'],
      cobro: json['cobro'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
    );
  }
  Map<String,dynamic>toJson(){
    return{
    'nombreEmpresa': nombreEmpresa,
    'nit': nit,
    'direccion': direccion,
    'nombreRepresentante': nombreRepresentante,
    'correoRepresentante': correoRepresentante,
    'producto': producto,
    'comision': comision,
    'duracion': duracion,
    'cobro': cobro,
    'fecha': fecha.toIso8601String(),
    'estado': estado,
    };
  }
}
