import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

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
}