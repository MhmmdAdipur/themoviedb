part of 'pages.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String query;
  final movieController = Get.find<MovieController>();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  Rx<List<Movie>?> movies = Rx<List<Movie>?>(null);
  Rx<bool> hasReachedMax = Rx<bool>(false);
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    query = Get.parameters['query']!;
    searchMovies();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  searchMovies({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        movies.update((val) {
          movies = Rx<List<Movie>?>(null);
        });
        hasReachedMax(false);
        currentPage = 1;
      }
      ServiceResult serviceResult =
          await movieController.searchMovies(query, currentPage);

      if (serviceResult.isError) {
        SharedMethod.getSnackBar(
            title: 'Something Went Wrong',
            message: '${serviceResult.message}',
            isError: true);
        if (serviceResult.data.runtimeType == bool) {
          hasReachedMax(true);
          movies([]);
        }
      } else {
        if (movies.isRxNull) {
          movies(serviceResult.data['result']);
        } else {
          movies.update((val) {
            val!.addAll(serviceResult.data['result']);
          });
        }
        currentPage += 1;
        if (currentPage > serviceResult.data['total_pages']) {
          hasReachedMax(true);
          SharedMethod.getSnackBar(
              title: 'Has Reached Max',
              message:
                  'The movie with the keyword "$query" has reached its end',
              isError: true);
        }
      }
    } on FormatException catch (e) {
      movies([]);
      SharedMethod.getSnackBar(
          title: 'Something Went Wrong', message: e.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your keyword "$query"',
          style: TextStyle(color: SharedValue.blackColor),
        ),
        centerTitle: false,
        backgroundColor: SharedValue.whiteColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            highlightColor: SharedValue.primaryColor.withOpacity(.1),
            splashColor: SharedValue.primaryColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(11),
            child: Icon(EvaIcons.arrowIosBackOutline,
                color: SharedValue.blackColor),
            onTap: () => Get.back(),
          ),
        ),
      ),
      body: Obx(
        () => ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SmartRefresher(
            controller: refreshController,
            physics: const BouncingScrollPhysics(),
            header: WaterDropMaterialHeader(
                backgroundColor: SharedValue.primaryColor),
            enablePullUp: !hasReachedMax.value,
            onRefresh: () async {
              await searchMovies(isRefresh: true);
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              await searchMovies();
              refreshController.loadComplete();
            },
            child: movies.isRxNull
                ? const LoadingBuilderWidget()
                : movies.value!.isEmpty
                    ? Column(
                        children: [
                          Lottie.asset('assets/animations/empty-box.json'),
                          const Text('Not Found',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 5),
                          Text('The movie with the keyword "$query" not found')
                        ],
                      )
                    : ListView.builder(
                        key: const PageStorageKey('search'),
                        itemCount: movies.value!.length * 2,
                        itemBuilder: (context, index) {
                          if (index.isOdd) {
                            return const SizedBox(height: 13);
                          } else {
                            Movie movie = movies.value![index ~/ 2];
                            return RecommendedCardWidget(movie: movie);
                          }
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
