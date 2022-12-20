import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // you can change this to what you want
import 'package:location/location.dart' as locator;

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Completer<GoogleMapController> controller1;

  late LatLng _initialPosition;
  final Set<Marker> _markers = {};

  late LatLng _lastMapPosition = _initialPosition;

  void _getUserLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.best);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          markers: _markers,
          mapType: _currentMapType,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 14.4746,
          ),
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: true,
          onCameraMove: _onCameraMove,
          myLocationEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          bottom: 80,
          left: 20,
          right: 20,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Color(0xff2EC1EF),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            child: Text(
              'Teleport me to somewhere random',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Color(0xff9A2EEF),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            child: Text('Bring me back home',
                style: TextStyle(color: Colors.white)),
            onPressed: () {},
          ),
        ),
      ],
    ));
  }
}
