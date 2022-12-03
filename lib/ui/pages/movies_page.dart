part of 'pages.dart';

class MoviesPage extends StatefulWidget {
  final ScrollController scrollController;
  const MoviesPage({super.key, required this.scrollController});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final movieController = Get.find<MovieController>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  onRefresh() async {
    await movieController.loadMoviesPopular(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Theme(
            data: ThemeData(
                backgroundColor: Colors.red,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: tabController,
                labelColor: Colors.black,
                isScrollable: true,
                labelPadding: const EdgeInsets.symmetric(horizontal: 13),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                labelStyle: const TextStyle(
                    fontFamily: 'Inter', fontWeight: FontWeight.w500),
                unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Inter', fontWeight: FontWeight.w400),
                unselectedLabelColor: Colors.grey,
                indicator: CustomTabIndicator(
                  leftPadding: 13,
                  bottomPadding: 5,
                  color: SharedValue.primaryColor,
                  bottomLeftRadius: 20,
                  bottomRightRadius: 20,
                  topLeftRadius: 20,
                  topRightRadius: 20,
                ),
                tabs: const [
                  Tab(text: 'Movies Popular'),
                  Tab(text: 'TV Poular'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SmartRefresher(
                    controller: refreshController,
                    physics: const BouncingScrollPhysics(),
                    header: const ClassicHeader(
                        refreshStyle: RefreshStyle.UnFollow),
                    enablePullUp: !movieController.popularHasReachedMax.value,
                    onRefresh: () async {
                      await onRefresh();
                      refreshController.refreshCompleted();
                    },
                    onLoading: () async {
                      await movieController.loadMoviesPopular();
                      refreshController.loadComplete();
                    },
                    child: movieController.listMoviesPopular.isRxNull
                        ? const LoadingBuilderWidget()
                        : ListView.builder(
                            controller: widget.scrollController,
                            key: const PageStorageKey('moviesPopular'),
                            itemCount: movieController
                                    .listMoviesPopular.value!.length *
                                2,
                            itemBuilder: (context, index) {
                              if (index.isOdd) {
                                return const SizedBox(height: 13);
                              } else {
                                Movie movie = movieController
                                    .listMoviesPopular.value![index ~/ 2];
                                return RecommendedCardWidget(movie: movie);
                              }
                            },
                          ),
                  ),
                ),
                Column(
                  children: [
                    Lottie.asset('assets/animations/empty-box.json'),
                    const Text('Not Found',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    const Text('This feature is still under development')
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
