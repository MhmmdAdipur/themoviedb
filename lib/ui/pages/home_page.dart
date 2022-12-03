part of 'pages.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  const HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final movieController = Get.find<MovieController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  onSearch() {
    if (textEditingController.text.trim().isNotEmpty) {
      FocusManager.instance.primaryFocus!.unfocus();
      if (textEditingController.text.trim().length < 3) {
        SharedMethod.getSnackBar(
            title: 'Something Went Wrong',
            message: 'Keywords are too short, be more specific.',
            isError: true);
      } else {
        Get.toNamed('${RouteName.search}/${textEditingController.text.trim()}');
      }
    }
  }

  onRefresh() async {
    movieController.loadMoviesRecommended(isRefresh: true);
    movieController.loadMoviesNowPlaying(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          const SizedBox(height: 10),
          CustomTextField(
              textEditingController: textEditingController,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(7),
              hintText: 'Search here ...',
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              onSubmitted: (value) => onSearch(),
              textInputAction: TextInputAction.go,
              leadingChildren: [
                GestureDetector(
                  onTap: onSearch,
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                        color: SharedValue.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(EvaIcons.search,
                        color: Colors.white, size: 18),
                  ),
                )
              ]),
          const SizedBox(height: 10),
          ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: Expanded(
              child: SmartRefresher(
                controller: refreshController,
                header:
                    const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
                enablePullUp: !movieController.recommendedHasReachedMax.value,
                onRefresh: () async {
                  await onRefresh();
                  refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await movieController.loadMoviesRecommended();
                  refreshController.loadComplete();
                },
                child: ListView(
                    controller: widget.scrollController,
                    key: const PageStorageKey('home'),
                    children: [
                      generateSeparatorTitle(
                          icon: EvaIcons.playCircleOutline,
                          label: 'Now Playing'),
                      SizedBox(
                        height: Get.height * .305,
                        child: movieController.listMoviesNowPlaying.isRxNull
                            ? const LoadingBuilderWidget()
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: movieController.listMoviesNowPlaying
                                            .value!.length *
                                        2 +
                                    1,
                                itemBuilder: (context, index) {
                                  if (index >
                                      movieController.listMoviesNowPlaying
                                              .value!.length *
                                          2) {
                                    return const SizedBox(width: 16);
                                  } else if (index.isEven) {
                                    return const SizedBox(width: 16);
                                  } else {
                                    Movie movie = movieController
                                        .listMoviesNowPlaying
                                        .value![index ~/ 2];
                                    return NowPlayingCardWidget(movie: movie);
                                  }
                                },
                              ),
                      ),
                      generateSeparatorTitle(
                          icon: EvaIcons.starOutline,
                          label: 'Recommendation from us'),
                      SizedBox(
                        child: movieController.listMoviesRecommended.isRxNull
                            ? const LoadingBuilderWidget()
                            : Column(
                                children: List.generate(
                                    movieController.listMoviesRecommended.value!
                                            .length *
                                        2, (index) {
                                  if (index.isOdd) {
                                    return const SizedBox(height: 13);
                                  } else {
                                    Movie movie = movieController
                                        .listMoviesRecommended
                                        .value![index ~/ 2];
                                    return RecommendedCardWidget(movie: movie);
                                  }
                                }),
                              ),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateSeparatorTitle(
      {required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(icon, size: 22, color: SharedValue.primaryColor),
              const SizedBox(width: 5),
              AutoSizeText(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
