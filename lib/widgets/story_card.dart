import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../l10n/app_localizations.dart';
import '../models/story.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class StoryCard extends StatefulWidget {
  final Story story;
  final int index;

  const StoryCard({super.key, required this.story, required this.index});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    // 根据索引生成不同的颜色，使列表更有层次感
    final Color indicatorColor = _getIndicatorColor(widget.index);
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode ? AppTheme.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.08),
                    blurRadius: _isHovered ? (isDarkMode ? 20 : 16) : (isDarkMode ? 16 : 12),
                    offset: Offset(0, _isHovered ? (isDarkMode ? 8 : 6) : (isDarkMode ? 6 : 4)),
                    spreadRadius: _isHovered ? (isDarkMode ? 3 : 2) : (isDarkMode ? 2 : 1),
                  ),
                  if (isDarkMode)
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.08 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 左侧色彩标记条 - 增强的视觉效果
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isHovered ? 6 : 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            indicatorColor,
                            indicatorColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: indicatorColor.withOpacity(_isHovered ? 0.4 : 0.3),
                            blurRadius: _isHovered ? 6 : 4,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                    ),
            // 主要内容
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 排名指示器 - 增强的视觉设计
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 12, top: 2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDarkMode 
                                  ? [
                                      AppTheme.darkPrimaryColor.withOpacity(0.2),
                                      AppTheme.darkPrimaryColor.withOpacity(0.1),
                                    ]
                                  : [
                                      AppTheme.primaryColor.withOpacity(0.15),
                                      AppTheme.primaryColor.withOpacity(0.05),
                                    ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDarkMode 
                                  ? AppTheme.darkPrimaryColor.withOpacity(0.3)
                                  : AppTheme.primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: AppTheme.codeFontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode 
                                  ? AppTheme.darkPrimaryColor 
                                  : AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        // 标题文本
                        Expanded(
                          child: FutureBuilder<String>(
                            future: locale.languageCode == 'zh' 
                                ? Future.value(localizations.translateStoryTitle(story.title))
                                : Future.value(story.title),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? story.title,
                                style: TextStyle(
                                  fontFamily: AppTheme.bodyFontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 1.4,
                                  letterSpacing: -0.2,
                                  color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 元数据行 - 增强的视觉层次
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDarkMode 
                            ? Colors.white.withOpacity(0.05) 
                            : Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                        // 分数
                        _buildMetadataItem(
                          context,
                          Icons.arrow_upward,
                          '${widget.story.score}',
                          AppTheme.safetyGreen,
                          isDarkMode,
                        ),
                        _buildDivider(isDarkMode),
                        // 作者
                        _buildMetadataItem(
                          context,
                          Icons.person_outline,
                          widget.story.by,
                          isDarkMode ? Colors.white70 : Colors.black54,
                          isDarkMode,
                        ),
                        _buildDivider(isDarkMode),
                        // 时间
                        _buildMetadataItem(
                          context,
                          Icons.access_time,
                          timeAgoString,
                          isDarkMode ? Colors.white70 : Colors.black54,
                          isDarkMode,
                        ),
                        _buildDivider(isDarkMode),
                        // 评论
                        _buildMetadataItem(
                          context,
                          Icons.comment_outlined,
                          '${widget.story.descendants}',
                          AppTheme.codeBlue,
                          isDarkMode,
                        ),
                      ],
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String text, Color color, bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTheme.secondaryFontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '•',
        style: TextStyle(
          color: isDarkMode ? Colors.white30 : Colors.black26,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getIndicatorColor(int index) {
    // 根据索引循环使用不同颜色
    switch (index % 5) {
      case 0:
        return AppTheme.primaryColor;
      case 1:
        return AppTheme.codeBlue;
      case 2:
        return AppTheme.safetyGreen;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.amber;
      default:
        return AppTheme.primaryColor;
    }
  }
}