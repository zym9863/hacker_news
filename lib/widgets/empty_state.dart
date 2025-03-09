import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';

class EmptyState extends StatefulWidget {
  final String message;
  final IconData? icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  // 二进制数字雨背景
  final List<String> _binaryStrings = [
    '01001010',
    '10101100',
    '11001010',
    '00101101',
    '10110010',
    '01010011',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.repeat(reverse: true);
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 二进制数字雨背景
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BinaryRainPainter(
                    animation: _animation.value,
                    isDarkMode: isDarkMode,
                    binaryStrings: _binaryStrings,
                  ),
                );
              },
            ),
          ),
          // 前景内容
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    size: 48,
                    color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                  ),
                const SizedBox(height: 16),
                // 终端风格消息框
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppTheme.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isDarkMode ? Colors.white24 : Colors.black12,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
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
                              'system',
                              style: TextStyle(
                                fontFamily: AppTheme.codeFontFamily,
                                fontSize: 10,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 消息文本
                      Text(
                        '> ${widget.message}',
                        style: TextStyle(
                          fontFamily: AppTheme.codeFontFamily,
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : AppTheme.deepSpaceBlack,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
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
}

class BinaryRainPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;
  final List<String> binaryStrings;

  BinaryRainPainter({
    required this.animation,
    required this.isDarkMode,
    required this.binaryStrings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // 绘制多个二进制字符串
    for (int i = 0; i < 20; i++) {
      final String binary = binaryStrings[i % binaryStrings.length];
      final double opacity = (0.05 + (i % 3) * 0.03) * (1.0 - animation * 0.5);
      
      paint.color = isDarkMode 
          ? Colors.white.withOpacity(opacity)
          : Colors.black.withOpacity(opacity);
      
      final textSpan = TextSpan(
        text: binary,
        style: TextStyle(
          fontFamily: AppTheme.codeFontFamily,
          fontSize: 12 + (i % 4) * 2.0,
          color: paint.color,
        ),
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      
      // 计算位置，使其在动画过程中移动
      final xPos = (size.width / 20) * i + animation * 10 - textPainter.width / 2;
      final yPos = (size.height / 2) + 
          sin((animation * 2 + i) * 3.14) * (size.height / 4) - 
          textPainter.height / 2;
      
      textPainter.paint(canvas, Offset(xPos, yPos));
    }
  }

  @override
  bool shouldRepaint(covariant BinaryRainPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}