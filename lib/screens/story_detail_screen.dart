import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../l10n/app_localizations.dart';
import '../models/story.dart';
import '../models/comment.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/comment_widget.dart';
import '../widgets/loading_animation.dart';

/// 新闻详情页面
/// 展示新闻详细信息和评论列表
class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final ApiService _apiService = ApiService();
  List<Comment> _comments = [];
  bool _isLoadingComments = false;
  String? _commentsError;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  /// 加载评论
  Future<void> _loadComments() async {
    if (widget.story.kids.isEmpty) return;

    setState(() {
      _isLoadingComments = true;
      _commentsError = null;
    });

    try {
      final comments = await _apiService.fetchStoryComments(widget.story);
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    } catch (e) {
      setState(() {
        _commentsError = e.toString();
        _isLoadingComments = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = Provider.of<LanguageProvider>(context).locale;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final timeAgoString = timeago.format(
      DateTime.fromMillisecondsSinceEpoch(widget.story.time * 1000),
      locale: locale.languageCode,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.story.title,
        showBackButton: true,
        actions: widget.story.url != null
            ? [
                IconButton(
                  icon: const Icon(Icons.open_in_browser, color: Colors.white),
                  onPressed: () => _openInBrowser(widget.story.url!),
                  tooltip: localizations.openInBrowser,
                ),
              ]
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkBackground : Colors.grey.shade50,
        ),
        child: CustomScrollView(
          slivers: [
            // 新闻详情头部
            SliverToBoxAdapter(
              child: _buildStoryHeader(context, localizations, isDarkMode, timeAgoString),
            ),
            // 评论标题
            SliverToBoxAdapter(
              child: _buildCommentsHeader(context, localizations, isDarkMode),
            ),
            // 评论列表
            _buildCommentsList(context, localizations, isDarkMode),
          ],
        ),
      ),
    );
  }

  /// 构建新闻详情头部
  Widget _buildStoryHeader(BuildContext context, AppLocalizations localizations, bool isDarkMode, String timeAgoString) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            widget.story.title,
            style: TextStyle(
              fontFamily: AppTheme.titleFontFamily,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // 元数据
          Row(
            children: [
              _buildMetadataChip(Icons.arrow_upward, '${widget.story.score}', AppTheme.safetyGreen, isDarkMode),
              const SizedBox(width: 8),
              _buildMetadataChip(Icons.person_outline, widget.story.by, isDarkMode ? Colors.white70 : Colors.black54, isDarkMode),
              const SizedBox(width: 8),
              _buildMetadataChip(Icons.access_time, timeAgoString, isDarkMode ? Colors.white70 : Colors.black54, isDarkMode),
            ],
          ),
          const SizedBox(height: 16),
          // 评论数量
          _buildMetadataChip(Icons.comment_outlined, '${widget.story.descendants} ${localizations.commentsCount}', AppTheme.codeBlue, isDarkMode),
          // 打开链接按钮
          if (widget.story.url != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_browser),
                label: Text(
                  localizations.openInBrowser,
                  style: TextStyle(
                    fontFamily: AppTheme.secondaryFontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _openInBrowser(widget.story.url!),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建元数据芯片
  Widget _buildMetadataChip(IconData icon, String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTheme.secondaryFontFamily,
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建评论标题
  Widget _buildCommentsHeader(BuildContext context, AppLocalizations localizations, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.comment,
            color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            localizations.commentsTitle,
            style: TextStyle(
              fontFamily: AppTheme.titleFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
            ),
          ),
          const Spacer(),
          if (_isLoadingComments)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建评论列表
  Widget _buildCommentsList(BuildContext context, AppLocalizations localizations, bool isDarkMode) {
    if (_isLoadingComments && _comments.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: LoadingAnimation(
            message: localizations.loadingComments,
          ),
        ),
      );
    }

    if (_commentsError != null) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: EmptyState(
            message: localizations.errorLoading,
            icon: Icons.error_outline,
          ),
        ),
      );
    }

    if (_comments.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: EmptyState(
            message: localizations.noComments,
            icon: Icons.comment_outlined,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final comment = _comments[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: CommentWidget(
              comment: comment,
              depth: 0,
            ),
          );
        },
        childCount: _comments.length,
      ),
    );
  }

  /// 在浏览器中打开URL
  Future<void> _openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }
}