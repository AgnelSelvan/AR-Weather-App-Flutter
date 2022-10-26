## AR Weather App using ARKIT - Lesson 7

In this lesson we will be implementing placing the Weather Data Card on ARView.

### Declaring Constants
* Create a new *constants.dart* file.
```dart
    class Constants {
        ///Model DIR
        static const modelDir = "model.scnassets/";

        /// Models Names
        static const clear = "clear";
        static const partiallyCloud = "partially_cloud";
        static const cloudy = "cloudy";
        static const rain = "rain";
        static const snow = "snow";
        static const thunder = "thunder";
        static const sunny = "sunny";

        /// Weather to Model
        static String getModelsByWeatherCategory(String category) {
            final categoryName = category.toLowerCase();
            String modelPath = modelDir;
            if (categoryName.contains("mist") ||
                categoryName.contains("cloudy") ||
                categoryName.contains("cloud")) {
            modelPath += cloudy;
            } else if (categoryName.contains("clear")) {
            modelPath += clear;
            } else if (categoryName.contains("partial")) {
            modelPath += partiallyCloud;
            } else if (categoryName.contains("rain")) {
            modelPath += rain;
            } else if (categoryName.contains("winter") ||
                categoryName.contains("snow")) {
            modelPath += snow;
            } else if (categoryName.contains("thunder") ||
                categoryName.contains("storm")) {
            modelPath += thunder;
            } else if (categoryName.contains("sunny") ||
                categoryName.contains("summer")) {
            modelPath += sunny;
            }

            return "$modelPath.dae";
        }
    }
```
* Here we are declaring the models dir and the models name. *getModelsByWeatherCategory* method is used to get model path based on the weather category we will be passing.
* Once we hit Weather API, from the weather category we will be getting the model path.

### On Node Tap Handler
* Some code updation need to done in onNodeTapHandler method
```dart
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
```
* Here we are ploting on ARView only when the *currentWeather* data is not null or else we'll show the error message to search for weather.

### Ploting Data on AR View
* In this method drawing the Text, Model in AR View.
```dart
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
        animationIdentifier: model,
        );
    }

```
#### Drawing Text on AR
```dart
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
```
* Drawing the text, by giving the scale and position based on the tappedAnchor
### Placing the Model
* Getting the model path based on the weather searched by country.
* Using *ARKitReferenceNode*, passing the modelPath to *ARKitReferenceNode* url attribute and need to position the model dyamically and then adding it to *arKitController*.
```dart
    final model = Constants.getModelsByWeatherCategory(
        currentWeather?.current?.condition?.text ?? "sunny");
    final cloudNode = ARKitReferenceNode(
    url: model,
    position: vector.Vector3(
        tappedAnchor.center.x + (width / 4), 0.1, tappedAnchor.center.z),
    scale: vector.Vector3(0.02, 0.02, 0.02),
    eulerAngles: vector.Vector3(0, 0, 0),
    );
    arkitController.add(cloudNode, parentNodeName: tappedAnchor.nodeName);
```
#### Adding Animation to Model
* For playing the animation you just need to call the playAnimation method in arKitController by passing the model path to play the animation.
```dart
    await arkitController.playAnimation(
      key: '',
      sceneName: model,
      animationIdentifier: "random",
    );
```