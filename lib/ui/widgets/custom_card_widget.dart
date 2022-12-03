part of 'widgets.dart';

class NowPlayingCardWidget extends StatelessWidget {
  const NowPlayingCardWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.toNamed('${RouteName.detail}/${movie.id}', arguments: movie);
      },
      child: SizedBox(
        width: Get.width * .38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: movie.id,
              child: SizedBox(
                width: Get.width * .38,
                height: Get.height * .25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: CustomCacheImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: Get.width * .38,
                      height: Get.height * .25),
                ),
              ),
            ),
            const SizedBox(height: 5),
            AutoSizeText(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              children: List.generate(5, (index) {
                    if (movie.voteAverage != null) {
                      if ((index + 1) * 2 > movie.voteAverage!) {
                        return Icon(EvaIcons.starOutline,
                            size: 16, color: SharedValue.secondaryColor);
                      } else {
                        return Icon(EvaIcons.star,
                            size: 16, color: SharedValue.secondaryColor);
                      }
                    } else {
                      return const SizedBox();
                    }
                  }) +
                  [
                    const SizedBox(width: 5),
                    Text(movie.voteAverage.toDisplay),
                  ],
            )
          ],
        ),
      ),
    );
  }
}

class RecommendedCardWidget extends StatelessWidget {
  const RecommendedCardWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          Get.toNamed('${RouteName.detail}/${movie.id}', arguments: movie);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: movie.id,
              child: SizedBox(
                width: Get.width * .33,
                height: Get.height * .2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: movie.posterPath == null
                      ? Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/icon.png',
                            width: Get.width * .15,
                          ))
                      : CustomCacheImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          width: Get.width * .35,
                          height: Get.height * .22),
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    movie.title,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(EvaIcons.star,
                          size: 14, color: SharedValue.secondaryColor),
                      const SizedBox(width: 3),
                      Text(movie.voteAverage.toDisplay,
                          textAlign: TextAlign.start),
                      if (movie.isAdult != null) const SizedBox(width: 8),
                      if (movie.isAdult != null)
                        Text(movie.isAdult! ? '18+' : 'SU'),
                      const SizedBox(width: 8),
                      Text(movie.language.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(movie.overview,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget generateBox({required Widget child}) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: SharedValue.primaryColor),
        child: child);
  }
}

class LoadingRecommendedCardWidget extends StatelessWidget {
  const LoadingRecommendedCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: Get.width * .33,
              height: Get.height * .2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
            ),
          ),
          const SizedBox(width: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: Get.width * .35,
                  height: 17,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  6,
                  (index) => index.isOdd
                      ? const SizedBox(width: 8)
                      : Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 40,
                            height: 16,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
