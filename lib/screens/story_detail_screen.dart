import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/story.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_state.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    
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
      body: widget.story.url != null
          ? Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppTheme.darkBackground : Colors.white,
                image: DecorationImage(
                  image: const AssetImage('assets/settings_background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                  colorFilter: ColorFilter.mode(
                    isDarkMode ? Colors.white : Colors.black,
                    BlendMode.dstIn,
                  ),
                ),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppTheme.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: isDarkMode ? Colors.white24 : Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 终端风格标题栏
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'story_${widget.story.id}',
                              style: TextStyle(
                                fontFamily: AppTheme.codeFontFamily,
                                fontSize: 10,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 标题
                      Text(
                        '> ${widget.story.title}',
                        style: TextStyle(
                          fontFamily: AppTheme.titleFontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // 按钮
                      ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_browser),
                        label: Text(
                          localizations.openInBrowser,
                          style: TextStyle(
                            fontFamily: AppTheme.secondaryFontFamily,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () => _openInBrowser(widget.story.url!),
                      ),
                      // 二进制装饰
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          '01001100 01101001 01101110 01101011',
                          style: TextStyle(
                            fontFamily: AppTheme.codeFontFamily,
                            fontSize: 10,
                            color: isDarkMode 
                                ? Colors.white.withOpacity(0.2) 
                                : Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : EmptyState(
              message: localizations.noUrl,
              icon: Icons.link_off,
            ),
    );
  }

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