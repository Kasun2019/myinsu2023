import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocView extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapLocView({required this.latitude, required this.longitude});

  @override
  _MapLocViewState createState() => _MapLocViewState();
}

class _MapLocViewState extends State<MapLocView> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Lat:'+widget.latitude.toString()+"Lng:"+widget.longitude.toString()),
        
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('MarkerID'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(
              title: 'Your Location',
            ),
          ),
        },
      ),
    );
  }
}
