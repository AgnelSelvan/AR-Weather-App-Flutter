import 'dart:math';

import 'package:ar_weather_app/constants/constants.dart';
import 'package:ar_weather_app/models/weather.dart';
import 'package:ar_weather_app/services/weather.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARWeatherDataScreen extends StatefulWidget {
  const ARWeatherDataScreen({Key? key}) : super(key: key);

  @override
  State<ARWeatherDataScreen> createState() => _ARTapScreenState();
}

class _ARTapScreenState extends State<ARWeatherDataScreen> {
  final searchController = TextEditingController();
  bool isSearchEnabled = false;
  CurrentWeather? currentWeather;

  late ARKitController arkitController;
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
    // Adding Tap Gestures
    this.arkitController.onNodeTap = (nodes) => onNodeTapHandler(nodes);
  }

  void onNodeTapHandler(List<String> nodesList) async {
    final tappedAnchor = allAnchor
        .where((element) => element.nodeName == nodesList.first)
        .toList()
        .first;
    if (currentWeather != null) {
      _plotWeatherDataOnARKit(tappedAnchor);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please search for weather in a country"),
        ),
      );
    }
  }

  void _plotWeatherDataOnARKit(ARKitPlaneAnchor tappedAnchor) async {
    const width = 0.25;
    const height = 0.2;
    final weatherPlane = ARKitPlane(
      width: width,
      height: height,
      materials: [
        ARKitMaterial(
          transparency: 0.6,
          diffuse: ARKitMaterialProperty.color(Colors.black),
        )
      ],
    );
    final weatherNode = ARKitNode(
      geometry: weatherPlane,
      position:
          vector.Vector3(tappedAnchor.center.x, 0.01, tappedAnchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -pi / 2),
    );
    arkitController.add(weatherNode, parentNodeName: tappedAnchor.nodeName);

    ///Place
    final text = ARKitText(
      text:
          "It's ${currentWeather?.current?.condition?.text} - ${searchController.text}",
      extrusionDepth: 0.05,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.white),
          shininess: 0.2,
          ambient: ARKitMaterialProperty.color(Colors.green),
        ),
      ],
    );

    final textNode = ARKitNode(
      geometry: text,
      position: vector.Vector3(tappedAnchor.center.x - (width / 2) + 0.02, 0.02,
          tappedAnchor.center.z - 0.04),
      rotation: vector.Vector4(1, 0, 0, -pi / 2),
      scale: vector.Vector3(0.0015, 0.0015, 0.0015),
    );
    arkitController.add(textNode, parentNodeName: tappedAnchor.nodeName);

    /// Date
    final dateText = ARKitText(
      text: "${currentWeather?.current?.lastUpdated}",
      extrusionDepth: 0.05,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.white),
          shininess: 0.2,
          ambient: ARKitMaterialProperty.color(Colors.green),
        ),
      ],
    );

    final dateNode = ARKitNode(
      geometry: dateText,
      position: vector.Vector3(tappedAnchor.center.x - (width / 2) + 0.02, 0.02,
          tappedAnchor.center.z - 0.01),
      rotation: vector.Vector4(1, 0, 0, -pi / 2),
      scale: vector.Vector3(0.0008, 0.0008, 0.0008),
    );
    arkitController.add(dateNode, parentNodeName: tappedAnchor.nodeName);

    /// Weather
    final weatherText = ARKitText(
      text: "${currentWeather?.current?.tempC}°C",
      extrusionDepth: 0.05,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.white),
          shininess: 0.2,
          ambient: ARKitMaterialProperty.color(Colors.green),
        ),
      ],
    );

    final weatherDataNode = ARKitNode(
      geometry: weatherText,
      position: vector.Vector3(tappedAnchor.center.x - (width / 2) + 0.02, 0.02,
          tappedAnchor.center.z + 0.09),
      rotation: vector.Vector4(1, 0, 0, -pi / 2),
      scale: vector.Vector3(0.0055, 0.0055, 0.0055),
    );
    arkitController.add(weatherDataNode, parentNodeName: tappedAnchor.nodeName);
    final model = Constants.getModelsByWeatherCategory(
        currentWeather?.current?.condition?.text ?? "sunny");
    print(model);
    final cloudNode = ARKitReferenceNode(
      url: model,
      position: vector.Vector3(
          tappedAnchor.center.x + (width / 4), 0.1, tappedAnchor.center.z),
      scale: vector.Vector3(0.02, 0.02, 0.02),
      eulerAngles: vector.Vector3(0, 0, 0),
    );
    arkitController.add(cloudNode, parentNodeName: tappedAnchor.nodeName);

    await arkitController.playAnimation(
      key: '',
      sceneName: model,
      animationIdentifier: "random",
    );
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is! ARKitPlaneAnchor) {
      return;
    }
    _addPlane(anchor);
  }

  void _addPlane(ARKitPlaneAnchor anchor) {
    allAnchor.add(anchor);
    final plane = ARKitPlane(
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
