import 'package:flutter/material.dart';
import 'dart:math';
import 'package:async/async.dart';

enum Indicator {
  ballPulse,
  ballGridPulse,
  ballClipRotate,
  squareSpin,
  ballClipRotatePulse,
  ballClipRotateMultiple,
  ballPulseRise,
  ballRotate,
  cubeTransition,
  ballZigZag,
  ballZigZagDeflect,
  ballTrianglePath,
  ballTrianglePathColored,
  ballTrianglePathColoredFilled,
  ballScale,
  lineScale,
  lineScaleParty,
  ballScaleMultiple,
  ballPulseSync,
  ballBeat,
  lineScalePulseOut,
  lineScalePulseOutRapid,
  ballScaleRipple,
  ballScaleRippleMultiple,
  ballSpinFadeLoader,
  lineSpinFadeLoader,
  triangleSkewSpin,
  pacman,
  ballGridBeat,
  semiCircleSpin,
  ballRotateChase,
  orbit,
  audioEqualizer,
  circleStrokeSpin,
}

class CupertinoLoading extends StatelessWidget {
  const CupertinoLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: DecorateContext(
        decorateData: DecorateData(
            indicator: Indicator.lineSpinFadeLoader,
            colors: getListColor(),
            strokeWidth: 4),
        child: const AspectRatio(
          aspectRatio: 1,
          child: LineSpinFadeLoader(),
        ),
      ),
    );
  }
}

List<Color> getListColor() {
  final colors = <Color>[
    const Color(0xff036b6c),
    const Color(0xff028586),
    const Color(0xff039e9f),
    const Color(0xff03aaab),
    const Color(0xff05c6c7),
    const Color(0xff06ddde),
    const Color(0xff05ebec),
    const Color(0xff00fdff),
    const Color(0xff039e9f),
    const Color(0xff03aaab),
    const Color(0xff05c6c7),
    const Color(0xff06ddde),
    const Color(0xff05ebec),
    const Color(0xff00fdff),
  ];
  return colors;
}

/// LineSpinFadeLoader.
class LineSpinFadeLoader extends StatefulWidget {
  const LineSpinFadeLoader({Key? key}) : super(key: key);

  @override
  _LineSpinFadeLoaderState createState() => _LineSpinFadeLoaderState();
}

const int _kLineSize = 12;

class _LineSpinFadeLoaderState extends State<LineSpinFadeLoader>
    with TickerProviderStateMixin {
  static const _BEGIN_TIMES = [
    0,
    120,
    240,
    360,
    480,
    600,
    720,
    840,
    960,
    1080,
    1200,
    1320
  ];

  final List<AnimationController> _animationControllers = [];
  final List<Animation<double>> _opacityAnimations = [];
  final List<CancelableOperation<int>> _delayFeatures = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _kLineSize; i++) {
      _animationControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: 1),
        ),
      );
      _opacityAnimations.add(
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 0.7),
          TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.0), weight: 0.7),
        ]).animate(
          CurvedAnimation(
            parent: _animationControllers[i],
            curve: Curves.linear,
          ),
        ),
      );

      _delayFeatures.add(
        CancelableOperation.fromFuture(
          Future.delayed(Duration(milliseconds: _BEGIN_TIMES[i])).then((t) {
            _animationControllers[i].repeat();
            return 0;
          }),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final f in _delayFeatures) {
      f.cancel();
    }
    for (final f in _animationControllers) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraint) {
        final circleSize = constraint.maxWidth / 3;

        final widgets = List<Widget>.filled(_kLineSize, Container());
        final center =
            Offset(constraint.maxWidth / 2, constraint.maxHeight / 2);
        for (int i = 0; i < widgets.length; i++) {
          final angle = pi * i / 6;
          widgets[i] = Positioned.fromRect(
            rect: Rect.fromLTWH(
              center.dx + circleSize * (sin(angle)) - circleSize / 4,
              center.dy + circleSize * (cos(angle)) - circleSize / 2,
              circleSize / 2,
              circleSize,
            ),
            child: FadeTransition(
              opacity: _opacityAnimations[i],
              child: Transform.rotate(
                angle: -angle,
                child: IndicatorShapeWidget(
                  shape: Shape.line,
                  index: i,
                ),
              ),
            ),
          );
        }
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: widgets,
        );
      },
    );
  }
}

const double _kMinIndicatorSize = 24.0;

// This is indicator length
// should be = 1/6 * CupertinoLoading size
const double _kDefaultIndicatorRadius = 13.3;

/// Basic shape.
enum Shape {
  circle,
  ringThirdFour,
  rectangle,
  ringTwoHalfVertical,
  ring,
  line,
  triangle,
  arc,
  circleSemi,
}

/// Wrapper class for basic shape.
class IndicatorShapeWidget extends StatelessWidget {
  final Shape shape;
  final double? data;

  /// The index of shape in the widget.
  final int index;

  const IndicatorShapeWidget({
    Key? key,
    required this.shape,
    this.data,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DecorateData decorateData = DecorateContext.of(context)!.decorateData;
    final color = decorateData.colors[index % decorateData.colors.length];

    return Container(
      constraints: const BoxConstraints(
        minWidth: _kMinIndicatorSize,
        minHeight: _kMinIndicatorSize,
      ),
      child: CustomPaint(
        painter: _ShapePainter(
          color,
          shape,
          data,
          decorateData.strokeWidth,
          pathColor: decorateData.pathBackgroundColor,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final Color color;
  final Shape shape;
  final Paint _paint;
  final double? data;
  final double strokeWidth;
  final Color? pathColor;

  _ShapePainter(
    this.color,
    this.shape,
    this.data,
    this.strokeWidth, {
    this.pathColor,
  })  : _paint = Paint()..isAntiAlias = true,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    _paint.color = color;
    canvas.drawRRect(
        RRect.fromLTRBXY(
          -strokeWidth / 2, // left
          -_kDefaultIndicatorRadius / 3.0, // top
          strokeWidth / 2, // right
          -_kDefaultIndicatorRadius, // bottom
          strokeWidth / 2, // radX
          strokeWidth / 2, // radY
        ),
        _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) =>
      shape != oldDelegate.shape ||
      color != oldDelegate.color ||
      data != oldDelegate.data ||
      strokeWidth != oldDelegate.strokeWidth ||
      pathColor != oldDelegate.pathColor;
}

const double _kDefaultStrokeWidth = 2;

/// Information about a piece of animation (e.g., color).
@immutable
class DecorateData {
  final Color? backgroundColor;
  final Indicator indicator;

  /// It will promise at least one value in the collection.
  final List<Color> colors;
  final double? _strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  const DecorateData({
    required this.indicator,
    required this.colors,
    this.backgroundColor,
    double? strokeWidth,
    this.pathBackgroundColor,
  })  : _strokeWidth = strokeWidth,
        assert(colors.length > 0);

  double get strokeWidth => _strokeWidth ?? _kDefaultStrokeWidth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecorateData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          indicator == other.indicator &&
          colors == other.colors &&
          strokeWidth == other.strokeWidth;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      indicator.hashCode ^
      colors.hashCode ^
      strokeWidth.hashCode;

  @override
  String toString() {
    return 'DecorateData{backgroundColor: $backgroundColor,'
        ' indicator: $indicator, colors: $colors, strokeWidth: $strokeWidth}';
  }
}

/// Establishes a subtree in which decorate queries resolve to the given data.
class DecorateContext extends InheritedWidget {
  final DecorateData decorateData;

  const DecorateContext({
    Key? key,
    required this.decorateData,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(DecorateContext oldWidget) =>
      oldWidget.decorateData == decorateData;

  static DecorateContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}
