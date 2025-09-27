import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../l10n/app_localizations.dart';
import '../models/story.dart';
import '../services/api_service.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/story_card.dart';
import '../widgets/loading_animation.dart';
import '../widgets/empty_state.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  List<Story> _stories = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final ids = await _apiService.fetchTopStoryIds();
      final stories = await _apiService.fetchStories(ids);
      
      setState(() {
        _stories = stories;
        _isLoading = false;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.appTitle,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode, 
                color: Colors.white,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              tooltip: 'Settings',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.darkBackground,
                    AppTheme.darkBackground.withOpacity(0.95),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
        ),
        child: _error != null
            ? _buildErrorWidget()
            : SmartRefresher(
              controller: _refreshController,
              onRefresh: _loadStories,
              header: WaterDropHeader(
                waterDropColor: isDarkMode 
                    ? AppTheme.darkPrimaryColor 
                    : AppTheme.primaryColor,
                complete: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? AppTheme.darkPrimaryColor.withOpacity(0.1)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    localizations.refreshComplete,
                    style: TextStyle(
                      color: isDarkMode 
                          ? AppTheme.darkPrimaryColor 
                          : AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              child: _isLoading && _stories.isEmpty
                  ? _buildLoadingWidget()
                  : _buildStoryList(),
            ),
        ),
    );
  }

  Widget _buildLoadingWidget() {
    return LoadingAnimation(
      message: AppLocalizations.of(context).loading,
    );
  }

  Widget _buildErrorWidget() {
    return EmptyState(
      message: AppLocalizations.of(context).errorLoading,
      icon: Icons.error_outline,
    );
  }

  Widget _buildStoryList() {
    if (_stories.isEmpty) {
      return EmptyState(
        message: AppLocalizations.of(context).emptyStories,
        icon: Icons.article_outlined,
      );
    }
    
    return ListView.builder(
      itemCount: _stories.length,
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      itemBuilder: (context, index) {
        final story = _stories[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 100 + (index * 50)),
          curve: Curves.easeOutQuart,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        StoryDetailScreen(story: story),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutQuart;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: StoryCard(
                story: story,
                index: index,
              ),
            ),
          ),
        );
      },
    );
  }
  

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}