import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HelloWorldScreen extends StatefulWidget {
  const HelloWorldScreen({Key? key}) : super(key: key);

  @override
  State<HelloWorldScreen> createState() => _HelloWorldScreenState();
}

class _HelloWorldScreenState extends State<HelloWorldScreen> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello World"),
      ),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
        environmentTexturing:
            ARWorldTrackingConfigurationEnvironmentTexturing.automatic,
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.add(_createHelloWorldText());
  }

  ARKitNode _createHelloWorldText() {
    final text = ARKitText(
      text: 'Hello World',
      extrusionDepth: 2,
      materials: [
        ARKitMaterial(diffuse: ARKitMaterialProperty.color(Colors.red))
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.1, 0.1, -0.4),
      scale: vector.Vector3(0.001, 0.001, 0.001),
    );
  }
}
