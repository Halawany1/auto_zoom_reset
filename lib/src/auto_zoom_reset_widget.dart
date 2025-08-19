import 'package:flutter/material.dart';

/// A widget that wraps [InteractiveViewer] with automatic zoom reset functionality.
///
/// This widget allows users to pinch-to-zoom and pan content, but automatically
/// resets to the original scale and position after the interaction ends.
/// Perfect for image galleries, product viewers, and any content that needs
/// temporary zoom capabilities.
class AutoZoomReset extends StatefulWidget {
  /// The widget to be displayed and interacted with.
  final Widget child;

  /// Whether zooming and panning are enabled. Defaults to true.
  final bool zoomEnabled;

  /// The duration of the reset animation. Defaults to 300 milliseconds.
  final Duration resetDuration;

  /// The curve used for the reset animation. Defaults to [Curves.easeInOut].
  final Curve resetCurve;

  /// Delay before auto-reset starts. Defaults to 500 milliseconds.
  /// Set to [Duration.zero] for immediate reset.
  final Duration resetDelay;

  /// Minimum scale factor. Defaults to 0.8.
  final double minScale;

  /// Maximum scale factor. Defaults to 4.0.
  final double maxScale;

  /// Whether to enable boundary constraints. Defaults to true.
  final bool constrained;

  /// Callback invoked when zoom interaction starts.
  final VoidCallback? onZoomStart;

  /// Callback invoked when zoom interaction ends.
  final VoidCallback? onZoomEnd;

  /// Callback invoked when reset animation starts.
  final VoidCallback? onResetStart;

  /// Callback invoked when reset animation completes.
  final VoidCallback? onResetComplete;

  /// Callback invoked during zoom with current scale value.
  final ValueChanged<double>? onScaleChanged;

  /// Whether to show a subtle visual feedback during zoom.
  final bool showZoomIndicator;

  /// Color of the zoom indicator. Defaults to semi-transparent white.
  final Color indicatorColor;

  const AutoZoomReset({
    super.key,
    required this.child,
    this.zoomEnabled = true,
    this.resetDuration = const Duration(milliseconds: 300),
    this.resetCurve = Curves.easeInOut,
    this.resetDelay = const Duration(milliseconds: 500),
    this.minScale = 0.8,
    this.maxScale = 4.0,
    this.constrained = true,
    this.onZoomStart,
    this.onZoomEnd,
    this.onResetStart,
    this.onResetComplete,
    this.onScaleChanged,
    this.showZoomIndicator = false,
    this.indicatorColor = const Color(0x33FFFFFF),
  });

  @override
  State<AutoZoomReset> createState() => _AutoZoomResetState();
}

class _AutoZoomResetState extends State<AutoZoomReset>
    with TickerProviderStateMixin {
  late final ValueNotifier<Matrix4> _controller;
  late final AnimationController _resetAnimationController;
  late Animation<Matrix4> _resetAnimation;

  Matrix4 _initialMatrix = Matrix4.identity();
  bool _isZoomInProgress = false;
  double _currentScale = 1.0;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier<Matrix4>(Matrix4.identity());
    _resetAnimationController = AnimationController(
      duration: widget.resetDuration,
      vsync: this,
    );

    _resetAnimationController.addListener(_onResetAnimationUpdate);
    _resetAnimationController.addStatusListener(_onResetAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant AutoZoomReset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetDuration != oldWidget.resetDuration) {
      _resetAnimationController.duration = widget.resetDuration;
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (_isResetting) return;
    _initialMatrix = _controller.value;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_isResetting) return;

    // Calculate the new transformation matrix with proper scaling
    final double scale = details.scale.clamp(widget.minScale, widget.maxScale);
    final Matrix4 matrix = Matrix4.identity()..scale(scale);

    _controller.value = matrix;
    _currentScale = scale;

    // Trigger zoom start callback
    if (scale > 1.01 && !_isZoomInProgress) {
      _isZoomInProgress = true;
      widget.onZoomStart?.call();
    }

    widget.onScaleChanged?.call(scale);
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (_isResetting || !_isZoomInProgress) return;
    _scheduleReset();
  }

  void _scheduleReset() {
    if (widget.resetDelay == Duration.zero) {
      _startReset();
    } else {
      Future.delayed(widget.resetDelay, () {
        if (mounted && _isZoomInProgress && !_isResetting) {
          _startReset();
        }
      });
    }
  }

  void _startReset() {
    if (!mounted || _isResetting) return;

    _isResetting = true;
    widget.onResetStart?.call();

    _resetAnimation = Matrix4Tween(
      begin: _controller.value,
      end: _initialMatrix,
    ).animate(CurvedAnimation(
      parent: _resetAnimationController,
      curve: widget.resetCurve,
    ));

    _resetAnimationController.forward(from: 0.0);
  }

  void _onResetAnimationUpdate() {
    if (mounted) {
      _controller.value = _resetAnimation.value;
    }
  }

  void _onResetAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isZoomInProgress = false;
      _isResetting = false;
      _currentScale = 1.0;
      widget.onZoomEnd?.call();
      widget.onResetComplete?.call();
    }
  }

  /// Manually trigger a reset to the original position and scale.
  void reset() {
    if (_isZoomInProgress && !_isResetting) {
      _startReset();
    }
  }

  /// Get the current scale factor.
  double get currentScale => _currentScale;

  /// Check if zoom is currently in progress.
  bool get isZoomed => _isZoomInProgress;

  @override
  Widget build(BuildContext context) {
    Widget child = GestureDetector(
      onScaleStart: widget.zoomEnabled ? _onScaleStart : null,
      onScaleUpdate: widget.zoomEnabled ? _onScaleUpdate : null,
      onScaleEnd: widget.zoomEnabled ? _onScaleEnd : null,
      child: Transform(
        transform: _controller.value,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );

    // Add zoom indicator overlay if enabled
    if (widget.showZoomIndicator) {
      child = Stack(
        children: [
          child,
          if (_isZoomInProgress)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.indicatorColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(_currentScale * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return child;
  }

  @override
  void dispose() {
    _resetAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

/// A convenience widget that provides a simple auto-zoom-reset functionality
/// with minimal configuration.
class SimpleAutoZoomReset extends StatelessWidget {
  /// The widget to be displayed and interacted with.
  final Widget child;

  /// Whether to show zoom percentage indicator.
  final bool showIndicator;

  const SimpleAutoZoomReset({
    super.key,
    required this.child,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return AutoZoomReset(
      showZoomIndicator: showIndicator,
      child: child,
    );
  }
}
