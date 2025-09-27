import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          if (isDarkMode)
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 返回按钮
              if (showBackButton)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? Colors.white : Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              // 品牌标识
              _buildLogo(isDarkMode),
              const SizedBox(width: 12),
              // 标题
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppTheme.titleFontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // 操作按钮
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDarkMode) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Y',
          style: TextStyle(
            fontFamily: AppTheme.codeFontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}