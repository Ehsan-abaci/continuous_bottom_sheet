import 'dart:async';
import 'package:continuous_bottom_sheet/fade_transition_page_route_builder.dart';
import 'package:continuous_bottom_sheet/helper/measurement_helper.dart';
import 'package:flutter/material.dart';

/// Controller for the [ContinuousBottomSheet].
///
/// This controller allows you to programmatically push, pop, and close the bottom sheet.
class ContinuousBottomSheetController {
  _ContinuousBottomSheetState? _state;

  /// Pushes a new page onto the bottom sheet's navigation stack.
  Future<T?>? push<T extends Object?>(Widget page) => _state?._push(page);

  /// Whether the bottom sheet can be popped.
  bool canPop() => _state?._canPop() ?? false;

  /// Pops the top-most page from the bottom sheet's navigation stack.
  void pop<T extends Object?>([T? result]) => _state?._pop(result);

  /// Closes the entire bottom sheet.
  void close() => _state?._close();

  /// Attaches the controller to the bottom sheet's state.
  void _attach(_ContinuousBottomSheetState state) => _state = state;

  /// Detaches the controller from the bottom sheet's state.
  void _detach() => _state = null;
}

/// A [RouteObserver] that calls callbacks when routes are pushed or popped.
class _MyRouteObserver extends RouteObserver<PageRoute> {
  final void Function(PageRoute<dynamic> route) onRoutePushed;
  final void Function(PageRoute<dynamic> route) onRoutePopped;

  _MyRouteObserver({required this.onRoutePushed, required this.onRoutePopped});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      onRoutePushed(route);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      onRoutePopped(route);
    }
    super.didPop(route, previousRoute);
  }
}

/// The main widget for the continuous bottom sheet.
class ContinuousBottomSheet extends StatefulWidget {
  const ContinuousBottomSheet({
    super.key,
    required this.controller,
    required this.initialPage,
    this.heightAnimationDuration = const Duration(milliseconds: 300),
    this.heightAnimationCurve = Curves.easeInOutCubic,
    this.pageSlideAnimationDuration = const Duration(milliseconds: 400),
    this.pageSlideAnimationCurve = Curves.easeInOutCubic,
  });

  final ContinuousBottomSheetController controller;
  final Widget initialPage;
  final Duration heightAnimationDuration;
  final Curve heightAnimationCurve;
  final Duration pageSlideAnimationDuration;
  final Curve pageSlideAnimationCurve;

  @override
  State<ContinuousBottomSheet> createState() => _ContinuousBottomSheetState();
}

class _ContinuousBottomSheetState extends State<ContinuousBottomSheet> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final _MyRouteObserver _routeObserver;
  final _routeStack = <PageRoute>[];
  final _heights = <PageRoute, double>{};
  double _targetHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
    _routeObserver = _MyRouteObserver(
      onRoutePushed: (route) {
        _routeStack.add(route);
        // Measure and set the height of the new page after the frame is rendered.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _measureAndSetHeight(route);
        });
      },
      onRoutePopped: (route) {
        _heights.remove(route);
        _routeStack.removeLast();
        // If there are still pages in the stack, update the height to the previous page's height.
        if (_routeStack.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _measureAndSetHeight(_routeStack.last);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    widget.controller._detach();
    super.dispose();
  }

  /// Measures the height of a route's page and updates the bottom sheet's height.
  Future<void> _measureAndSetHeight(PageRoute route) async {
    // If the height is already cached, use it.
    if (_heights.containsKey(route)) {
      if (mounted && _targetHeight != _heights[route]) {
        setState(() => _targetHeight = _heights[route]!);
      }
      return;
    }
    // Otherwise, measure the height of the widget offstage.
    final newHeight = await getOffstageWidgetHeight(
      Builder(
        builder: (context) => route.buildPage(
          context,
          const AlwaysStoppedAnimation(1),
          const AlwaysStoppedAnimation(1),
        ),
      ),
      context,
    );
    // Update the height if the widget is still mounted.
    if (mounted && newHeight > 0) {
      _heights[route] = newHeight;
      if (mounted && _targetHeight != newHeight) {
        setState(() => _targetHeight = newHeight);
      }
    }
  }

  /// Pushes a new page onto the navigator stack.
  Future<T?>? _push<T extends Object?>(Widget page) {
    return _navigatorKey.currentState?.push<T>(
      FadeTransitionPageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SingleChildScrollView(child: page),
        pageSlideAnimationCurve: widget.pageSlideAnimationCurve,
        transitionDuration: widget.pageSlideAnimationDuration,
        reverseTransitionDuration: widget.pageSlideAnimationDuration,
      ),
    );
  }

  /// Checks if the navigator can pop a page.
  bool _canPop() {
    return _navigatorKey.currentState?.canPop() ?? false;
  }

  /// Pops the top-most page from the navigator stack.
  void _pop<T extends Object?>([T? result]) {
    _navigatorKey.currentState?.pop(result);
  }

  /// Closes the bottom sheet.
  void _close() {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Animate the height of the bottom sheet when it changes.
    return AnimatedContainer(
      duration: widget.heightAnimationDuration,
      curve: widget.heightAnimationCurve,
      height: _targetHeight,
      // The navigator that manages the pages within the bottom sheet.
      child: Navigator(
        key: _navigatorKey,
        observers: [_routeObserver],
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            FadeTransitionPageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SingleChildScrollView(child: widget.initialPage),
              pageSlideAnimationCurve: widget.pageSlideAnimationCurve,
              transitionDuration: widget.pageSlideAnimationDuration,
              reverseTransitionDuration: widget.pageSlideAnimationDuration,
            ),
          ];
        },
      ),
    );
  }
}