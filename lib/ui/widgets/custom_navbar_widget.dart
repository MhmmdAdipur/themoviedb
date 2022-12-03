// ignore_for_file: must_be_immutable

part of 'widgets.dart';

class CustomNavbarWidget extends StatefulWidget {
  int index;
  final List<Map> menuItems;
  final PageController pageController;

  CustomNavbarWidget({
    super.key,
    required this.index,
    required this.menuItems,
    required this.pageController,
  });

  @override
  State<CustomNavbarWidget> createState() => _CustomNavbarWidgetState();
}

class _CustomNavbarWidgetState extends State<CustomNavbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: SharedValue.primaryColor,
          borderRadius: BorderRadius.circular(31)),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.menuItems.length,
          (index) => generateItemNavbar(index, context),
        ),
      ),
    );
  }

  Widget generateItemNavbar(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.index = index;
          widget.pageController.jumpToPage(index);
        });
      },
      borderRadius: BorderRadius.circular(8),
      highlightColor: Colors.white.withOpacity(.2),
      splashColor: Colors.white.withOpacity(.1),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .15,
        height: 45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.menuItems[index]['icon'],
              color: Colors.white,
              size: 20,
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(fontSize: widget.index == index ? 12 : 0),
              child: Text(
                widget.menuItems[index]['label'],
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
