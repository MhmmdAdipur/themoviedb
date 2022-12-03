part of 'widgets.dart';

class CustomTabIndicator extends Decoration {
  final double height;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;
  final Color color;
  final double leftPadding;
  final double bottomPadding;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  const CustomTabIndicator({
    this.height = 4,
    this.topRightRadius = 5,
    this.topLeftRadius = 5,
    this.bottomPadding = 0,
    this.bottomRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.color = Colors.black,
    this.leftPadding = 0,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 2,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
        height: height,
        leftPadding: leftPadding,
        topRightRadius: topRightRadius,
        bottomPadding: bottomPadding,
        topLeftRadius: topLeftRadius,
        bottomRightRadius: bottomRightRadius,
        bottomLeftRadius: bottomLeftRadius,
        color: color,
        paintingStyle: paintingStyle,
        strokeWidth: strokeWidth);
  }
}

class _CustomPainter extends BoxPainter {
  final double height;
  final double leftPadding;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomRightRadius;
  final double bottomPadding;
  final double bottomLeftRadius;
  final Color color;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  _CustomPainter({
    required this.height,
    required this.leftPadding,
    required this.bottomPadding,
    required this.topRightRadius,
    required this.topLeftRadius,
    required this.bottomRightRadius,
    required this.bottomLeftRadius,
    required this.color,
    required this.paintingStyle,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Size mysize = Size(configuration.size!.width * .3, height);

    Offset myoffset = Offset(offset.dx + leftPadding,
        offset.dy + configuration.size!.height - height - bottomPadding);

    final Rect rect = myoffset & mysize;
    final Paint paint = Paint();
    paint.color = color;
    paint.style = paintingStyle;
    paint.strokeWidth = strokeWidth;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomRight: Radius.circular(bottomRightRadius),
          bottomLeft: Radius.circular(bottomLeftRadius),
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
        ),
        paint);
  }
}
