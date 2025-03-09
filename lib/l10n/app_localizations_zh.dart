import 'app_localizations.dart';
import 'package:translator/translator.dart';

class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh() : super('zh');
  final translator = GoogleTranslator();

  @override
  String get appTitle => 'Hacker News';
  
  @override
  String get loading => '加载中...';
  
  @override
  String get errorLoading => '加载数据出错';
  
  @override
  String get retry => '重试';
  
  @override
  String get points => '点赞';
  
  @override
  String get comments => '评论';
  
  @override
  String get by => '作者';
  
  @override
  String get timeAgo => '前';
  
  @override
  String get settings => '设置';
  
  @override
  String get language => '语言';
  
  @override
  String get english => '英文';
  
  @override
  String get chinese => '中文';
  
  @override
  String get refresh => '刷新';
  
  @override
  String get noUrl => '无可用链接';
  
  @override
  String get openInBrowser => '在浏览器中打开';
  
  @override
  String get refreshComplete => '刷新完成';
  
  @override
  String get emptyStories => '没有可用的文章';
  
  @override
  Future<String> translateStoryTitle(String originalTitle) async {
    try {
      final translation = await translator.translate(originalTitle, from: 'en', to: 'zh-cn');
      return translation.text;
    } catch (e) {
      print('翻译错误: $e');
      return originalTitle;
    }
  }
}