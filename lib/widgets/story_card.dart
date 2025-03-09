import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../l10n/app_localizations.dart';
import '../models/story.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final int index;

  const StoryCard({super.key, required this.story, required this.index});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = Provider.of<LanguageProvider>(context).locale;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final timeAgoString = timeago.format(
      DateTime.fromMillisecondsSinceEpoch(story.time * 1000),
      locale: locale.languageCode,
    );

    // 根据索引生成不同的颜色，使列表更有层次感
    final Color indicatorColor = _getIndicatorColor(index);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 左侧色彩标记条
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
            // 主要内容
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 排名指示器
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 8, top: 2),
                          decoration: BoxDecoration(
                            color: isDarkMode 
                                ? AppTheme.darkPrimaryColor.withOpacity(0.2) 
                                : AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: AppTheme.codeFontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
                                  fontFamily: AppTheme.titleFontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.4,
                                  letterSpacing: 0.2,
                                  color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 元数据行
                    Row(
                      children: [
                        // 分数
                        _buildMetadataItem(
                          context,
                          Icons.arrow_upward,
                          '${story.score}',
                          AppTheme.safetyGreen,
                          isDarkMode,
                        ),
                        _buildDivider(isDarkMode),
                        // 作者
                        _buildMetadataItem(
                          context,
                          Icons.person_outline,
                          story.by,
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
                          '${story.descendants}',
                          AppTheme.codeBlue,
                          isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String text, Color color, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTheme.secondaryFontFamily,
            fontSize: 12,
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