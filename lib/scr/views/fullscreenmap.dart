import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  final LatLng center = LatLng(40.67905411114428, -3.9611007567200605);
  final darkStyle = 'mapbox://styles/musicmaniac92/ckip321iq5d7018l33s0hbpgc';
  final streetStyle = 'mapbox://styles/musicmaniac92/ckip33wt25d9118l30uduw5ej';
  String selectedStyle = 'mapbox://styles/musicmaniac92/ckip321iq5d7018l33s0hbpgc';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/symbols/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  void dispose() {
    //mapController?.onSymbolTapped?.remove(_onSymbolTapped);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapBuild(),
      floatingActionButton: modeButtons()

    );
  }


  MapboxMap mapBuild() {
    return MapboxMap(
      styleString: selectedStyle,
      accessToken: "pk.eyJ1IjoibXVzaWNtYW5pYWM5MiIsImEiOiJja2lvejV0MjIxMTFyMnNvNWUwZmg1Y2dhIn0.QZ8f1G8-3t4ntvZurUSo9A",
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
      initialCameraPosition: CameraPosition(
          target: center,
          zoom: 14
      ),
    );
  }

  Widget modeButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        FloatingActionButton(
          onPressed: () {
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              iconImage: 'assetImage',
              //iconSize: 2,
              textField: 'Una marca en el mapa',
              textOffset: Offset(0, 2)
            ));
          },
          child: Icon(Icons.emoji_symbols),
        ),
        SizedBox(height: 10,),

        FloatingActionButton(
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
          child: Icon(Icons.zoom_in),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
          child: Icon(Icons.zoom_out),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              if( selectedStyle == darkStyle ) {
                selectedStyle = streetStyle;
              } else {
                selectedStyle = darkStyle;
              }
            });
          },
          child: Icon(Icons.add_to_home_screen),
        )
      ],
    );
  }





}
