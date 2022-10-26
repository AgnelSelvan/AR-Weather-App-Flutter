## AR Weather App using ARKIT - Lesson 6

In this lesson we will be implementing Tap Gestures on ARKitView.

#### Adding Node Tap Handler
* On Tapping on ARKit View Node list of Node name will be collected and using that nodes name list we will be placing the planes. 
* onNodeTap needs to be created on *ARKitController* which will be created by *onARKitViewCreated* method.
```dart
    void onARKitViewCreated(ARKitController arkitController) {
        this.arkitController = arkitController;
        this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
        // Adding Tap Gestures
        this.arkitController.onNodeTap = (nodes) => onNodeTapHandler(nodes);
    }
```

### Declaring Method for onNodeTapHandler
* On Tap on any node on AR View we will be getting the nodeName and we need to check the nodeName exists in the anchor of planes which we got on horizontal and vertical plane.
* Once we get the anchor of tapped node we will be placing the Weather Plane on that node using the *_plotWeatherDataOnARKit* method.
```dart
    void onNodeTapHandler(List<String> nodesList) async {
        final tappedAnchor = allAnchor
            .where((element) => element.nodeName == nodesList.first)
            .toList()
            .first;

        _plotWeatherDataOnARKit(tappedAnchor);
    }
```
* On the tapped node we will be placing a plane. 
```dart
    _plotWeatherDataOnARKit(ARKitPlaneAnchor tappedAnchor) {
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
    }
```
