part of 'models.dart';

class MovieDetail extends Equatable {
  final List<String>? genres;
  final List? productionCompanies, productionCountries;
  final String? homepage;

  const MovieDetail(
      {this.genres,
      this.productionCompanies,
      this.productionCountries,
      this.homepage});

  @override
  List<Object?> get props => [homepage];

  factory MovieDetail.fromJSON(Map data) {
    List<String> genres = [];
    for (var element in data['genres']) {
      genres.add(element['name']);
    }
    return MovieDetail(
      genres: genres,
      homepage: data['homepage'],
      productionCompanies: data['production_companies'],
      productionCountries: data['production_countries'],
    );
  }

  Map<String, dynamic> toJson(Movie movie) => {};
}
