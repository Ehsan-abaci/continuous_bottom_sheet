# **Continuous Bottom Sheet**

A highly customizable Flutter package for creating a modal bottom sheet with a navigation stack. Each page can have a different height, and the sheet smoothly animates its size when navigating between them.

This package is built with a focus on a clean API, modularity, and extensive customization, following modern Flutter best practices.

### **Key Features**

- **Variable Page Heights**: Each page automatically determines its own height based on its content.
- **Smooth Height Animation**: The bottom sheet container fluidly animates its height when navigating between pages of different sizes.
- **Stack-Based Navigation**: Programmatically push and pop pages in a navigation stack, similar to Flutter's Navigator.
- **Highly Customizable**: Tailor the appearance and behavior by configuring all options available in Flutter's showModalBottomSheet.
- **Robust and Overflow-Safe**: Designed to handle dynamic content gracefully without layout overflows.

### **Demo**

![](https://github.com/user-attachments/assets/f6ccd982-08b3-4aa3-adaf-e5c2031dba07)

## **Installation**

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  continuous_bottom_sheet: ^2.0.0 # Replace with the latest version
```

Then, run flutter pub get in your terminal.

## **Usage**

Using the continuous bottom sheet is straightforward. Follow these steps:

### **1\. Create a Controller**

First, create an instance of ContinuousBottomSheetController. It's best to define it within your State class so it persists and can be passed to your pages.

```dart
class _MyHomePageState extends State<MyHomePage> {
  // Define the controller once to be used by the bottom sheet.
  final sheetController = ContinuousBottomSheetController();

  // ... rest of the code
}
```

### **2\. Define Your Pages**

Create the widgets that will serve as the pages for your bottom sheet. You can pass the controller to your page widgets to handle navigation.

**Important:** To prevent potential layout overflows with dynamic content (like TextFields), it is highly recommended to wrap the content of each page in a SingleChildScrollView.

```dart
// Example Page Widget
class FirstPage extends StatelessWidget {
  final ContinuousBottomSheetController controller;

  const FirstPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for height calculation
          children: [
            const Text("Step 1"),
            const TextField(decoration: InputDecoration(labelText: 'Your Name')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.push(SecondPage(controller: controller)),
              child: const Text('Continue'),
            ),
          ],
        ),
    );
  }
}
```

### **3\. Show the Bottom Sheet**

Call the showContinuousBottomSheet function from an event handler, like a button's onPressed callback. Pass the context, the controller, and your initialPage.

```dart
void _openBottomSheet() {
  showContinuousBottomSheet(
    context: context,
    controller: sheetController,
    initialPage: FirstPage(controller: sheetController),
  );
}
```

## **Customization**

You can fully customize the appearance and behavior of the bottom sheet by passing optional parameters to the showContinuousBottomSheet function. This function exposes all the configuration options of Flutter's native showModalBottomSheet.

```dart
showContinuousBottomSheet(
  context: context,
  controller: sheetController,
  initialPage: FirstPage(controller: sheetController),
  // \--- Animation Customizations \---
  heightAnimationDuration: const Duration(milliseconds: 500),
  heightAnimationCurve: Curves.easeOutCubic,
  pageSlideAnimationDuration: const Duration(milliseconds: 300),
  pageSlideAnimationCurve: Curves.linear,
  // \--- Modal Sheet Customizations \---
  backgroundColor: Colors.grey.shade100,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  ),
  barrierColor: Colors.black.withOpacity(0.6),
  isDismissible: false,
  enableDrag: true,
);
```

| Parameter                  | Type            | Description                                                                  |
| :------------------------- | :-------------- | :--------------------------------------------------------------------------- |
| heightAnimationDuration    | Duration        | The duration of the height change animation. Defaults to 300ms.              |
| heightAnimationCurve       | Curve           | The curve of the height change animation. Defaults to Curves.easeInOutCubic. |
| pageSlideAnimationDuration | Duration        | The duration of the page fade transition. Defaults to 400ms.                 |
| pageSlideAnimationCurve    | Curve           | The curve of the page fade transition. Defaults to Curves.easeInOutCubic.    |
| backgroundColor            | Color?          | The background color of the bottom sheet container.                          |
| elevation                  | double?         | The z-coordinate at which to place this sheet.                               |
| shape                      | ShapeBorder?    | The shape of the bottom sheet container.                                     |
| clipBehavior               | Clip?           | The content will be clipped (or not) according to this option.               |
| barrierColor               | Color?          | The color of the modal barrier that darkens the main content.                |
| isDismissible              | bool            | If true, tapping the barrier will dismiss the sheet. Defaults to true.       |
| enableDrag                 | bool            | If true, the sheet can be dismissed by dragging downwards. Defaults to true. |
| useRootNavigator           | bool            | If true, the sheet is pushed to the root navigator. Defaults to false.       |
| useSafeArea                | bool            | If true, the sheet is padded to avoid system intrusions. Defaults to false.  |
| routeSettings              | RouteSettings?  | Settings for the route pushed by the bottom sheet.                           |
| constraints                | BoxConstraints? | Defines the maximum and minimum size of the bottom sheet.                    |

## **Controller API Reference**

The ContinuousBottomSheetController provides methods to control the bottom sheet programmatically.

| Method             | Return Type   | Description                                               |
| :----------------- | :------------ | :-------------------------------------------------------- |
| push(Widget page)  | Future\<T?\>? | Pushes a new page onto the navigation stack.              |
| pop(\[T? result\]) | void          | Pops the current page from the navigation stack.          |
| canPop()           | bool          | Returns true if there is more than one page in the stack. |
| close()            | void          | Closes the entire bottom sheet.                           |

## **Reporting Issues and Contributing**

Find a bug or have a feature request? Please open an issue on our [GitHub repository](https://github.com/Ehsan-abaci/continuous_bottom_sheet/issues).

Contributions are welcome\!

## **License**

This project is licensed under the MIT License \- see the [LICENSE](https://github.com/Ehsan-abaci/continuous_bottom_sheet/blob/master/LICENSE) file for details.
