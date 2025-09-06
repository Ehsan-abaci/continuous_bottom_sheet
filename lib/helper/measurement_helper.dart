import 'dart:async' show Completer;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;

/// Measures a widget's height by rendering it invisibly in an [Overlay].
///
/// This is useful for determining the height of a widget before it is
/// actually displayed on the screen.
Future<double> getOffstageWidgetHeight(Widget widget, BuildContext context) {
  final completer = Completer<double>();
  final GlobalKey widgetKey = GlobalKey();

  // Create an overlay entry to hold the widget offstage.
  final entry = OverlayEntry(
    builder:
        (_) => Opacity(
          opacity: 0,
          child: Center(
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Material(
                type: MaterialType.transparency,
                // Use the WidgetSize widget to get the size of the widget.
                child: WidgetSize(
                  key: ValueKey(DateTime.now()),
                  onChange: (Size s) {
                    if (!completer.isCompleted) {
                      completer.complete(s.height);
                    }
                  },
                  child: RepaintBoundary(key: widgetKey, child: widget),
                ),
              ),
            ),
          ),
        ),
  );

  // Insert the overlay entry.
  Overlay.of(context).insert(entry);

  // Remove the overlay entry once the height has been determined.
  return completer.future.whenComplete(() => entry.remove());
}

/// A widget that calls a callback when its size changes.
class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function(Size) onChange;

  const WidgetSize({super.key, required this.onChange, required this.child});

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  final widgetKey = GlobalKey();
  Size? oldSize;

  @override
  void initState() {
    super.initState();
    // Schedule a callback for after the frame is rendered.
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  @override
  void didUpdateWidget(covariant WidgetSize oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Schedule a callback for after the frame is rendered.
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  /// Called after the frame is rendered.
  void postFrameCallback(_) {
    final context = widgetKey.currentContext;
    if (context == null) return;

    final newSize = context.size;
    if (oldSize == newSize || newSize == null) return;

    // If the size has changed, call the callback.
    oldSize = newSize;
    widget.onChange(newSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: widgetKey, child: widget.child);
  }
}
