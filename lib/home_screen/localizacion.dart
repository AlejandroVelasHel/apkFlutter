import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late LocationData _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Location location = Location();
      PermissionStatus permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        _currentLocation = await location.getLocation();
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uso del GPS'),
      ),
      body: Center(
        child: _currentLocation != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Latitud: ${_currentLocation.latitude}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Longitud: ${_currentLocation.longitude}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}