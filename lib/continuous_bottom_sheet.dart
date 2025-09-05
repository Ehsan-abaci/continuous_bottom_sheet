library continuous_bottom_sheet;

import 'package:continuous_bottom_sheet/continuous_bottom_sheet_controller.dart';
import 'package:flutter/material.dart';

export 'continuous_bottom_sheet_controller.dart';

/// A convenience function to show a [ContinuousBottomSheet].
///
/// This function wraps Flutter's `showModalBottomSheet` and provides a simple
/// way to display the swipeable, resizing bottom sheet.
///
/// [context]: The BuildContext from which to launch the sheet.
/// [controller]: The [ContinuousBottomSheetController] to control the sheet.
/// [pages]: A list of widgets to display as pages.
/// [backgroundColor], [shape], etc.: Optional parameters to customize the
/// appearance and behavior of the bottom sheet.
void showContinuousBottomSheet({
  required BuildContext context,
  required ContinuousBottomSheetController controller,
  required List<Widget> pages,
  Color? backgroundColor,
  ShapeBorder? shape,
  Clip clipBehavior = Clip.antiAlias,
  Duration heightAnimationDuration = const Duration(milliseconds: 300),
  Curve heightAnimationCurve = Curves.easeInOutCubic,
  Duration pageSlideAnimationDuration = const Duration(milliseconds: 400),
  Curve pageSlideAnimationCurve = Curves.easeInOutCubic,
  ScrollPhysics? physics,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => ContinuousBottomSheet(
          controller: controller,
          pages: pages,
          backgroundColor: backgroundColor,
          shape: shape,
          clipBehavior: clipBehavior,
          heightAnimationDuration: heightAnimationDuration,
          heightAnimationCurve: heightAnimationCurve,
          pageSlideAnimationDuration: pageSlideAnimationDuration,
          pageSlideAnimationCurve: pageSlideAnimationCurve,
          physics: physics,
        ),
  );
}
