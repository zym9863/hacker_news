import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingAnimation extends StatefulWidget {
  final String? message;

  const LoadingAnimation({super.key, this.message});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  final List<String> _asciiFrames = [
    '> Loading...',
    '> Loading...',
    '>> Loading..',
    '>> Loading..',
    '>>> Loading.',
    '>>> Loading.',
    '>>>> Loading',
    '>>>> Loading',
    '>>>>> Loading',
    '>>>>> Loading',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textAnimation = IntTween(
      begin: 0,
      end: _asciiFrames.length - 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ASCII动画
          Container(
            width: 200,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.black12,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 终端风格标题栏
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'terminal',
                        style: TextStyle(
                          fontFamily: AppTheme.codeFontFamily,
                          fontSize: 10,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // ASCII动画文本
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Text(
                      _asciiFrames[_textAnimation.value],
                      style: TextStyle(
                        fontFamily: AppTheme.codeFontFamily,
                        fontSize: 14,
                        color: isDarkMode 
                            ? AppTheme.darkPrimaryColor 
                            : AppTheme.primaryColor,
                        height: 1.5,
                      ),
                    );
                  },
                ),
                // 二进制背景效果
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '01001100',
                      style: TextStyle(
                        fontFamily: AppTheme.codeFontFamily,
                        fontSize: 10,
                        color: isDarkMode 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 加载消息
          if (widget.message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                widget.message!,
                style: TextStyle(
                  fontFamily: AppTheme.secondaryFontFamily,
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}