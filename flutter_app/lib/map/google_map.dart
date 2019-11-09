import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:gteams/util/customGeocoder.dart';
import 'package:gteams/map/tempStadium.dart';   // just for testing

typedef selectFunc = void Function(String);

const kGoogleApiKey = '';
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
  PageController _pageController;
  int prevPage;


  @override
  void initState(){
    super.initState();
    tempStadiums.forEach((element){
      String nowLoc = [
        element.locationCoords.latitude.toStringAsFixed(6),
        element.locationCoords.longitude.toStringAsFixed(6)
      ].toString();
      _markers.add(Marker(
        markerId: MarkerId(nowLoc),
        draggable: false,
        infoWindow:
          InfoWindow(title: element.shopName, snippet: element.address),
        position: element.locationCoords
      ));
      _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    });
  }

  void _onScroll(){
    if(_pageController.page.toInt() != prevPage){
      prevPage = _pageController.page.toInt();
      _goToNewPosition(makePosition(tempStadiums[prevPage].locationCoords));
    }
  }

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
      _lastMapPosition.longitude.toStringAsFixed(6)
    ].toString();
    String title = "This is a title";
    double latitude = _lastMapPosition.latitude;
    double longtitude = _lastMapPosition.longitude;
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
          final coordinates = new Coordinates(latitude, longtitude);
          /*Geocoder.google(kGoogleApiKey, language: 'kr').findAddressesFromCoordinates(coordinates).then((addresses){
            var first = addresses.first;
            print("${first.featureName} : ${first.addressLine}");
          });*/
          NewGeocoder(kGoogleApiKey, language: 'ko-KR,ko;')
              .findAddressFromCoordinates(coordinates)
              .then((results) {
            var first = results.first;
            print("${first.featureName} : ${first.addressLine}");
            widget.onSelected(first.addressLine);
            Navigator.pop(context);
          });
          // var addresses = await Geocoder.google(kGoogleApiKey).findAddressesFromCoordinates(coordinates);
          // print(addresses);
          /*Geocoder.local.findAddressesFromCoordinates(coordinates).then((addresses){
            print(addresses);
            var first = addresses.first;
            print("${first.featureName} : ${first.addressLine}");
            widget.onSelected(title);
            Navigator.pop(context);
          });*/
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  _onAddMarkerButtonPressed2() {
    String nowLoc = [
      _lastMapPosition.latitude.toStringAsFixed(6),
      _lastMapPosition.longitude.toStringAsFixed(6)
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

  _stadiumList(index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget){
        double value = 1;
        if (_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = ( 1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 300.0,
            width: Curves.easeInOut.transform(value) * 500.0,
            child: widget,
          ),
        );
      },

      child: InkWell(
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 125.0,
                width: 275.0,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(1.0),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 10.0),
                      blurRadius: 10.0,
                    ),
                  ],
                  border: Border(
                    bottom: BorderSide(color: Color(0xff3B5998), width: 2.0),
                    left: BorderSide(color: Color(0xff3B5998), width: 2.0),
                    right: BorderSide(color: Color(0xff3B5998), width: 2.0),
                    top:  BorderSide(color: Color(0xff3B5998), width: 2.0)
                  )
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                  child: Row(
                    children:[
                      SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Container(
                            width: 250.0,
                            child: Text(
                                tempStadiums[index].shopName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff3B5998),
                                    fontSize: 22.5,
                                    fontWeight: FontWeight.bold
                                )
                            )
                          ),
                          Container(
                            width: 250.0,
                            child:Text(
                                tempStadiums[index].address,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                )
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.blueGrey),
                                  )
                              )
                          ),
                          Container(
                            width: 250.0,
                            child: Text(
                              tempStadiums[index].description,
                              overflow: TextOverflow.ellipsis,
                              maxLines:3,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400
                              )
                            ),
                      )]
                      )
                    ]
                  )
                )
              )
            )
          ]
        )
      )
    );
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
          Positioned(
            bottom: 20.0,
            child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: tempStadiums.length,
                itemBuilder: (BuildContext context, int index){
                  return _stadiumList(index);
                }
              )
            )
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(alignment: Alignment.topRight, child: mapButtons()))
        ]));
  }
}
