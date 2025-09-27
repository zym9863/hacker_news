import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingAnimation extends StatefulWidget {
  final String? message;

  const LoadingAnimation({super.key, this.message});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shimmerController;
  late Animation<int> _textAnimation;
  late Animation<double> _shimmerAnimation;
  
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

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _textAnimation = IntTween(
      begin: 0,
      end: _asciiFrames.length - 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _controller.repeat();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ASCII动画 - 增强的视觉设计
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return Container(
                width: 220,
                height: 130,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode ? Colors.white24 : Colors.black12,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                      blurRadius: isDarkMode ? 16 : 8,
                      offset: Offset(0, isDarkMode ? 6 : 4),
                      spreadRadius: isDarkMode ? 2 : 1,
                    ),
                    if (isDarkMode)
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Shimmer overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment(-1.0 - _shimmerAnimation.value, 0.0),
                            end: Alignment(1.0 - _shimmerAnimation.value, 0.0),
                            colors: [
                              Colors.transparent,
                              isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 终端风格标题栏 - 增强的视觉设计
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDarkMode 
                                  ? [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]
                                  : [Colors.black.withOpacity(0.08), Colors.black.withOpacity(0.03)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(6),
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
                  ],
                ),
              );
            },
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