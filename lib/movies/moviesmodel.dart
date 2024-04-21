class Movie {
  final int id;
  final String title;
  final String backDropPath;
  final String overview;
  final String posterPath;
  final String bannerUrl; // New field for banner URL
  final String posterUrl; // New field for poster URL

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.bannerUrl,
    required this.posterUrl,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      backDropPath: map['backdrop_path'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      bannerUrl: "https://image.tmdb.org/t/p/original/${map['backdrop_path']}",
      posterUrl: "https://image.tmdb.org/t/p/original/${map['poster_path']}",
    );
  }
}

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String posterPath;
  final String bannerUrl; // Add bannerUrl property
  final List<String> genres; // Add genres property
  final double rating; // Add rating property
  final String duration; // Add duration property

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.bannerUrl,
    required this.genres,
    required this.rating,
    required this.duration,
  });

  factory MovieDetails.fromMap(Map<String, dynamic> map) {
    // Parse genre names
    List<String> genres = [];
    if (map['genres'] != null) {
      genres = List<String>.from(map['genres'].map((genre) => genre['name']));
    }

    return MovieDetails(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      releaseDate: map['release_date'],
      posterPath: map['poster_path'],
      bannerUrl: "https://image.tmdb.org/t/p/original/${map['backdrop_path']}",
      genres: genres,
      rating: map['vote_average'].toDouble(),
      duration: '${map['runtime']} min',
    );
  }
}
