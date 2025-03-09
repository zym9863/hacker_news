import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../l10n/app_localizations.dart';
import '../models/story.dart';
import '../services/api_service.dart';
import '../providers/theme_provider.dart';
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
          IconButton(
            icon: const Icon(Icons.dark_mode, color: Colors.white),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _error != null
          ? _buildErrorWidget()
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: _loadStories,
              header: WaterDropHeader(
                waterDropColor: isDarkMode ? Colors.white : Colors.orange,
                complete: Text(
                  localizations.refreshComplete,
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              child: _isLoading && _stories.isEmpty
                  ? _buildLoadingWidget()
                  : _buildStoryList(),
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
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemBuilder: (context, index) {
        final story = _stories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryDetailScreen(story: story),
              ),
            );
          },
          child: StoryCard(
            story: story,
            index: index,
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