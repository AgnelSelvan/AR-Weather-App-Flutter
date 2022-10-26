## AR Weather App using ARKIT - Lesson 5

In this lesson we will be detecting the Horizontal and Vertical planes in ARKitView.

#### Required Imports
* Import all the required package in the top of the file.
```dart
import 'dart:math';

import 'package:ar_weather_app/models/weather.dart';
import 'package:ar_weather_app/services/weather.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
```

#### Variable Declaration and dispose
* Declaring all the required paramters and disposing the arkitController when the screen deinitialize inorder to avoid memory leaks.
```dart
  late ARKitController arkitController;
  ARKitPlane? plane;
  List<ARKitPlaneAnchor> allAnchor = [];

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }
```

#### Creating ARKitSceneView
* Replace the body with below code.
```dart
    body: Container(
        child: ARKitSceneView(
          enableTapRecognizer: true,
          onARKitViewCreated: onARKitViewCreated,
          planeDetection: ARPlaneDetection.horizontalAndVertical,
        ),
    ),
```
* Make sure you assign the *planeDetection* proper enum i.e *ARPlaneDetection.horizontalAndVertical*, by default it is set as none.
For Only Horizontal, *ARPlaneDetection.horizontal*
Only Vertical, *ARPlaneDetection.vertical*

#### Declaring Methods
* *onARViewCreated*  once the AR View Created assinging the controller to global variable so to we can add the nodes on the ARViewScene from anywhere throughout the widget. And when the Horizontal or Vertical planes detected onAddNodeForAnchor method will be triggered.
```dart
    void onARKitViewCreated(ARKitController arkitController) {
        this.arkitController = arkitController;
        this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    }
```
* Once the onAddNodeForAnchor is triggered we will be adding the plane to the AR Scene.
```dart
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
```
* *ARKitPlane* will be used to add the Plane in the Scene we need to pass the width and height for that plane. Here, for width and height we will be getting data from the anchor when the method gets triggered, not only width and height, we will get position and more data from the anchor.
* *ARKitMaterial* is used to assign some color, transparency to the 3D object.
* *ARKitNode* is used for placing the object in scene without ARKitNode we cannot place any 3D Object on Scene
* Atlast we will will be adding the node to the controller.