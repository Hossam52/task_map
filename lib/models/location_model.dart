import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  String id;
  String title;
  LatLng position;

  LocationModel({
    required this.id,
    required this.position,
    this.title = 'Location is here',
  });
}
