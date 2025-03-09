import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appTitle => 'Hacker News';
  
  @override
  String get loading => 'Loading...';
  
  @override
  String get errorLoading => 'Error loading data';
  
  @override
  String get retry => 'Retry';
  
  @override
  String get points => 'points';
  
  @override
  String get comments => 'comments';
  
  @override
  String get by => 'by';
  
  @override
  String get timeAgo => 'ago';
  
  @override
  String get settings => 'Settings';
  
  @override
  String get language => 'Language';
  
  @override
  String get english => 'English';
  
  @override
  String get chinese => 'Chinese';
  
  @override
  String get refresh => 'Refresh';
  
  @override
  String get noUrl => 'No URL available';
  
  @override
  String get openInBrowser => 'Open in browser';
  
  @override
  String get refreshComplete => 'Refresh complete';
  
  @override
  String get emptyStories => 'No stories available';
  
  @override
  Future<String> translateStoryTitle(String originalTitle) {
    return Future.value(originalTitle);
  }
}