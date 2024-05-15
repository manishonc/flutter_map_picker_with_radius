import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? _controller;
  LatLng _selectedLocation = LatLng(37.42796133580664, -122.085749655962);
  double _radius = 1000;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: '${location.latitude}, ${location.longitude}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _updateCircle();
    });
  }

  void _updateCircle() {
    _circles.clear();
    _circles.add(
      Circle(
        circleId: CircleId(_selectedLocation.toString()),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 400,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: _selectedLocation,
                                zoom: 15,
                              ),
                              onTap: (location) {
                                setState(() {
                                  _onMapTap(location);
                                });
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
                  },
                );
              },
            );
          },
          child: Text('Select Location'),
        ),
      ),
    );
  }
}
