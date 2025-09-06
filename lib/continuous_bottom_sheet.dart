library continuous_bottom_sheet;

import 'package:continuous_bottom_sheet/continuous_bottom_sheet_controller.dart';
import 'package:flutter/material.dart';

export 'continuous_bottom_sheet_controller.dart';

/// A convenience function to show a [ContinuousBottomSheet].
///
/// This function wraps Flutter's `showModalBottomSheet` and provides a simple
/// way to display a swipeable, resizing bottom sheet that can navigate through
/// multiple pages. It's designed to be highly customizable.
///
/// [context]: The BuildContext from which to launch the sheet.
/// [controller]: The [ContinuousBottomSheetController] to control the sheet's pages.
/// [initialPage]: The widget to display as the first page in the bottom sheet.
/// [heightAnimationDuration], [heightAnimationCurve]: Controls the animation for height changes.
/// [pageSlideAnimationDuration], [pageSlideAnimationCurve]: Controls the fade transition between pages.
/// [backgroundColor]: The background color of the bottom sheet.
/// [elevation]: The z-coordinate at which to place this sheet.
/// [shape]: The shape of the bottom sheet.
/// [clipBehavior]: The content will be clipped (or not) according to this option.
/// [barrierColor]: The color of the modal barrier that darkens the main content.
/// [isDismissible]: If true, the bottom sheet will be dismissed when the user taps the scrim.
/// [enableDrag]: If true, the bottom sheet can be dragged up and down and dismissed by swiping downwards.
/// [useRootNavigator]: If true, the bottom sheet is pushed to the root navigator.
/// [useSafeArea]: If true, the bottom sheet will be padded to avoid system intrusions.
/// [routeSettings]: Settings for the route pushed by the bottom sheet.
/// [constraints]: Defines the maximum and minimum size of the bottom sheet.
void showContinuousBottomSheet({
  // Core required parameters
  required BuildContext context,
  required ContinuousBottomSheetController controller,
  required Widget initialPage,

  // Animation customizations
  Duration heightAnimationDuration = const Duration(milliseconds: 300),
  Curve heightAnimationCurve = Curves.easeInOutCubic,
  Duration pageSlideAnimationDuration = const Duration(milliseconds: 400),
  Curve pageSlideAnimationCurve = Curves.easeInOutCubic,

  // Modal sheet customizations (passed to showModalBottomSheet)
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  BoxConstraints? constraints,
}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) => ContinuousBottomSheet(
      controller: controller,
      initialPage: initialPage,
      heightAnimationDuration: heightAnimationDuration,
      heightAnimationCurve: heightAnimationCurve,
      pageSlideAnimationDuration: pageSlideAnimationDuration,
      pageSlideAnimationCurve: pageSlideAnimationCurve,
    ),
    // Configuration properties
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    useRootNavigator: useRootNavigator,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
    constraints: constraints,
    // isScrollControlled is managed internally by the widget's height animation
    isScrollControlled: false,
  );
}
