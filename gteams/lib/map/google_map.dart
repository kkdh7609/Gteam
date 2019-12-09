import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:gteams/util/customGeocoder.dart';
import 'package:gteams/map/mapDialog.dart';
import 'package:gteams/map/forSecure.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';

typedef selectFunc = void Function(String,String, String);                 // 경기장 이름, 경기장 id
typedef createFunc = void Function(String, String, double, double);     // 주소, 경기장 id, 좌표값 2개

String kGoogleApiKey = getSecureKey();
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

enum mapReq { mapCheck, findLocation, newLocation }

class MapTest extends StatefulWidget {
  MapTest({this.onSelected, this.nowReq,this.stadiumData,this.stadiumList, this.needData});
  List<StadiumListData> stadiumList;
  final StadiumListData stadiumData; // GameRoom에서 한가지 방정보만 가지고 왔을때..
  final selectFunc onSelected;
  final mapReq nowReq; // mapCheck 는 목록 보임, 클릭시 정보 없음 / findLocation 은 목록 보임, 클릭시 정보 보임 / newLocation 은 목록 보임, 클릭은 좌표 가져오는 것
  final createFunc needData;

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

  bool isAvailable = true;

  @override
  void initState() {
    super.initState();
    if(widget.nowReq != mapReq.newLocation) {
      _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
        ..addListener(_onScroll);
      if (widget.stadiumData != null) {
        widget.stadiumList = [widget.stadiumData];
      }
      widget.stadiumList.asMap().forEach(
              (index, element) {
            element.locationCoords = new LatLng(element.lat, element.lng);
            String nowLoc =
            [element.locationCoords.latitude.toStringAsFixed(6), element.locationCoords.longitude.toStringAsFixed(6)].toString();
            final coordinates = Coordinates(element.locationCoords.latitude, element.locationCoords.longitude);
            _markers.add(Marker(
              markerId: MarkerId(nowLoc),
              draggable: false,
              infoWindow: InfoWindow(title: element.stadiumName, snippet: element.location),
              position: element.locationCoords,
              onTap: () => (widget.nowReq == mapReq.findLocation ? _onMarkerPressed(index) : {}),
            ));
          });
    }
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      _goToNewPosition(makePosition(widget.stadiumList[prevPage].locationCoords));
    }
  }

  static final CameraPosition _position1 = CameraPosition(
    target: _center,
    zoom: 11.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    if (_tempMarker != null) {
      setState(
        () {
          _markers.remove(Marker(markerId: MarkerId(_tempMarker)));
        },
      );
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
    setState(
      () {
        _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
      },
    );
  }

  _doPop(){
    //print(111111);
    //print(context);
    Navigator.pop(context);
    //print(context);
    Navigator.pop(context);
  }

  _onMarkerPressed(index){
    if(isAvailable) {
      isAvailable = false;
      if (_pageController.page.toInt() == index) _goToNewPosition(makePosition(widget.stadiumList[index].locationCoords));
      _pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.ease);

      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(stadiumData: widget.stadiumList[index], onSelected: widget.onSelected, onPop: _doPop,);
          }
      );
      isAvailable = true;
    }
  }

  Widget _alertOKButton(address, locId, lat, lng){
    return FlatButton(
      color: Color(0xff20253d),
      child: Text("OK", style: TextStyle(color:Colors.white, fontFamily:'Dosis')),
      onPressed: (){
        widget.needData(address, locId, lat, lng);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  Widget _alertCancelButton(){
    return FlatButton(
      color: Color(0xff20253d),
      child: Text("Cancel", style: TextStyle(color:Colors.white, fontFamily:'Dosis')),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
  }

  AlertDialog _alertDialog(title, address, lat, lng, locId){
    return AlertDialog(
        title: Text(title),
        content: Text("\'" + address + "\'로 선택하시겠습니까?"),
        actions: <Widget>[
          _alertOKButton(address, locId, lat, lng),
          _alertCancelButton()
        ]
    );
  }

  _showAlertDialog(title, address, lat, lng, locId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _alertDialog(title, address, lat, lng, locId);
        }
    );
  }

  Future<String> _coordToAddress(coordinates) async{
    var results = await NewGeocoder(kGoogleApiKey, language: 'ko-KR,ko;').findAddressFromCoordinates(coordinates);
    var first = results.first;
    return first.addressLine;
  }


  _onAddMarkerButtonPressed() {
    String nowLoc = [_lastMapPosition.latitude.toStringAsFixed(6), _lastMapPosition.longitude.toStringAsFixed(6)].toString();
    String title = "선택된 위치";
    double latitude = _lastMapPosition.latitude;
    double longtitude = _lastMapPosition.longitude;
    String _address;
    setState(
      () {
        _markers.add(
          Marker(
            markerId: MarkerId(nowLoc),
            position: _lastMapPosition,
            infoWindow: InfoWindow(
              title: title,
            ),
            onTap: () {
              if(isAvailable){
                isAvailable = false;

                Coordinates coordinates = Coordinates(latitude, longtitude);
                _coordToAddress(coordinates).then((address){
                  _address = address;
                  _showAlertDialog("주소 확인", _address, latitude, longtitude, nowLoc);
                });
                isAvailable = true;
              }
            },
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      },
    );
  }

  _onSearchButtonPressed() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: kGoogleApiKey, language: "kr", components: [new Component(Component.country, "kr")]);
    displayPrediction(p);
  }

  _stadiumList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 320.0,
            width: Curves.easeInOut.transform(value) * 500.0,
            child: widget,
          ),
        );
      },

      child: _buildContainer(index),
    );
  }

  _buildContainer(int index){
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            //margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: ListView(
              //scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _boxes(
                      widget.stadiumList[index].imagePath,
                      widget.stadiumList[index].locationCoords.latitude, widget.stadiumList[index].locationCoords.longitude,widget.stadiumList[index].stadiumName,index),
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }

  _boxes(String _image, double lat,double long,String stadiumName,int index) {
    //return  GestureDetector(
    return Container(
      child: new FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image)//AssetImage("assets/image/camera.png")//NetworkImage(_image),
                    ),
                  ),),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myDetailsContainer1(stadiumName,index),
                  ),
                ),

              ],)
        ),
      ),
    );
    // );
  }

  myDetailsContainer1(String stadiumName, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(stadiumName,
                style: TextStyle(
                    color: Color(0xff20253d),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Dosis'),
              )),
        ),
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      widget.stadiumList[index].location.substring(0,widget.stadiumList[index].location.lastIndexOf("구")+1),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Dosis'
                      ),
                    )),
                Container(
                    child: Text(
                      " ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "30분 당 "+widget.stadiumList[index].price.toString()+" 원",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: 'Dosis',
                fontWeight: FontWeight.w600,
              ),
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "전화번호 : " + widget.stadiumList[index].telephone,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontFamily: 'Dosis',
                  fontWeight: FontWeight.w600),
            )),
        SizedBox(height: 5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.stadiumList[index].isClothes != 0? Icon(FontAwesomeIcons.tshirt,
                          color: GameJoinTheme.buildLightTheme().primaryColor, size: 35) :
                      Icon(FontAwesomeIcons.tshirt,
                          color: Colors.grey, size: 25) ,
                      SizedBox(height: 5),
                      Text(
                        "옷 대여",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.7),
                            fontFamily: 'Dosis'),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.stadiumList[index].isClothes != 0 ? Icon(FontAwesomeIcons.shoePrints,
                        color: GameJoinTheme.buildLightTheme().primaryColor, size: 35) :
                    Icon(FontAwesomeIcons.shoePrints,
                        color: Colors.grey, size: 25) ,
                    SizedBox(height: 5),
                    Text(
                      "신발 대여",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                          fontFamily: 'Dosis'),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.stadiumList[index].isParking != 0? Icon(FontAwesomeIcons.parking,
                        color: GameJoinTheme.buildLightTheme().primaryColor, size: 35) :
                    Icon(FontAwesomeIcons.parking,
                        color: Colors.grey, size: 25) ,
                    SizedBox(height: 5),
                    Text("주차장",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.7),
                            fontFamily: 'Dosis')),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.stadiumList[index].isShower != 0? Icon(FontAwesomeIcons.shower,
                        color: GameJoinTheme.buildLightTheme().primaryColor, size: 35) :
                    Icon(FontAwesomeIcons.shower,
                        color: Colors.grey, size: 25) ,
                    SizedBox(height: 5),
                    Text(
                      "샤워실 이용",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                          fontFamily: 'Dosis'),
                    ),
                  ],
                ),
                SizedBox(width: 20),

              ],
            )),
      ],
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      CameraPosition newPosition = makePosition(LatLng(lat, lng));
      _goToNewPosition(newPosition);
      if (_tempMarker != null) {
        _markers.remove(Marker(markerId: MarkerId(_tempMarker)));
      }
      _onCameraMove(newPosition);
      _onAddMarkerButtonPressed();
    }
  }

  Widget button(Function function, IconData icon, index) {
    return Theme(
      data: ThemeData(primaryColor: Color(0xff20253d)),
      child: FloatingActionButton(
        heroTag: "btn$index",
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xff20253d),
        child: Icon(icon, size: 36.0),
      ),
    );
  }

  Widget mapButtons() {
    if (widget.nowReq == mapReq.mapCheck || widget.nowReq == mapReq.findLocation) {
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
      body: Stack(
        children: <Widget>[
          GoogleMap(
              padding: EdgeInsets.only(bottom:MediaQuery.of(context).size.height * 0.27),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              rotateGesturesEnabled: false,
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove),

          if(widget.nowReq != mapReq.newLocation) ... [
            if(widget.stadiumList.length != 0) ... [
            Positioned(
                bottom: 20.0,
                child: Container(
                    height: 200.0,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: InkWell(
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.stadiumList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _stadiumList(index);
                            }
                        ),
                        onTap: () =>
                        widget.nowReq == mapReq.findLocation ? {
                          _onMarkerPressed(_pageController.page.toInt())
                        } : {}
                    )
                )
            )]
            else ...[
              Positioned(
                  bottom: 10.0,
                  child: Container(
                      height: 20.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        color: Color(0xff20253d)
                      ),
                      child: Center(child: Text("해당 시간에 이용 가능한 경기장이 없습니다.", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )))
                  )
              )
            ]
            ,
          ],
          Padding(padding: EdgeInsets.all(16.0), child: Align(alignment: Alignment.topRight, child: mapButtons()))
        ],
      ),
    );
  }
}
