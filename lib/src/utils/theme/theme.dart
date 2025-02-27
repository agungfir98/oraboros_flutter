import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.ibmPlexSansTextTheme(),
    tabBarTheme: const TabBarTheme(
      indicator: BoxDecoration(color: Colors.black),
      labelStyle: TextStyle(fontWeight: FontWeight.w600),
      labelColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xff59FD39),
      secondary: Color(0xFF142e12),
      outline: Color(0xFF112916),
      onSecondary: Color(0xFF6bab67),
      // background: Color(0xFFFFE5B4),
      secondaryContainer: Color.fromARGB(255, 201, 201, 201),
      shadow: Color(0xFF112916),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    textTheme: GoogleFonts.ibmPlexSansTextTheme(),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff59FD39),
      secondary: Color(0xFF142e12),
      outline: Color(0xFF112916),
      onSecondary: Color(0xFF6bab67),
      // background: Color(0xFF162521),
      secondaryContainer: Color.fromARGB(255, 201, 201, 201),
      shadow: Color(0xFF112916),
    ),
  );
}
