import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

typedef selectFunc = void Function(String);
class MapTest extends StatefulWidget {
  MapTest({this.onSelected});

  final selectFunc onSelected;
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(37.26222, 127.02889);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(37.26222, 127.02889),
    tilt: 59.440,
    zoom: 11.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed(){
    String now_loc = _lastMapPosition.toString();
    String title = "This is a title";
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(now_loc),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: title,
          snippet: "This is snippet",
        ),
        onTap: (){
          print(now_loc);
          widget.onSelected(title);
          Navigator.pop(context);
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Widget button(Function function, IconData icon, index) {
    return FloatingActionButton(
      heroTag:"btn$index",
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
          GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      button(_onMapTypeButtonPressed, Icons.map, 1),
                      SizedBox(height: 16.0),
                      button(_onAddMarkerButtonPressed, Icons.add_location, 2),
                      SizedBox(height: 16.0),
                      button(_goToPosition1, Icons.location_searching, 3),
                    ],
                  )
              )
          )


        ]
        )
    );
  }
}
