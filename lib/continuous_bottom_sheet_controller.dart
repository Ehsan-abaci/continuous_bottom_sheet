import 'dart:async';
import 'package:continuous_bottom_sheet/helper/measurement_helper.dart';
import 'package:flutter/material.dart';

/// A controller for managing the state of a [ContinuousBottomSheet].
///
/// This controller allows you to programmatically navigate between pages
/// or close the entire bottom sheet.
class ContinuousBottomSheetController {
  _ContinuousBottomSheetState? _state;

  /// The total number of pages in the bottom sheet.
  int get pageCount => _state?.widget.pages.length ?? 0;

  /// The index of the currently visible page.
  int get currentPage => _state?._pageController.page?.round() ?? 0;

  /// Animates to the next page in the bottom sheet.
  void nextPage() => _state?._nextPage();

  /// Animates to the previous page in the bottom sheet.
  void previousPage() => _state?._previousPage();

  /// Animates to the specified page index.
  void animateToPage(int page) => _state?._animateToPage(page);

  /// Jumps directly to the specified page index without animation.
  void jumpToPage(int page) => _state?._jumpToPage(page);

  /// Closes the entire bottom sheet.
  void close() => _state?._close();

  void _attach(_ContinuousBottomSheetState state) => _state = state;
  void _detach() => _state = null;
}

/// A modal bottom sheet with multiple, swipeable pages, where each
/// page can have a different height, and the sheet animates between heights.
class ContinuousBottomSheet extends StatefulWidget {
  const ContinuousBottomSheet({
    super.key,
    required this.controller,
    required this.pages,
    this.backgroundColor,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
    this.heightAnimationDuration = const Duration(milliseconds: 300),
    this.heightAnimationCurve = Curves.easeInOutCubic,
    this.pageSlideAnimationDuration = const Duration(milliseconds: 400),
    this.pageSlideAnimationCurve = Curves.easeInOutCubic,
    this.physics,
  });

  /// The controller to programmatically control the bottom sheet.
  final ContinuousBottomSheetController controller;

  /// The list of widgets to display as pages.
  final List<Widget> pages;

  /// The background color of the bottom sheet.
  final Color? backgroundColor;

  /// The shape of the bottom sheet.
  final ShapeBorder? shape;

  /// The clipping behavior for the bottom sheet container.
  final Clip clipBehavior;

  /// The duration of the height change animation.
  final Duration heightAnimationDuration;

  /// The curve of the height change animation.
  final Curve heightAnimationCurve;

  /// The duration of the page slide animation when using controller methods.
  final Duration pageSlideAnimationDuration;

  /// The curve of the page slide animation when using controller methods.
  final Curve pageSlideAnimationCurve;

  /// The physics for the PageView, controlling the swipe behavior.
  final ScrollPhysics? physics;

  @override
  State<ContinuousBottomSheet> createState() => _ContinuousBottomSheetState();
}

class _ContinuousBottomSheetState extends State<ContinuousBottomSheet> {
  final _pageController = PageController();
  final _heights = <int, double>{}; // Cache measured heights for performance
  double _targetHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);

    // Measure the initial page after the first frame has been rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pages.isNotEmpty) {
        _measureAndSetHeight(0);
      }
    });
  }

  @override
  void dispose() {
    widget.controller._detach();
    _pageController.dispose();
    super.dispose();
  }

  /// Called by the PageView's onPageChanged callback when a swipe completes.
  void _onPageSwiped(int pageIndex) {
    _measureAndSetHeight(pageIndex);
  }

  /// Measures a widget's height offstage and then updates the state to
  /// animate the AnimatedContainer to the new height.
  Future<void> _measureAndSetHeight(int pageIndex) async {
    // Use cached height if available to avoid re-measuring on every swipe.
    if (_heights.containsKey(pageIndex)) {
      if (mounted && _targetHeight != _heights[pageIndex]) {
        setState(() => _targetHeight = _heights[pageIndex]!);
      }
      return;
    }

    final page = widget.pages[pageIndex];
    final newHeight = await getOffstageWidgetHeight(page, context);

    if (mounted && newHeight > 0) {
      _heights[pageIndex] = newHeight; // Cache the new height
      // Only update state if this is the currently viewed page
      if ((_pageController.page?.round() ?? 0) == pageIndex &&
          _targetHeight != newHeight) {
        setState(() => _targetHeight = newHeight);
      }
    }
  }

  void _animateToPage(int page) {
    if (page >= 0 && page < widget.pages.length) {
      _pageController.animateToPage(
        page,
        duration: widget.pageSlideAnimationDuration,
        curve: widget.pageSlideAnimationCurve,
      );
    }
  }

  void _jumpToPage(int page) {
    if (page >= 0 && page < widget.pages.length) {
      _pageController.jumpToPage(page);
    }
  }

  void _nextPage() {
    final currentPage = _pageController.page?.round() ?? 0;
    if (currentPage < widget.pages.length - 1) {
      _animateToPage(currentPage + 1);
    }
  }

  void _previousPage() {
    final currentPage = _pageController.page?.round() ?? 0;
    if (currentPage > 0) {
      _animateToPage(currentPage - 1);
    } else {
      _close();
    }
  }

  void _close() {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: widget.heightAnimationDuration,
      curve: widget.heightAnimationCurve,
      height: _targetHeight,
      child: Material(
        color: widget.backgroundColor ?? theme.bottomSheetTheme.backgroundColor,
        shape: widget.shape ?? theme.bottomSheetTheme.shape,
        clipBehavior: widget.clipBehavior,
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageSwiped,
          physics: widget.physics,
          children:
              widget.pages.map((p) => SingleChildScrollView(child: p)).toList(),
        ),
      ),
    );
  }
}
