class Story {
  final int id;
  final String title;
  final String? url;
  final String by;
  final int time;
  final int score;
  final int descendants;
  final List<int> kids;

  Story({
    required this.id,
    required this.title,
    this.url,
    required this.by,
    required this.time,
    required this.score,
    required this.descendants,
    required this.kids,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String?,
      by: json['by'] as String,
      time: json['time'] as int,
      score: json['score'] as int,
      descendants: json['descendants'] as int? ?? 0,
      kids: json['kids'] != null
          ? List<int>.from(json['kids'] as List)
          : <int>[],
    );
  }
}