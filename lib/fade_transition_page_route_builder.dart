
import 'package:flutter/material.dart';

class FadeTransitionPageRouteBuilder<T> extends PageRoute<T> {
  final RoutePageBuilder pageBuilder;
  final Curve pageSlideAnimationCurve;

  FadeTransitionPageRouteBuilder({
    super.settings,
    super.requestFocus,
    super.fullscreenDialog,
    super.allowSnapshotting,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    required this.pageBuilder,
    required this.pageSlideAnimationCurve,
  });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final enterFadeTween = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 50.0),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: pageSlideAnimationCurve)),
        weight: 50.0,
      ),
    ]);
    final exitFadeTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: pageSlideAnimationCurve)),
        weight: 50.0,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 50.0),
    ]);

    return FadeTransition(
      opacity: exitFadeTween.animate(secondaryAnimation),
      child: FadeTransition(
        opacity: enterFadeTween.animate(animation),
        child: child,
      ),
    );
  }

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;
}
