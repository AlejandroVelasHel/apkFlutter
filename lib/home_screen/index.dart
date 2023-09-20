import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen/camara.dart';
import 'package:flutter_application_1/home_screen/categorias.dart';
import 'package:flutter_application_1/home_screen/empaquetado.dart';
import 'package:flutter_application_1/home_screen/localizacion.dart';
import 'package:flutter_application_1/home_screen/pay.dart';
class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final List<Module> modules = [
    Module(
      icon: Icons.money,
      name: 'Pagos',
      route: const PayList(),
    ),
    Module(
      icon: Icons.list,
      name: 'Empaquetados',
      route: const EmpaquetadosList(),
    ),
    Module(
      icon: Icons.list_alt,
      name: 'Categorias',
      route: const CategoriaList(),
    ),
    Module(
      icon: Icons.camera,
      name: 'Camara',
      route: const MyHomePage(),
    ),
    Module(
      icon: Icons.gps_fixed_outlined,
      name: 'GPS',
      route: const LocationView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Colors.red[700],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.5),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return ModuleCard(module: modules[index]);
        },
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final Module module;

  ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => module.route));
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(module.icon, size: 40),
            Text(module.name),
          ],
        ),
      ),
    );
  }
}

class Module {
  final IconData icon;
  final String name;
  final Widget route;

  Module({
    required this.icon,
    required this.name,
    required this.route,
  });
}