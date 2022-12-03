part of 'widgets.dart';

class ScrollToHideWidget extends StatefulWidget {
  final ScrollController controller;
  final Duration duration;
  final double height;
  final Widget child;
  final bool isEnableToHide;

  const ScrollToHideWidget({
    super.key,
    required this.child,
    required this.controller,
    required this.height,
    this.duration = const Duration(milliseconds: 200),
    this.isEnableToHide = true,
  });

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      if (!isVisible) setState(() => isVisible = true);
    } else if (direction == ScrollDirection.reverse) {
      if (isVisible) setState(() => isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: widget.isEnableToHide
          ? isVisible
              ? widget.height
              : 0
          : widget.height,
      child: widget.child,
    );
  }
}
