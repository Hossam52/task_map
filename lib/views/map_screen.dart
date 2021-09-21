import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_task/models/location_model.dart';
import 'package:map_task/utils/enums.dart';
import 'package:map_task/utils/map_util.dart';
import 'package:map_task/widgets/custom_button.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool showBottomActions = true;
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(30.1356215, 31.2928607);
  LocationModel _myLocation = LocationModel(
      id: 'MyLocation',
      title: 'Here is my location',
      position: LatLng(30.1356215, 31.2928607));

  LocationModel _destinationLocation = LocationModel(
      id: 'JBF',
      title: 'Here is JBF location',
      position: LatLng(30.050199571093312, 32.016298212110996));

  ChangeLocationStates _currentLocationChange = ChangeLocationStates.none;
  BitmapDescriptor? _currentLocationIcon;
  BitmapDescriptor? _destLocationIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map Sdk Integration for JBF <3'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: _showDailogInformation, icon: Icon(Icons.info))
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildMap(),
            _buildActionsOnMap(),
          ],
        ));
  }

  void _showDailogInformation() async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Information about the app'),
              content: Text(
                'To change the value of location :\n\tclick on the button then click at any area of map',
              ),
            ));
  }

  Widget _buildActionsOnMap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: showBottomActions,
        replacement: IconButton(
            icon: Icon(Icons.keyboard_arrow_up, size: 60),
            onPressed: _changeVisibity),
        child: GestureDetector(
            onTap: _changeVisibity, child: _buildChangingData()),
      ),
    );
  }

  void _changeVisibity() {
    setState(() {
      showBottomActions = !showBottomActions;
    });
  }

  Widget _buildChangingData() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 60,
          ),
          onPressed: () {
            setState(() {
              showBottomActions = !showBottomActions;
            });
          },
        ),
        SizedBox(height: 20),
        _buildChangeLocations(),
        _buildRemoveLocations(),
        _buildRemoveAll()
      ],
    );
  }

  Widget _buildRemoveAll() {
    return CustomButton(
        onPressed: () {
          setState(() {
            _markers.clear();
            _currentLocationChange = ChangeLocationStates.none;
          });
        },
        content: 'Remove all');
  }

  Widget _buildRemoveLocations() {
    return Row(
      children: [
        Expanded(
            child: CustomButton(
          content: 'Remove source',
          onPressed: () {
            setState(() {
              _markers.removeWhere(
                  (element) => element.markerId.value == _myLocation.id);
              _currentLocationChange =
                  ChangeLocationStates.removeCurrentLocation;
            });
          },
        )),
        SizedBox(width: 30),
        Expanded(
            child: CustomButton(
          content: 'Remove Destination ',
          onPressed: () {
            setState(() {
              _markers.removeWhere((element) =>
                  element.markerId.value == _destinationLocation.id);
              _currentLocationChange =
                  ChangeLocationStates.removeDestinationLocation;
            });
          },
        ))
      ],
    );
  }

  Widget _buildChangeLocations() {
    return Row(
      children: [
        Expanded(
            child: CustomButton(
                onPressed: () {
                  _currentLocationChange =
                      ChangeLocationStates.changeMyLocation;
                },
                content: 'Change source')),
        SizedBox(width: 30),
        Expanded(
            child: CustomButton(
                onPressed: () {
                  _currentLocationChange =
                      ChangeLocationStates.changeDestinationLocation;
                },
                content: 'Change Destination'))
      ],
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 8.0,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId('1'),
          points: <LatLng>[_myLocation.position, _destinationLocation.position],
          width: 4,
        )
      },
      onTap: _onMapTapped,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  void _onMapTapped(LatLng position) {
    print(position);
    switch (_currentLocationChange) {
      case ChangeLocationStates.changeMyLocation:
        _myLocation.position = position;
        _addMarkers();
        break;
      case ChangeLocationStates.changeDestinationLocation:
        _destinationLocation.position = position;
        _addMarkers();
        break;
      case ChangeLocationStates.removeCurrentLocation:
      case ChangeLocationStates.removeDestinationLocation:
      case ChangeLocationStates.removeBoth:
        break;

      default:
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    await _setCustomPins();
    mapController = controller;
    _addMarkers();
  }

  Future<void> _setCustomPins() async {
    _currentLocationIcon =
        await MapUtil.getIconFromAssets('assets/images/my_location.png');
    _destLocationIcon =
        await MapUtil.getIconFromAssets('assets/images/pin.png');
  }

  void _addMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(_buildMarker(_myLocation, icon: _currentLocationIcon!));
      _markers
          .add(_buildMarker(_destinationLocation, icon: _destLocationIcon!));
    });
  }

  Marker _buildMarker(LocationModel location,
      {BitmapDescriptor icon = BitmapDescriptor.defaultMarker}) {
    final marker = Marker(
        markerId: MarkerId(location.id),
        infoWindow: InfoWindow(title: location.title),
        position: location.position,
        icon: icon);
    return marker;
  }
}
