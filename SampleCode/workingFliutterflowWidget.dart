// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class LocationPickerRadius extends StatefulWidget {
  const LocationPickerRadius({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LocationPickerRadius> createState() => _LocationPickerRadiusState();
}

class _LocationPickerRadiusState extends State<LocationPickerRadius> {
  gmaps.GoogleMapController? _controller;
  gmaps.LatLng _selectedLocation =
      gmaps.LatLng(37.42796133580664, -122.085749655962);
  double _radius = 1000;
  final Set<gmaps.Marker> _markers = {};
  final Set<gmaps.Circle> _circles = {};

  void _onMapCreated(gmaps.GoogleMapController controller) {
    _controller = controller;
  }

  void _onMapTap(gmaps.LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(location.toString()),
          position: location,
          infoWindow: gmaps.InfoWindow(
            title: 'Selected Location',
            snippet: '${location.latitude}, ${location.longitude}',
          ),
          icon: gmaps.BitmapDescriptor.defaultMarker,
        ),
      );
      _updateCircle();
    });
  }

  void _updateCircle() {
    _circles.clear();
    _circles.add(
      gmaps.Circle(
        circleId: gmaps.CircleId(_selectedLocation.toString()),
        center: _selectedLocation,
        radius: _radius,
        fillColor: Colors.blue.withOpacity(0.5),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Container(
            height: 400,
            child: gmaps.GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: gmaps.CameraPosition(
                target: _selectedLocation,
                zoom: 15,
              ),
              onTap: (location) {
                _onMapTap(location);
              },
              markers: _markers,
              circles: _circles,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected Location: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}',
                ),
                Slider(
                  min: 100,
                  max: 5000,
                  value: _radius,
                  label: _radius.toString(),
                  onChanged: (value) {
                    setState(() {
                      _radius = value;
                      _updateCircle();
                    });
                  },
                ),
                Text('Radius: ${_radius.toInt()} meters'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
