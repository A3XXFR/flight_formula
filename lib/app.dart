import 'package:flight_formula/regulations/regulation.dart';
import 'package:flutter/material.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
          home: const RegulationsPage(),
          theme: ThemeData(
            fontFamily: "IbmPlex",
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff161616),
            ),
            colorScheme: const ColorScheme.highContrastDark(
              background: Colors.black,
              primary: Colors.white,
              onPrimary: Colors.black,
              secondary: Colors.redAccent,
              onSecondary: Colors.white,
              error: Colors.red,
              onError: Colors.white,
              onBackground: Colors.white,
              surface: Colors.grey,
              onSurface: Colors.white,
            ),
          ),
        );
}
