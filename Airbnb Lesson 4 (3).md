# Hero Banner
In this lesson we will create this background image with this call to action button:
![](https://www.dropbox.com/s/ezufcbqnu1r13gr/Screen%20Shot%202022-06-25%20at%206.19.23%20PM.png?dl=0&raw=1)

### Creating HeroBanner()
1. Go to `/widgets` and create a new file called `hero_banner.dart`.
2. Inside, create a new stateless widget called `HeroBanner()`

```dart
<content>
import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

```

3. Because this will be directly inside the `CustomScrollView`, we need to use a `SliverToBoxAdapter()` as the parent widget. So go ahead and replace the `Container()` with that:

```dart
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter();
  }
}
```

4. Let's use a `SizedBox(height: MediaQuery.of(context).size.height / 2.1)` to determine the height that the `HeroBanner()` will take. Because we will have some text and a button on top of the background image, we want to pass a `Stack()` as a child to the `SizedBox()`.

```dart
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.1,
            child: Stack(
                children: []
            )
        ),
    );
  }
}
```

5. Inside the `Stack()` we will have our background image as the first widget in it. We will use this image url: "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/airbnb%2Fairbnb_home.webp?alt=media&token=27e4e303-eac2-4144-945f-73769bcb81f7":

```dart
    Stack(
        children: [
            Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/airbnb%2Fairbnb_home.webp?alt=media&token=27e4e303-eac2-4144-945f-73769bcb81f7",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 2.1,
                ),
            ]
        )
```

6. The second widget that will go inside the `Stack()` will be a `Column` widget with an `Align` centered as a parent. This will add a centered offset to the column that we'll be populating: 

```dart
Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
```

7. Inside the `Column` let's add our `Text` widget surrounded by 2 `SizedBox()` to give some additional space:

```dart
    const SizedBox(
        height: 35,
    ),
    const Text("Not sure where to go?\nPerfect.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    const SizedBox(
        height: 25,
    ),
```


8. Perfect, up to this point you should have something like this:

```dart
import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2.1,
        child: Stack(
          children: [
            Image.network(
              "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/airbnb%2Fairbnb_home.webp?alt=media&token=27e4e303-eac2-4144-945f-73769bcb81f7",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 2.1,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  const Text("Not sure where to go?\nPerfect.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Creating the Button
Let's now work on the button that goes below that Text inside the same `Column()`. Let's start creating it below the last `SizedBox()` in our `Column()`

1. Add `ElevatedButton()` below the `SizedBox`.

```dart
ElevatedButton(

)
```

2. Let's now customize it by adding a `ButtonStyle` to the `style:` parameter. Add some elevation to it, align it center, add some padding, make it white and round the border. Try it for yourself first.

```dart
<blur>
ElevatedButton(
    style: ButtonStyle(
        elevation: MaterialStateProperty.all(5),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(
            const EdgeInsets.only(
                right: 50, left: 50, top: 12.5, bottom: 12.5)),
        backgroundColor:
            MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
        )
```

3. Awesome, still inside the `style:` let's modify the overlay Color to change based on the button's state. We want the color of the button to change to `Colors.grey.shade100` when the user presses it. We can do that by using the `MaterialStateProperty.resolveWith` in the `overlayColor:` property which gives us access to the state and we can modify it to change color based on the pressed state:

```dart
ElevatedButton(
    style: ButtonStyle(
        elevation: MaterialStateProperty.all(5),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(
            const EdgeInsets.only(
                right: 50, left: 50, top: 12.5, bottom: 12.5)),
        backgroundColor:
            MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed)
                ? Colors.grey.shade100
                : null;
          },
        ),
    ),
```

4. After finishing the style, add an empty `onPressed: (){}` to the `ElevatedButton()`

```dart
    ElevatedButton(
        style: ...
        onPressed: () {},
    ),
```

### Working with Gradient Text
If you look at the button from the Airbnb UI, you will notice it's a gradient text. Here is how you can achieve that with Flutter.

1. After the `onPressed:` parameter let's add a `ShaderMask()` widget as the child of the button. The shader mask will be responsible for painting the gradient in the text. The `ShaderMask()` takes in a `shaderCallback:` that will return a `LinearGradient` with the colors you like. But because a gradient is not a shader, we need to create one on top of it by calling `createShader()` which takes in a rectangle that we can define by using the boundaries in Rect provided by the `shaderCallback` like so:


```dart
ElevatedButton(
    style: ButtonStyle(
    ),
    onPressed: () {},
    child: ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.purple, Colors.pink]).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: 
    ),
  ),
```

2. Awesome, let's now pass a `Text` as a child to it. **It is important to set the color of the text to white, otherwise it won't work.**

```dart
child: Text(
    "I'm flexible",
    style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold),
  ),
```

That's about it! Make sure to import it on your `home_page.dart`. Save it and you should see the banner popping on your screen. Here is the entire code for the banner if you need:

```dart
<content>
import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2.1,
        child: Stack(
          children: [
            Image.network(
              "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/airbnb%2Fairbnb_home.webp?alt=media&token=27e4e303-eac2-4144-945f-73769bcb81f7",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 2.1,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  const Text("Not sure where to go?\nPerfect.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5),
                        alignment: Alignment.center,
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                right: 50, left: 50, top: 12.5, bottom: 12.5)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.grey.shade100
                                : null;
                          },
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        )),
                    onPressed: () {},
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.purple, Colors.pink]).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: const Text(
                        "I'm flexible",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```














