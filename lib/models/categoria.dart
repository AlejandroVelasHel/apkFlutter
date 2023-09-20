import 'dart:convert';

DataModel2 dataModelFromJson(String str) => DataModel2.fromJson(json.decode(str));

String dataModelToJson(DataModel2 data) => json.encode(data.toJson());



class DataModel2 {
  DataModel2({
    required this.categorias
  });
  
  List<Categoria> categorias;

  factory DataModel2.fromJson(Map<String, dynamic> json)=> DataModel2(
    categorias: List<Categoria>.from(json["categorys"].map((x)=> Categoria.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "categorys": List<dynamic>.from(categorias.map((x)=> x.toJson()))
  };
}

class Categoria {
  final String id;
  String nombre;
  String descripcion;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "descripcion": descripcion,
      };
}