part of 'controllers.dart';

class MovieController extends GetxController {
  final GetConnect _getConnect = GetConnect();
  final String _baseUrl = 'https://api.themoviedb.org/3',
      _movieId = '300',
      _apiKey = 'fbb9572d11b5458ac98f02b84f2bafc4';

  Rx<List<Movie>?> listMoviesNowPlaying = Rx<List<Movie>?>(null);
  Rx<List<Movie>?> listMoviesRecommended = Rx<List<Movie>?>(null);
  Rx<List<Movie>?> listMoviesPopular = Rx<List<Movie>?>(null);
  int _currentPageRecommended = 1, _currentPagePopular = 1;
  Rx<bool> popularHasReachedMax = Rx<bool>(false);
  Rx<bool> recommendedHasReachedMax = Rx<bool>(false);

  @override
  Future<void> onInit() async {
    super.onInit();
    loadMoviesNowPlaying();
    loadMoviesRecommended();
    loadMoviesPopular();
  }

  Future<void> loadMoviesNowPlaying({isRefresh = false}) async {
    if (isRefresh) {
      listMoviesNowPlaying.update((val) {
        listMoviesNowPlaying = Rx<List<Movie>?>(null);
      });
    }
    try {
      Response response =
          await _getConnect.get('$_baseUrl/movie/now_playing?api_key=$_apiKey');

      if (response.isOk) {
        listMoviesNowPlaying([]);
        for (var element in response.body['results']) {
          listMoviesNowPlaying.value!.add(Movie.fromJSON(element));
        }
      }
    } on FormatException catch (e) {
      SharedMethod.getSnackBar(
          title: 'Something Went Wrong', message: e.message, isError: true);
    }
  }

  Future<void> loadMoviesRecommended({isRefresh = false}) async {
    try {
      if (isRefresh) {
        listMoviesRecommended.update((val) {
          listMoviesRecommended = Rx<List<Movie>?>(null);
        });
        _currentPageRecommended = 1;
        recommendedHasReachedMax(false);
      }
      if (_currentPageRecommended > 2) {
        recommendedHasReachedMax(true);
        SharedMethod.getSnackBar(
            title: 'You have reached the end',
            message: 'There are no recommended films to be shown again');
      } else {
        Response response = await _getConnect.get(
            '$_baseUrl/movie/$_movieId/recommendations?api_key=$_apiKey&page=$_currentPageRecommended');

        if (response.isOk) {
          if ((response.body['results'] as List).isEmpty) {
            recommendedHasReachedMax(true);
            SharedMethod.getSnackBar(
                title: 'You have reached the end',
                message: 'There are no recommended films to be shown again');
          } else {
            _currentPageRecommended += 1;
            if (listMoviesRecommended.isRxNull) {
              listMoviesRecommended([]);

              for (var element in response.body['results']) {
                listMoviesRecommended.value!.add(Movie.fromJSON(element));
              }
            } else {
              for (var element in response.body['results']) {
                listMoviesRecommended.update((val) {
                  val!.add(Movie.fromJSON(element));
                });
              }
            }
          }
        } else {
          recommendedHasReachedMax(true);
          SharedMethod.getSnackBar(
              title: '${response.statusCode}',
              message: '${response.statusText}');
        }
      }
    } on FormatException catch (e) {
      SharedMethod.getSnackBar(
          title: 'Something Went Wrong', message: e.message, isError: true);
    }
  }

  Future<void> loadMoviesPopular({isRefresh = false}) async {
    try {
      if (isRefresh) {
        listMoviesPopular.update((val) {
          listMoviesPopular = Rx<List<Movie>?>(null);
        });
        _currentPagePopular = 1;
        popularHasReachedMax(false);
      }
      if (_currentPagePopular > 500) {
        popularHasReachedMax(true);
        SharedMethod.getSnackBar(
            title: 'You have reached the end',
            message: 'There are no popular movies to show anymore');
      } else {
        Response response = await _getConnect.get(
            '$_baseUrl/movie/popular?api_key=$_apiKey&page=$_currentPagePopular');

        if (response.isOk) {
          if ((response.body['results'] as List).isEmpty) {
            popularHasReachedMax(true);
            SharedMethod.getSnackBar(
                title: 'You have reached the end',
                message: 'There are no popular movies to show anymore');
          } else {
            _currentPagePopular += 1;
            if (listMoviesPopular.isRxNull) {
              listMoviesPopular([]);

              for (var element in response.body['results']) {
                listMoviesPopular.value!.add(Movie.fromJSON(element));
              }
            } else {
              for (var element in response.body['results']) {
                listMoviesPopular.update((val) {
                  val!.add(Movie.fromJSON(element));
                });
              }
            }
          }
        } else {
          popularHasReachedMax(true);
          SharedMethod.getSnackBar(
              title: '${response.statusCode}',
              message: '${response.statusText}');
        }
      }
    } on FormatException catch (e) {
      SharedMethod.getSnackBar(
          title: 'Something Went Wrong', message: e.message, isError: true);
    }
  }

  Future<ServiceResult> getMovieDetail(String id) async {
    try {
      Response response =
          await _getConnect.get('$_baseUrl/movie/$id?api_key=$_apiKey');

      if (response.isOk) {
        return ServiceResult(isError: false, data: response.body);
      } else {
        return ServiceResult(isError: true, message: response.statusText);
      }
    } on FormatException catch (e) {
      return ServiceResult(isError: true, message: e.message);
    }
  }

  Future<ServiceResult> searchMovies(String query, int page) async {
    try {
      Response response = await GetConnect().get(
          '$_baseUrl/search/movie?query=$query&api_key=$_apiKey&page=$page');

      if (response.isOk) {
        if ((response.body['results'] as List).isEmpty) {
          return ServiceResult(
            isError: true,
            message: 'The movie with the keyword "$query" not found',
            data: true,
          );
        } else {
          if (page > 500) {
            return ServiceResult(
              isError: true,
              message:
                  'The movie with the keyword "$query" has reached its end',
              data: true,
            );
          } else {
            List<Movie> temp = [];
            for (var element in response.body['results']) {
              temp.add(Movie.fromJSON(element));
            }
            return ServiceResult(
              isError: false,
              data: {
                'total_pages': response.body['total_pages'],
                'result': temp,
              },
            );
          }
        }
      } else {
        return ServiceResult(isError: true, message: response.statusText);
      }
    } on FormatException catch (e) {
      return ServiceResult(isError: true, message: e.message);
    }
  }
}
