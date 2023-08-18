import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/data/group.dart';
import 'package:naturforscherkids/data/inventory.dart';
import 'package:naturforscherkids/data/lexicon.dart';
import 'package:naturforscherkids/data/mission.dart';
import 'package:naturforscherkids/data/user_data.dart';

import 'data/share_plant.dart';
import 'ui/routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Auf Bildschirmen, welche mehr als 60Hz unterstützen, System darum bitten der App mehr Hz zuzulassen
  await FlutterDisplayMode.setHighRefreshRate();

  // Alle Singletons initieren
  Globals();
  GroupManager();
  Inventory();
  Lexicon();
  PictureHandling();
  UserData();
  Missions();
  AllGuessedPlants();
  SharePlant();
  AllShares();

  await Globals().userData.loadFromLocal();
  Globals().cameras = await availableCameras();

  //PictureHandling().getToken();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //Benachrichtigungsleiste
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,

    //Navigationsleiste
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AppBase());
}

// https://pub.dev/packages/geolocator/install
// https://pub.dev/packages/camera

class AppBase extends StatelessWidget {
  final double _elevation = 1.5;

  const AppBase({super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, Color> greenShades = {
      50: Colors.green.shade50,
      100: Colors.green.shade100,
      200: Colors.green.shade200,
      300: Colors.green.shade300,
      400: Colors.green.shade400,
      500: Colors.green.shade500,
      600: Colors.green.shade600,
      700: Colors.green.shade700,
      800: Colors.green.shade800,
      900: Colors.green.shade900,
    };

    final Color mainColor = Colors.green.shade700;

    return MaterialApp(
      scrollBehavior: const CustomScrollBehavior(scrollPhysics: BouncingScrollPhysics()),
      debugShowCheckedModeBanner: false,
      title: 'Naturforscher Kids',
      locale: const Locale('de'),
      initialRoute: "/login",
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.grey.shade800,
          selectedItemColor: mainColor,
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(mainColor),
            overlayColor: MaterialStatePropertyAll(mainColor.withAlpha(20)),
            elevation: MaterialStatePropertyAll(_elevation),
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            shape: const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
          ),
        ),

        outlinedButtonTheme: const OutlinedButtonThemeData(
          style: ButtonStyle(),
        ),

        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(0),
          border: InputBorder.none,
          iconColor: mainColor,
          hintStyle: TextStyle(color: Colors.grey.shade800),
          errorStyle: TextStyle(color: Colors.red.shade800),
        ),

        // textTheme: const TextTheme(
        //   titleLarge: TextStyle(), // Beispiel: Missionstab "Allgemeine Missionen"
        //   headlineLarge: TextStyle(), // Beispiel: Titel einer Missionskarte
        //   bodyMedium: TextStyle(), // Der Standardtext
        //   labelMedium: TextStyle(), // zB Buttontext
        // ),

        iconTheme: IconThemeData(color: mainColor),

        cardTheme: CardTheme(
          margin: const EdgeInsets.all(0),
          elevation: _elevation,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ),

        primarySwatch: MaterialColor(0xFF388E3C, greenShades), // hex = Colors.green.shade800, frag mich nicht wieso man das so machen muss
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  final ScrollPhysics scrollPhysics;

  const CustomScrollBehavior({required this.scrollPhysics});

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return scrollPhysics;
  }
}
