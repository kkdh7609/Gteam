import 'package:google_maps_flutter/google_maps_flutter.dart';

class Stadium{
  String shopName;
  String address;
  String description;
  LatLng locationCoords;

  Stadium({
    this.shopName,
    this.address,
    this.description,
    this.locationCoords
});
}

final List<Stadium> stadiumList = [
  Stadium(
    shopName: "Suwon",
    address: "here",
    description:
      'beautiful suwon',
    locationCoords: LatLng(37.26222, 127.02889)
  ),
  Stadium(
    shopName: "Ajou",
    address: "hereherehe rehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehere",
    description:
      'best university in worlddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd',
    locationCoords: LatLng(37.283057, 127.046376)
  ),
  Stadium(
    shopName: "Ajou Hospital",
    address: "here",
    description:
      'best hospital in world',
    locationCoords: LatLng(37.279445, 127.047462)
  ),
  Stadium(
    shopName: "10th fighter wing",
    address: "here",
    description:
      'Worst place in world',
    locationCoords: LatLng(37.240324, 127.007490)
  ),
  Stadium(
    shopName: "God's Home",
    address: "Sky",
    description:
      "God live in here",
    locationCoords: LatLng(37.246180, 126.979959)
  )
];
