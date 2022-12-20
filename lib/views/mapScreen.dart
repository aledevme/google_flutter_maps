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
  late Completer<GoogleMapController> controller1 = Completer();

  late LatLng _initialPosition;
  final Set<Marker> _markers = {};

  bool isOpenDialog = false;

  LatLng newYorkPosition = LatLng(40.78343, -73.96625);

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
            zoom: 20.4746,
          ),
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: false,
          onCameraMove: _onCameraMove,
          myLocationEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          bottom: 120,
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
            onPressed: () async {
              GoogleMapController controller = await controller1.future;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: newYorkPosition,
                zoom: 14,
              )));
              setState(() {});
            },
          ),
        ),
        Positioned(
          bottom: 80,
          left: 20,
          right: 20,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Color(0xff9A2EEF),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            child: Text('Bring me back home',
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              _getUserLocation();
              GoogleMapController controller = await controller1.future;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: _initialPosition,
                zoom: 14,
              )));
              setState(() {});
            },
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
            child: Text(isOpenDialog ? 'Close information' : 'Show information',
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              setState(() {
                isOpenDialog = !isOpenDialog;
              });
            },
          ),
        ),
        isOpenDialog
            ? Positioned(
                bottom: 300,
                left: 40,
                right: 40,
                top: 200,
                child: Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.grey.withOpacity(0.6),
                  child: Column(
                    children: [
                      Text(
                        'Current Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Latitude ${_initialPosition.latitude}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Longitude ${_initialPosition.longitude}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Previous Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Latitude ${newYorkPosition.latitude}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Longitude ${newYorkPosition.longitude}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ))
            : Container(),
      ],
    ));
  }
}
