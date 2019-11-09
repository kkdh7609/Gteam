import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

typedef selectFunc = void Function(String);

const kGoogleApiKey = 'api key';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

enum mapReq { mapCheck, findLocation, newLocation }

class MapTest extends StatefulWidget {
  MapTest({this.onSelected, this.nowReq});

  final selectFunc onSelected;
  final mapReq nowReq;

  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(37.26222, 127.02889);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  String _tempMarker = null;

  static final CameraPosition _position1 = CameraPosition(
    target: _center,
    zoom: 11.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    if (_tempMarker != null) {
      setState(() {
        _markers.remove(Marker(markerId: MarkerId(_tempMarker)));
      });
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  Future<void> _goToNewPosition(CameraPosition newPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  CameraPosition makePosition(LatLng location) {
    return CameraPosition(
      target: location,
      zoom: 17.0,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    String nowLoc = [
      _lastMapPosition.latitude.toStringAsFixed(6),
      _lastMapPosition.latitude.toStringAsFixed(6)
    ].toString();
    String title = "This is a title";
    setState(() {
      if (_tempMarker == nowLoc) {
        _tempMarker = null;
        _markers.remove(Marker(markerId: MarkerId(nowLoc)));
      }
      _markers.add(Marker(
        markerId: MarkerId(nowLoc),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: title,
          snippet: "This is snippet",
        ),
        onTap: () {
          // print(nowLoc);
          widget.onSelected(title);
          Navigator.pop(context);
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  _onAddMarkerButtonPressed2() {
    String nowLoc = [
      _lastMapPosition.latitude.toStringAsFixed(6),
      _lastMapPosition.latitude.toStringAsFixed(6)
    ].toString();

    // print(_markers);
    String title = "This is a title";
    setState(() {
      if (!_markers.contains(Marker(markerId: MarkerId(nowLoc)))) {
        // print(11);
        // print(_lastMapPosition);
        _tempMarker = nowLoc;
        _markers.add(Marker(
          markerId: MarkerId(nowLoc),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: title,
            snippet: "This is snippet",
          ),
          onTap: () {
            // print(nowLoc);
            widget.onSelected(title);
            Navigator.pop(context);
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      }
    });
  }

  _onSearchButtonPressed() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        language: "kr",
        components: [new Component(Component.country, "kr")]);
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      CameraPosition newPosition = makePosition(LatLng(lat, lng));
      _goToNewPosition(newPosition);
      if (_tempMarker != null) {
        _markers.remove(Marker(markerId: MarkerId(_tempMarker)));
      }
      _onCameraMove(newPosition);
      _onAddMarkerButtonPressed2();
    }
  }

  Widget button(Function function, IconData icon, index) {
    return Theme(
        data: ThemeData(primaryColor: Color(0xff3B5998)),
        child: FloatingActionButton(
          heroTag: "btn$index",
          onPressed: function,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Color(0xff3B5998),
          child: Icon(icon, size: 36.0),
        ));
  }

  Widget mapButtons() {
    if (widget.nowReq == mapReq.mapCheck ||
        widget.nowReq == mapReq.findLocation) {
      return Column(
        children: <Widget>[
          button(_onSearchButtonPressed, Icons.search, 0),
          SizedBox(height: 16.0),
          button(_onMapTypeButtonPressed, Icons.map, 1),
          SizedBox(height: 16.0),
          button(_goToPosition1, Icons.location_searching, 2),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          button(_onSearchButtonPressed, Icons.search, 0),
          SizedBox(height: 16.0),
          button(_onMapTypeButtonPressed, Icons.map, 1),
          SizedBox(height: 16.0),
          button(_onAddMarkerButtonPressed, Icons.add_location, 2),
          SizedBox(height: 16.0),
          button(_goToPosition1, Icons.location_searching, 3),
        ],
      );
    }
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
          rotateGesturesEnabled: false,
          mapType: _currentMapType,
          markers: _markers,
          onCameraMove: _onCameraMove),
      Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(alignment: Alignment.topRight, child: mapButtons()))
    ]));
  }
}
