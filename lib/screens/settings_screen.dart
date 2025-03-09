import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.settings,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // 背景图层
          Container(
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? AppTheme.darkBackground.withOpacity(0.9) 
                  : Colors.white.withOpacity(0.8),
              image: DecorationImage(
                image: const AssetImage('assets/settings_background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isDarkMode 
                      ? Colors.black.withOpacity(0.7) 
                      : Colors.white.withOpacity(0.8),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // 二进制背景效果（仅在暗黑模式下显示）
          if (isDarkMode)
            CustomPaint(
              painter: StarfieldPainter(),
              size: MediaQuery.of(context).size,
            ),
          // 设置列表
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 设置标题
                Text(
                  '> ${localizations.settings}',
                  style: TextStyle(
                    fontFamily: AppTheme.codeFontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // 设置卡片
                Container(
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
                  child: Column(
                    children: [
                      // 语言设置
                      _buildSettingItem(
                        icon: Icons.language,
                        title: localizations.language,
                        trailing: DropdownButton<String>(
                          value: languageProvider.locale.languageCode,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              languageProvider.setLocale(Locale(newValue));
                            }
                          },
                          dropdownColor: isDarkMode ? AppTheme.darkSurface : Colors.white,
                          underline: Container(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text(
                                localizations.english,
                                style: TextStyle(
                                  fontFamily: AppTheme.secondaryFontFamily,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'zh',
                              child: Text(
                                localizations.chinese,
                                style: TextStyle(
                                  fontFamily: AppTheme.secondaryFontFamily,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      // 分隔线
                      Divider(
                        color: isDarkMode ? Colors.white12 : Colors.black12,
                        height: 1,
                      ),
                      // 主题设置
                      _buildSettingItem(
                        icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        title: isDarkMode ? 'Dark Mode' : 'Light Mode',
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (_) => themeProvider.toggleTheme(),
                          activeColor: AppTheme.darkPrimaryColor,
                          activeTrackColor: AppTheme.darkPrimaryColor.withOpacity(0.5),
                        ),
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: AppTheme.secondaryFontFamily,
              fontSize: 16,
              color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(42); // 固定种子以保持一致性
    final Paint paint = Paint();
    
    // 绘制约100个星星
    for (int i = 0; i < 100; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 1.5 + 0.5; // 0.5-2.0的随机半径
      final double opacity = random.nextDouble() * 0.5 + 0.1; // 0.1-0.6的随机透明度
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    
    // 绘制几条二进制数据流
    final TextStyle binaryStyle = TextStyle(
      fontFamily: AppTheme.codeFontFamily,
      fontSize: 10,
      color: Colors.white.withOpacity(0.15),
    );
    
    for (int i = 0; i < 5; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final String binary = '01' * (random.nextInt(8) + 4); // 随机长度的二进制字符串
      
      final textSpan = TextSpan(text: binary, style: binaryStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
