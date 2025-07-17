import 'package:flutter/material.dart';

getAppTheme(){
  return ThemeData(
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: Color(0xFF6C5CE7),
    scaffoldBackgroundColor: Color(0xFF0A0A0F),
    
    // Text Theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
      bodySmall: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
      headlineLarge: TextStyle(
        fontSize: 32, 
        color: Colors.white, 
        fontWeight: FontWeight.w900,
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        color: Colors.white, 
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 20, 
        color: Colors.white, 
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Text Selection Theme
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xFF6C5CE7),
      selectionColor: Color(0xFF6C5CE7).withOpacity(0.3),
      selectionHandleColor: Color(0xFF6C5CE7),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1A1A2E).withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.withOpacity(0.8), width: 2),
      ),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      prefixIconColor: Colors.white.withOpacity(0.6),
      suffixIconColor: Colors.white.withOpacity(0.6),
      errorStyle: TextStyle(color: Colors.red.withOpacity(0.8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      // titleTextStyle: TextStyle(
      //   color: Colors.white,
      //   fontSize: 30,
      //   fontWeight: FontWeight.w700,
      //   fontFamily: 'Dmitry',
      //   letterSpacing: 0.5,
      // ),
    ),
    
    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Color(0xFF6C5CE7);
        }
        return Colors.transparent;
      }),
      side: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color(0xFF6C5CE7),
      linearTrackColor: Colors.white.withOpacity(0.1),
      circularTrackColor: Colors.white.withOpacity(0.1),
    ),
    
    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF6C5CE7),
      secondary: Color(0xFF74B9FF),
      tertiary: Color(0xFF00CEC9),
      surface: Color(0xFF1A1A2E),
      background: Color(0xFF0A0A0F),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      error: Colors.red.withOpacity(0.8),
      onError: Colors.white,
    ),
    
    // Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Color(0xFF6C5CE7).withOpacity(0.5);
        }
        return Colors.white.withOpacity(0.2);
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Color(0xFF6C5CE7);
        }
        return Colors.white.withOpacity(0.7);
      }),
      overlayColor: WidgetStateProperty.all(Color(0xFF6C5CE7).withOpacity(0.1)),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: Color(0xFF1A1A2E).withOpacity(0.5),
      shadowColor: Color(0xFF6C5CE7).withOpacity(0.1),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Color(0xFF6C5CE7).withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    
    // List Tile Theme
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xFF1A1A2E).withOpacity(0.3),
      textColor: Colors.white,
      iconColor: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: Colors.white.withOpacity(0.8),
      size: 24,
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(0.1),
      thickness: 1,
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A1A2E),
      selectedItemColor: Color(0xFF6C5CE7),
      unselectedItemColor: Colors.white.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 20,
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF1A1A2E),
      contentTextStyle: TextStyle(color: Colors.white),
      actionTextColor: Color(0xFF6C5CE7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF1A1A2E),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      contentTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6C5CE7),
      foregroundColor: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: Color(0xFF6C5CE7),
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      indicator: BoxDecoration(
        color: Color(0xFF6C5CE7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
    ),
  );
}