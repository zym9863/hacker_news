import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 主色调
  static const Color primaryColor = Color(0xFFFF6600);
  static const Color primaryColorLight = Color(0xFFFF8C00);
  
  // 基础色调
  static const Color deepSpaceBlack = Color(0xFF1A1A1A);
  static const Color techSilver = Color(0xFFE0E0E0);
  static const Color codeBlue = Color(0xFF007BFF);
  static const Color safetyGreen = Color(0xFF28A745);
  static const Color warningRed = Color(0xFFDC3545);
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryColorLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // 暗黑模式颜色
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF242424);
  static const Color darkPrimaryColor = Color(0xFFFF8533);
  
  // 字体
  static const String titleFontFamily = 'Roboto Mono';
  static const String bodyFontFamily = 'Inter';
  static const String secondaryFontFamily = 'IBM Plex Sans';
  static const String codeFontFamily = 'Fira Code';
  
  // 动画曲线
  static const Curve standardCurve = Curves.easeInOutQuad;
  
  // 卡片样式
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // 暗黑模式卡片样式
  static final BoxDecoration darkCardDecoration = BoxDecoration(
    color: darkSurface,
    borderRadius: BorderRadius.circular(4),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // 亮色主题
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: codeBlue,
      surface: Colors.white,
      background: Colors.white,
      error: warningRed,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: titleFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.5,
        color: deepSpaceBlack,
      ),
      iconTheme: IconThemeData(color: deepSpaceBlack),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: titleFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 16,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 14,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: secondaryFontFamily,
        fontSize: 14,
        color: deepSpaceBlack.withOpacity(0.6),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: deepSpaceBlack,
      size: 24,
    ),
  );
  
  // 暗黑主题
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: codeBlue,
      surface: darkSurface,
      background: darkBackground,
      error: warningRed,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: titleFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.5,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: titleFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.5,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 16,
        height: 1.6,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontSize: 14,
        height: 1.6,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontFamily: secondaryFontFamily,
        fontSize: 14,
        color: Colors.white.withOpacity(0.6),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: darkSurface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
  );
}
