import 'dart:async' show Completer;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;

/// Measures a widget's height by rendering it invisibly in an Overlay.
Future<double> getOffstageWidgetHeight(Widget widget, BuildContext context) {
  final completer = Completer<double>();
  final GlobalKey widgetKey = GlobalKey();

  final entry = OverlayEntry(
    builder:
        (_) => Opacity(
          opacity: 0,
          child: Center(
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Material(
                type: MaterialType.transparency,
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

  Overlay.of(context).insert(entry);

  return completer.future.whenComplete(() => entry.remove());
}

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
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  @override
  void didUpdateWidget(covariant WidgetSize oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  void postFrameCallback(_) {
    final context = widgetKey.currentContext;
    if (context == null) return;

    final newSize = context.size;
    if (oldSize == newSize || newSize == null) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: widgetKey, child: widget.child);
  }
}
