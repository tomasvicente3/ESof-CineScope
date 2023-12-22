class Film {
  final String id, title, type, imgUrl;
  final String? duration, description;
  final int year;
  final double? rating;
  final List<dynamic>? cast;

  Film(
    this.id,
    this.title,
    this.type,
    this.year,
    this.imgUrl, {
    this.cast,
    this.duration,
    this.description,
    this.rating,
  });

  @override
  String toString() {
    return 'Film{title: $title, type: $type, year: $year, id: $id)}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Film && other.id == id && other.title == title && other.type == type && other.year == year && other.imgUrl == imgUrl && other.duration == duration && other.description == description && other.rating == rating && other.cast == cast;
  }
}
