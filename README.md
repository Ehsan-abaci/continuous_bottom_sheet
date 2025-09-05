# **Continuous Bottom Sheet**

A highly customizable Flutter package for creating a modal bottom sheet with multiple, swipeable pages. Each page can have a different height, and the sheet smoothly animates its size when navigating between pages.

This package is built with a focus on a clean API, modularity, and extensive customization, following modern Flutter best practices.

### **Key Features**

* **Variable Page Heights**: Each page automatically determines its own height based on its content.  
* **Smooth Height Animation**: The bottom sheet container fluidly animates its height when navigating between pages of different sizes.  
* **Swipe and Programmatic Navigation**: Users can swipe between pages, or you can control the flow programmatically using a dedicated controller.  
* **Highly Customizable**: Tailor the appearance and behavior, including colors, shapes, animation durations, curves, and swipe physics.  
* **Robust and Overflow-Safe**: Designed to handle dynamic content gracefully without layout overflows.

### **Demo**

*(A GIF showcasing the bottom sheet swiping between a short page with a text field and a taller page with more content, demonstrating the smooth height animation.)*

## **Installation**

Add this to your package's pubspec.yaml file:
```dart
dependencies:  
  continuous_bottom_sheet: ^1.0.0 # Replace with the latest version
```
Then, run flutter pub get in your terminal.

## **Usage**

Using the continuous bottom sheet is straightforward. Follow these three steps:

### **1\. Create a Controller**

First, create an instance of ContinuousBottomSheetController. It's best to define it within your State class so it persists.
```dart
class _MyHomePageState extends State<MyHomePage> {  
  // Define the controller once to be used by the bottom sheet.  
  final sheetController = ContinuousBottomSheetController();

  // ... rest of the code  
}
```
### **2\. Define Your Pages**

Create a list of widgets that will serve as the pages for your bottom sheet.

**Important:** To prevent potential layout overflows with dynamic content (like TextFields), it is highly recommended to wrap the content of each page in a SingleChildScrollView.
```dart
// Example Page Widget  
class FirstPage extends StatelessWidget {  
  final VoidCallback onNext;  
  final VoidCallback onClose;

  const FirstPage({super.key, required this.onNext, required this.onClose});

  @override  
  Widget build(BuildContext context) {  
    // Wrap page content to prevent overflows  
    return SingleChildScrollView(  
      child: Padding(  
        padding: const EdgeInsets.all(24.0),  
        child: Column(  
          mainAxisSize: MainAxisSize.min, // Important for height calculation  
          children: [  
            const Text("Step 1"),  
            const TextField(decoration: InputDecoration(labelText: 'Your Name')),  
            const SizedBox(height: 24),  
            ElevatedButton(onPressed: onNext, child: const Text('Continue')),  
          ],  
        ),  
      ),  
    );  
  }  
}
```
### **3\. Show the Bottom Sheet**

Call the showContinuousBottomSheet function from an event handler, like a button's onPressed callback. Pass the context, the controller, and your list of pages.
```dart
void _openBottomSheet() {  
  showContinuousBottomSheet(  
    context: context,  
    controller: sheetController,  
    pages: [  
      FirstPage(  
        onNext: sheetController.nextPage,  
        onClose: sheetController.close,  
      ),  
      SecondPage(  
        onPrev: sheetController.previousPage,  
        onNext: sheetController.nextPage,  
      ),  
      // ... more pages  
    ],  
  );  
}
```
## **Customization**

You can customize the appearance and behavior of the bottom sheet by passing optional parameters to the showContinuousBottomSheet function.
```dart
showContinuousBottomSheet(  
  context: context,  
  controller: sheetController,  
  pages: yourPages,  
  // \--- Customization Options \---  
  backgroundColor: Colors to.grey.shade100,  
  shape: const RoundedRectangleBorder(  
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),  
  ),  
  heightAnimationDuration: const Duration(milliseconds: 500),  
  heightAnimationCurve: Curves.easeOutCubic,  
  pageSlideAnimationDuration: const Duration(milliseconds: 300),  
  pageSlideAnimationCurve: Curves.linear,  
  physics: const BouncingScrollPhysics(),  
);
```
| Parameter | Type | Description |
| :---- | :---- | :---- |
| backgroundColor | Color? | The background color of the bottom sheet container. |
| shape | ShapeBorder? | The shape of the bottom sheet container. |
| clipBehavior | Clip | The clipping behavior. Defaults to Clip.antiAlias. |
| heightAnimationDuration | Duration | The duration of the height change animation. Defaults to 300ms. |
| heightAnimationCurve | Curve | The curve of the height change animation. Defaults to Curves.easeInOutCubic. |
| pageSlideAnimationDuration | Duration | The duration of the programmatic page slide. Defaults to 400ms. |
| pageSlideAnimationCurve | Curve | The curve of the programmatic page slide. Defaults to Curves.easeInOutCubic. |
| physics | ScrollPhysics? | The physics for the PageView, controlling the swipe behavior. |

## **Controller API Reference**

The ContinuousBottomSheetController provides methods to control the bottom sheet programmatically.

| Method | Return Type | Description |
| :---- | :---- | :---- |
| nextPage() | void | Animates to the next page. |
| previousPage() | void | Animates to the previous page. |
| animateToPage(int page) | void | Animates to the specified page index. |
| jumpToPage(int page) | void | Jumps directly to the specified page index without animation. |
| close() | void | Closes the bottom sheet. |

| Property | Type | Description |
| :---- | :---- | :---- |
| pageCount | int | The total number of pages in the bottom sheet. |
| currentPage | int | The index of the currently visible page. |

## **Reporting Issues and Contributing**

Find a bug or have a feature request? Please open an issue on our [GitHub repository](https://github.com/Ehsan-abaci/continuous_bottom_sheet/issues).

Contributions are welcome\!

## **License**

This project is licensed under the MIT License \- see the [LICENSE](https://github.com/Ehsan-abaci/continuous_bottom_sheet/blob/master/LICENSE) file for details.
