import 'package:flutter/material.dart';
import 'continuous_bottom_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Continuous Bottom Sheet Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Define the controller once to be used by the bottom sheet.
  final sheetController = ContinuousBottomSheetController();

  void _openBottomSheet() {
    // Pass the controller and the list of pages to the bottom sheet.
    showContinuousBottomSheet(
      context: context,
      controller: sheetController,
      pages: [
        FirstPage(
          onNext: () => sheetController.nextPage(),
          onClose: sheetController.close,
        ),
        SecondPage(
          onPrev: sheetController.previousPage,
          onNext: sheetController.nextPage,
        ),
        ThirdPage(
          onPrev: sheetController.previousPage,
          onClose: sheetController.close,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Continuous Bottom Sheet')),
      body: Center(
        child: ElevatedButton(
          onPressed: _openBottomSheet,
          child: const Text('Show Resizing Bottom Sheet'),
        ),
      ),
    );
  }
}

// --- Example Pages for the Bottom Sheet (Corrected) ---

class FirstPage extends StatelessWidget {
  const FirstPage({super.key, required this.onNext, required this.onClose});
  final VoidCallback onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    // The page content is wrapped in Padding, without a fixed-height container.
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize:
              MainAxisSize
                  .min, // Let the Column's height be defined by its children.
          children: [
            Text('Step 1', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text(
              'This is the first page. Please enter some details below.',
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24), // Use SizedBox for explicit spacing.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onNext,
                  child: const Text('Continue'),
                ),
                ElevatedButton(onPressed: onClose, child: const Text('Close')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key, required this.onPrev, required this.onNext});
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Step 2', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text('This page is taller. Look at the smooth animation!'),
            // Add more content or SizedBoxes to make the page taller naturally.
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onPrev,
                  child: const Text('Previous'),
                ),
                ElevatedButton(onPressed: onNext, child: const Text('Next')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key, required this.onPrev, required this.onClose});
  final VoidCallback onPrev;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Step 3', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text(
              'This is the final step. You can go back or close the sheet.',
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onPrev,
                  child: const Text('Previous'),
                ),
                ElevatedButton(onPressed: onClose, child: const Text('Close')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
