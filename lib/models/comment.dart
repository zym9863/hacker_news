/// 评论数据模型
/// 表示 Hacker News 的评论信息
class Comment {
  final int id;
  final String? text;
  final String by;
  final int time;
  final List<int> kids;
  final bool deleted;
  final bool dead;
  final int? parent;

  Comment({
    required this.id,
    this.text,
    required this.by,
    required this.time,
    required this.kids,
    this.deleted = false,
    this.dead = false,
    this.parent,
  });

  /// 从 JSON 数据创建评论对象
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      text: json['text'] as String?,
      by: json['by'] as String? ?? 'unknown',
      time: json['time'] as int,
      kids: json['kids'] != null
          ? List<int>.from(json['kids'] as List)
          : <int>[],
      deleted: json['deleted'] as bool? ?? false,
      dead: json['dead'] as bool? ?? false,
      parent: json['parent'] as int?,
    );
  }

  /// 是否为有效评论(未删除且有内容)
  bool get isValid => !deleted && !dead && text != null && text!.isNotEmpty;

  /// 是否有子评论
  bool get hasChildren => kids.isNotEmpty;
}