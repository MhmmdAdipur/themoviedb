part of 'pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int bottomNavBarIndex;
  late PageController pageController;
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  final movieController = Get.find<MovieController>();

  @override
  void initState() {
    super.initState();
    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScrollToHideWidget(
                      controller: scrollController,
                      height: 66,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 15, bottom: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Hello,'),
                                    Text(
                                      'Muhammad Adi Purwanto',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 27),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: const CustomCacheImage(
                                  imageUrl:
                                      'https://picsum.photos/id/1005/400/266',
                                  width: 47,
                                  height: 47),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            bottomNavBarIndex = index;
                          });
                        },
                        children: [
                          HomePage(scrollController: scrollController),
                          MoviesPage(scrollController: scrollController)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ScrollToHideWidget(
                  controller: scrollController,
                  height: 80,
                  child: Wrap(
                    children: [
                      CustomNavbarWidget(
                          index: bottomNavBarIndex,
                          menuItems: const [
                            {
                              'icon': CupertinoIcons.house_alt_fill,
                              'label': 'Home'
                            },
                            {
                              'icon': EvaIcons.filmOutline,
                              'label': 'Movies',
                            },
                          ],
                          pageController: pageController),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
