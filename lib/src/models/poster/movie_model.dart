class MovieModel {
  bool? isSuccess;
  List<MovieData>? data;
  String? errors;

  MovieModel({this.isSuccess, this.data, this.errors});

  MovieModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      data = <MovieData>[];
      json['data'].forEach((v) {
        data!.add(MovieData.fromJson(v));
      });
    }
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['errors'] = errors;
    return data;
  }
}

class MovieData {
  int? id;
  String? title;
  String? synopsis;
  String? image;
  String? colorHighlight;
  List<String>? genres;
  double? rating;

  MovieData(
      {this.id,
      this.title,
      this.synopsis,
      this.image,
      this.colorHighlight,
      this.genres,
      this.rating});

  MovieData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    synopsis = json['synopsis'];
    image = json['image'];
    colorHighlight = json['colorHighlight'];
    genres = json['genres'].cast<String>();
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['synopsis'] = synopsis;
    data['image'] = image;
    data['colorHighlight'] = colorHighlight;
    data['genres'] = genres;
    data['rating'] = rating;
    return data;
  }
}
