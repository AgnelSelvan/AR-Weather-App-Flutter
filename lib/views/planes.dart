import 'dart:math';

import 'package:ar_weather_app/models/weather.dart';
import 'package:ar_weather_app/services/weather.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PlanesScreen extends StatefulWidget {
  const PlanesScreen({Key? key}) : super(key: key);

  @override
  State<PlanesScreen> createState() => _PlanesScreenState();
}

class _PlanesScreenState extends State<PlanesScreen> {
  final searchController = TextEditingController();
  bool isSearchEnabled = false;
  CurrentWeather? currentWeather;

  late ARKitController arkitController;
  ARKitPlane? plane;
  List<ARKitPlaneAnchor> allAnchor = [];

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Weather APP in Flutter'),
        bottom: !isSearchEnabled
            ? null
            : PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50),
                child: Container(
                  color: Colors.white,
                  height: 50,
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please Enter a City',
                    ),
                    onEditingComplete: () async {
                      currentWeather = await WeatherService()
                          .getCurrentWeather(searchController.text);
                      if (currentWeather?.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(currentWeather?.error?.message ?? ""),
                          ),
                        );
                      } else {
                        isSearchEnabled = false;
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
      ),
      body: Container(
        child: ARKitSceneView(
          enableTapRecognizer: true,
          onARKitViewCreated: onARKitViewCreated,
          planeDetection: ARPlaneDetection.horizontalAndVertical,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            isSearchEnabled = !isSearchEnabled;
          });
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is! ARKitPlaneAnchor) {
      return;
    }
    _addPlane(anchor);
  }

  void _addPlane(ARKitPlaneAnchor anchor) {
    allAnchor.add(anchor);
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          transparency: 0.3,
          diffuse: ARKitMaterialProperty.color(Colors.white),
        )
      ],
    );

    final node = ARKitNode(
      name: anchor.nodeName,
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -pi / 2),
    );

    arkitController.add(node, parentNodeName: anchor.nodeName);
  }
}
