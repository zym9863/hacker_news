import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../l10n/app_localizations.dart';
import '../models/comment.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// 评论组件
/// 支持嵌套显示和展开/折叠功能
class CommentWidget extends StatefulWidget {
  final Comment comment;
  final int depth;
  final bool showReplies;

  const CommentWidget({
    super.key,
    required this.comment,
    this.depth = 0,
    this.showReplies = true,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = Provider.of<LanguageProvider>(context).locale;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final timeAgoString = timeago.format(
      DateTime.fromMillisecondsSinceEpoch(widget.comment.time * 1000),
      locale: locale.languageCode,
    );

    // 根据嵌套深度设置左边距
    final leftPadding = (widget.depth * 16.0).clamp(0.0, 64.0);

    // 解析HTML内容为纯文本
    final cleanText = _parseHtmlText(widget.comment.text ?? '');

    return Container(
      margin: EdgeInsets.only(
        left: leftPadding,
        right: 8,
        bottom: 8,
      ),
      child: Card(
        elevation: widget.depth == 0 ? 2 : 1,
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: _getDepthColor(widget.depth, isDarkMode),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 评论头部
            InkWell(
              onTap: () {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // 用户头像或图标
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: _getDepthColor(widget.depth, isDarkMode),
                      child: Text(
                        widget.comment.by.isNotEmpty ? widget.comment.by[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 用户名
                    Expanded(
                      child: Text(
                        widget.comment.by,
                        style: TextStyle(
                          fontFamily: AppTheme.secondaryFontFamily,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // 时间
                    Text(
                      timeAgoString,
                      style: TextStyle(
                        fontFamily: AppTheme.secondaryFontFamily,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 折叠图标
                    Icon(
                      _isCollapsed ? Icons.expand_more : Icons.expand_less,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            // 评论内容
            if (!_isCollapsed) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text(
                  cleanText,
                  style: TextStyle(
                    fontFamily: AppTheme.secondaryFontFamily,
                    color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              // 回复按钮
              if (widget.comment.hasChildren)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Text(
                    '${widget.comment.kids.length} ${localizations.replyTo}',
                    style: TextStyle(
                      fontFamily: AppTheme.codeFontFamily,
                      color: _getDepthColor(widget.depth, isDarkMode),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// 解析HTML文本为纯文本
  String _parseHtmlText(String htmlText) {
    if (htmlText.isEmpty) return '';

    try {
      final document = html_parser.parse(htmlText);
      return document.body?.text ?? htmlText;
    } catch (e) {
      return htmlText;
    }
  }

  /// 根据嵌套深度获取颜色
  Color _getDepthColor(int depth, bool isDarkMode) {
    final colors = isDarkMode
        ? [
            AppTheme.darkPrimaryColor,
            AppTheme.codeBlue,
            AppTheme.safetyGreen,
            Colors.purple.shade300,
            Colors.amber.shade300,
          ]
        : [
            AppTheme.primaryColor,
            AppTheme.codeBlue,
            AppTheme.safetyGreen,
            Colors.purple,
            Colors.amber,
          ];

    return colors[depth % colors.length];
  }
}