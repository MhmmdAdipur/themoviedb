part of 'pages.dart';

class DetailMoviePage extends StatefulWidget {
  const DetailMoviePage({super.key});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  final movieController = Get.find<MovieController>();
  ScreenshotController screenshotController = ScreenshotController();
  Rx<Movie?> movie = Rx<Movie?>(Get.arguments);
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    onStart();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  onStart() async {
    try {
      ServiceResult serviceResult =
          await movieController.getMovieDetail(Get.parameters['id']!);

      if (serviceResult.isError) {
        SharedMethod.getSnackBar(
            title: 'Something Went Wrong', message: serviceResult.message!);
      } else {
        if (Get.arguments == null) {
          movie(Movie.fromJSON(serviceResult.data));
        }
        movie.update((val) {
          movie(val!
              .copyWith(movieDetail: MovieDetail.fromJSON(serviceResult.data)));
        });
      }
    } on FormatException catch (e) {
      SharedMethod.getSnackBar(
          title: 'Something Went Wrong', message: e.message);
    }
  }

  getScreenshoot() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 1000))
        .then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final File imagePath =
            await File('${directory.path}/${movie.value!.id}.png').create();

        await imagePath.writeAsBytes(image);
        // ignore: deprecated_member_use
        await Share.shareFiles(
          [imagePath.path],
          text:
              '${movie.value!.title}\n${movie.value!.voteAverage.toDisplay}/10\n\n${movie.value!.overview}${movie.value!.movieDetail!.homepage == null ? '' : '\n\nCek selengkapnya di sini:\n${movie.value!.movieDetail!.homepage}'}',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SmartRefresher(
          controller: refreshController,
          header: WaterDropMaterialHeader(
            color: SharedValue.whiteColor,
            backgroundColor: SharedValue.primaryColor,
          ),
          onRefresh: () async {
            await onStart();
            refreshController.refreshCompleted();
          },
          child: movie.isRxNull
              ? const LoadingBuilderWidget()
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: Get.height * .33,
                      child: Stack(
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              children: [
                                if (movie.value!.backdropPath != null)
                                  CustomCacheImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/w780${movie.value!.backdropPath}',
                                      width: Get.width,
                                      height: Get.height * .33),
                                if (movie.value!.backdropPath == null)
                                  SizedBox(
                                      height: Get.height * .33,
                                      child: Lottie.asset(
                                          'assets/animations/404-sleep-cat.json')),
                                BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                    child: const SizedBox()),
                                Positioned(
                                    right: 16,
                                    bottom: 8,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: SharedValue.primaryColor,
                                      child: Text(
                                        movie.value!.isAdult! ? '18+' : 'SU',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: SharedValue.whiteColor),
                                      ),
                                    )),
                                Positioned(
                                  bottom: 8,
                                  child: Hero(
                                    tag: movie.value!.id,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      width: Get.width * .35,
                                      height: Get.height * .23,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: movie.value!.posterPath == null
                                            ? Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  'assets/images/icon.png',
                                                  width: Get.width * .15,
                                                ))
                                            : CustomCacheImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.value!.posterPath}',
                                                width: Get.width * .35,
                                                height: Get.height * .23),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SafeArea(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: SharedValue.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: const Icon(EvaIcons.arrowBack,
                                            color: Colors.white)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => getScreenshoot(),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: SharedValue.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Icon(EvaIcons.shareOutline,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            movie.value!.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                      if (movie.value!.voteAverage != null) {
                                        if ((index + 1) * 2 >
                                            movie.value!.voteAverage!) {
                                          return Icon(EvaIcons.starOutline,
                                              size: 18,
                                              color:
                                                  SharedValue.secondaryColor);
                                        } else {
                                          return Icon(EvaIcons.star,
                                              size: 18,
                                              color:
                                                  SharedValue.secondaryColor);
                                        }
                                      } else {
                                        return const SizedBox();
                                      }
                                    }) +
                                    [
                                      const SizedBox(width: 5),
                                      Text(
                                          movie.value!.voteAverage.toDisplay +
                                              (movie.value!.releaseDate == null
                                                  ? ''
                                                  : ' | ${DateFormat('MMM dd, yyyy').format(movie.value!.releaseDate!)}'),
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const AutoSizeText(
                            'Storyline',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          AutoSizeText(
                            movie.value!.overview,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          const AutoSizeText(
                            'Production Countries',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: movie.value!.movieDetail == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitWave(
                                          color: SharedValue.primaryColor,
                                          size: 24),
                                      const SizedBox(height: 5),
                                      const AutoSizeText(
                                          'Sedang memuat data...'),
                                    ],
                                  )
                                : movie.value!.movieDetail!.productionCountries!
                                        .isEmpty
                                    ? generateError(
                                        'This movie does not have production countries, in our database.')
                                    : Wrap(
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: List.generate(
                                            movie
                                                .value!
                                                .movieDetail!
                                                .productionCountries!
                                                .length, (index) {
                                          Map productionCountry = movie
                                              .value!
                                              .movieDetail!
                                              .productionCountries![index];
                                          return generateTextBlock(
                                              productionCountry['name']);
                                        }),
                                      ),
                          ),
                          const SizedBox(height: 10),
                          const AutoSizeText(
                            'Genres',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: movie.value!.movieDetail == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitWave(
                                          color: SharedValue.primaryColor,
                                          size: 24),
                                      const SizedBox(height: 5),
                                      const AutoSizeText(
                                          'Sedang memuat data...'),
                                    ],
                                  )
                                : movie.value!.movieDetail!.genres!.isEmpty
                                    ? generateError(
                                        'This movie does not have genres, in our database.')
                                    : Wrap(
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: List.generate(
                                            movie.value!.movieDetail!.genres!
                                                .length, (index) {
                                          String genre = movie.value!
                                              .movieDetail!.genres![index];
                                          return generateTextBlock(genre);
                                        }),
                                      ),
                          ),
                          const SizedBox(height: 10),
                          const AutoSizeText(
                            'Production Companies',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 80,
                            child: movie.value!.movieDetail == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitWave(
                                          color: SharedValue.primaryColor,
                                          size: 24),
                                      const SizedBox(height: 5),
                                      const AutoSizeText(
                                          'Sedang memuat data...'),
                                    ],
                                  )
                                : movie.value!.movieDetail!.productionCompanies!
                                        .isEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: generateError(
                                            'This movie does not have production companies, in our database.'),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: movie.value!.movieDetail!
                                                .productionCompanies!.length *
                                            2,
                                        itemBuilder: (context, index) {
                                          if (index.isOdd) {
                                            return const SizedBox(width: 10);
                                          } else {
                                            Map productionCompanies = movie
                                                    .value!
                                                    .movieDetail!
                                                    .productionCompanies![
                                                index ~/ 2];
                                            return SizedBox(
                                              width: 70,
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: productionCompanies[
                                                                'logo_path'] ==
                                                            null
                                                        ? SizedBox(
                                                            width: 40,
                                                            height: 40,
                                                            child: Image.asset(
                                                              'assets/images/icon.png',
                                                              width: 40,
                                                            ),
                                                          )
                                                        : CustomCacheImage(
                                                            imageUrl:
                                                                'https://image.tmdb.org/t/p/w500${productionCompanies['logo_path']}',
                                                            width: 40,
                                                            height: 40),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  AutoSizeText(
                                                    productionCompanies['name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget generateError(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(EvaIcons.closeCircleOutline,
            color: SharedValue.errorColor, size: 28),
        const SizedBox(width: 5),
        Expanded(
          child: AutoSizeText(
            message,
            style: TextStyle(color: SharedValue.errorColor),
          ),
        ),
      ],
    );
  }

  Widget generateTextBlock(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: SharedValue.primaryColor),
      child: AutoSizeText(
        name,
        style: TextStyle(color: SharedValue.whiteColor),
      ),
    );
  }
}
