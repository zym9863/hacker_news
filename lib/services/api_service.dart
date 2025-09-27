import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';
import '../models/comment.dart';

class ApiService {
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  
  // 获取最新故事的ID列表
  Future<List<int>> fetchTopStoryIds() async {
    final response = await http.get(Uri.parse('$_baseUrl/topstories.json'));
    
    if (response.statusCode == 200) {
      final List<dynamic> ids = json.decode(response.body);
      return ids.cast<int>();
    } else {
      throw Exception('Failed to load top stories');
    }
  }
  
  // 根据ID获取故事详情
  Future<Story> fetchStory(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/item/$id.json'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Story.fromJson(data);
    } else {
      throw Exception('Failed to load story $id');
    }
  }

  // 获取多个故事的详情
  Future<List<Story>> fetchStories(List<int> ids, {int limit = 20}) async {
    final limitedIds = ids.take(limit).toList();
    final List<Story> stories = [];

    for (final id in limitedIds) {
      try {
        final story = await fetchStory(id);
        stories.add(story);
      } catch (e) {
        print('Error fetching story $id: $e');
      }
    }

    return stories;
  }

  /// 根据ID获取评论详情
  Future<Comment?> fetchComment(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/item/$id.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final comment = Comment.fromJson(data);

        // 只返回有效的评论
        return comment.isValid ? comment : null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching comment $id: $e');
      return null;
    }
  }

  /// 递归获取评论及其子评论
  Future<List<Comment>> fetchCommentsRecursively(List<int> commentIds, {int maxDepth = 3, int currentDepth = 0}) async {
    if (commentIds.isEmpty || currentDepth >= maxDepth) {
      return [];
    }

    final List<Comment> comments = [];

    for (final id in commentIds) {
      final comment = await fetchComment(id);
      if (comment != null) {
        comments.add(comment);

        // 递归获取子评论
        if (comment.hasChildren && currentDepth < maxDepth - 1) {
          final childComments = await fetchCommentsRecursively(
            comment.kids,
            maxDepth: maxDepth,
            currentDepth: currentDepth + 1,
          );
          // 这里可以将子评论存储在评论对象中，或者返回扁平化的列表
        }
      }
    }

    return comments;
  }

  /// 获取故事的所有评论（第一层）
  Future<List<Comment>> fetchStoryComments(Story story, {int limit = 20}) async {
    if (story.kids.isEmpty) {
      return [];
    }

    final limitedIds = story.kids.take(limit).toList();
    return await fetchCommentsRecursively(limitedIds, maxDepth: 1);
  }
}