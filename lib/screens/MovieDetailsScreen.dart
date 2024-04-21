import 'package:flutter/material.dart';
import 'package:mapfeature_project/movies/moviesmodel.dart';
import 'package:mapfeature_project/movies/api.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieDetails>(
      future: Api().getMovieDetails(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Movie Details'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Movie Details'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final movieDetails = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(movieDetails.title),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movieDetails.bannerUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Movie Overview
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Overview:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      movieDetails.overview,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Movie Genres
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Genres: ${movieDetails.genres.join(", ")}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Movie Rating
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rating: ${movieDetails.rating}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Movie Duration
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Duration: ${movieDetails.duration}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
