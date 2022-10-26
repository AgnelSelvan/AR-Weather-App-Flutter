## AR Weather App using ARKIT - Lesson 3

From this lesson we will be starting with our AR Weather App. In this lesson we will be starting with UI Implementation of AR App.

#### Setup
1. create a new file inside *views* folder named **ar_weather.dart** and create a stateful widget named *ARWeatherScreen*.
2. In your **main.dart** replace *HelloWorldScreen* to *ARWeatherScreen*.

##### Variable declaration
* In your *ARWeatherScreen* widget declare these both variables.
```dart
final searchController = TextEditingController();
bool isSearchEnabled = false;
```

#### Widget Tree
```dart
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
                      isSearchEnabled = false;

                      setState(() {});
                    },
                  ),
                ),
              ),
      ),
      body: Container(
        child: const Text(
          "Hello AR Weather App",
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
```
* Place these code in your build method.
* For now in your **body** place the Text Widget. We will be creating the ARKitView in the upcoming lesson.
