import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// this file is used to add custom scroll bar,
// in case user wants to show a larger list in drop down overlay
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 300);
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 600);

class CustomScrollbar extends StatefulWidget {
  const CustomScrollbar({
    Key? key,
    required this.child,
    required this.controller,
    this.isAlwaysShown = false,
    this.scrollbarThickness: 2.0,
  }) : super(key: key);

  final Widget child;

  final ScrollController controller;

  final bool isAlwaysShown;

  final scrollbarThickness;
  @override
  _CustomScrollbarState createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar>
    with TickerProviderStateMixin {
  ScrollbarPainter? _materialPainter;
  TextDirection? _textDirection;
  Color? _themeColor;
  bool? _useCupertinoScrollbar;
  late AnimationController _fadeoutAnimationController;
  late Animation<double>? _fadeoutOpacityAnimation;
  Timer? _fadeoutTimer;

  @override
  void initState() {
    super.initState();
    _fadeoutAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarFadeDuration,
    );
    _fadeoutOpacityAnimation = CurvedAnimation(
      parent: _fadeoutAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert((() {
      _useCupertinoScrollbar = null;
      return true;
    })());
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // On iOS, stop all local animations. CupertinoScrollbar has its own
        // animations.
        _fadeoutTimer?.cancel();
        _fadeoutTimer = null;
        _fadeoutAnimationController.reset();
        _useCupertinoScrollbar = true;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _themeColor = theme.highlightColor.withOpacity(1.0);
        _textDirection = Directionality.of(context);
        _materialPainter = _buildMaterialScrollbarPainter();
        _useCupertinoScrollbar = false;
        WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
          if (widget.isAlwaysShown) {
            assert(widget.controller != null);
            // Wait one frame and cause an empty scroll event.  This allows the
            // thumb to show immediately when isAlwaysShown is true.  A scroll
            // event is required in order to paint the thumb.
            widget.controller.position.didUpdateScrollPositionBy(0);
          }
        });
        break;
    }
    assert(_useCupertinoScrollbar != null);
  }

  @override
  void didUpdateWidget(CustomScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAlwaysShown != oldWidget.isAlwaysShown) {
      assert(widget.controller != null);
      if (widget.isAlwaysShown == false) {
        _fadeoutAnimationController.reverse();
      } else {
        _fadeoutAnimationController.animateTo(1.0);
      }
    }
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      color: _themeColor!,
      textDirection: _textDirection,
      thickness: widget.scrollbarThickness,
      fadeoutOpacityAnimation: _fadeoutOpacityAnimation!,
      padding: MediaQuery.of(context).padding,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    if (metrics.maxScrollExtent <= metrics.minScrollExtent) {
      return false;
    }

    // iOS sub-delegates to the CupertinoScrollbar instead and doesn't handle
    // scroll notifications here.
    if (!_useCupertinoScrollbar! &&
        (notification is ScrollUpdateNotification ||
            notification is OverscrollNotification)) {
      if (_fadeoutAnimationController.status != AnimationStatus.forward) {
        _fadeoutAnimationController.forward();
      }

      _materialPainter!.update(
        notification.metrics,
        notification.metrics.axisDirection,
      );
      if (!widget.isAlwaysShown) {
        _fadeoutTimer?.cancel();
        _fadeoutTimer = Timer(_kScrollbarTimeToFade, () {
          _fadeoutAnimationController.reverse();
          _fadeoutTimer = null;
        });
      }
    }
    return false;
  }

  @override
  void dispose() {
    _fadeoutAnimationController.dispose();
    _fadeoutTimer?.cancel();
    _materialPainter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useCupertinoScrollbar!) {
      return CupertinoScrollbar(
        child: widget.child,
        isAlwaysShown: widget.isAlwaysShown,
        controller: widget.controller,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RepaintBoundary(
        child: CustomPaint(
          foregroundPainter: _materialPainter,
          child: RepaintBoundary(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
