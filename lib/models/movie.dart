part of 'models.dart';

class Movie extends Equatable {
  final int id;
  final num? voteAverage;
  final String title, language, overview;
  final String? backdropPath, posterPath;
  final DateTime? releaseDate;
  final bool? isAdult;
  final MovieDetail? movieDetail;

  const Movie({
    required this.id,
    this.voteAverage,
    required this.title,
    required this.language,
    required this.overview,
    this.backdropPath,
    this.posterPath,
    this.releaseDate,
    this.isAdult,
    this.movieDetail,
  });

  @override
  List<Object?> get props => [id, title];

  factory Movie.fromJSON(Map data) => Movie(
        id: data['id'],
        title: data['title'],
        language: data['original_language'],
        overview: data['overview'],
        backdropPath: data['backdrop_path'],
        isAdult: data['adult'],
        posterPath: data['poster_path'],
        releaseDate: DateTime.tryParse(data['release_date']),
        voteAverage: data['vote_average'],
      );

  Map<String, dynamic> toJson(Movie movie) => {};

  Movie copyWith({
    int? id,
    num? voteAverage,
    String? title,
    String? language,
    String? overview,
    String? backdropPath,
    String? posterPath,
    DateTime? releaseDate,
    bool? isAdult,
    MovieDetail? movieDetail,
  }) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        language: language ?? this.language,
        overview: overview ?? this.overview,
        backdropPath: backdropPath ?? this.backdropPath,
        isAdult: isAdult ?? this.isAdult,
        movieDetail: movieDetail ?? this.movieDetail,
        posterPath: posterPath ?? this.posterPath,
        releaseDate: releaseDate ?? this.releaseDate,
        voteAverage: voteAverage ?? this.voteAverage,
      );
}
