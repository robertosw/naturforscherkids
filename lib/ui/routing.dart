import 'package:flutter/material.dart';
import 'package:naturforscherkids/ui/explorer/scanning/route_camera.dart';
import 'package:naturforscherkids/ui/explorer/scanning/route_camera_picture.dart';
import 'package:naturforscherkids/ui/explorer/scanning/route_plant_result.dart';
import 'package:naturforscherkids/ui/explorer/tab_profile_find_group.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/route_home_universal.dart';
import 'package:naturforscherkids/ui/route_login.dart';

class PageRoutingError extends StatelessWidget {
  const PageRoutingError({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Routing Error'),
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: const Icon(Icons.arrow_back_sharp, size: 22.0),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30.0),
          child: const Text(
            'Die aufgerufene Seite existiert in dieser App nicht',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (BuildContext context) => const PageLogin());

      ///

      case '/camera':
        return MaterialPageRoute(builder: (BuildContext context) => const ExplorerPageCamera());

      case '/camera_picture':
        return MaterialPageRoute(builder: (BuildContext context) => const ExplorerPageCameraPicture());

      case '/find_groups':
        return MaterialPageRoute(builder: (BuildContext context) => const ExplorerTabFindGroup());

      case "/plant_result":
        final args = settings.arguments as ExplorerPagePlantResultRoutingArgs;
        return MaterialPageRoute(builder: (BuildContext context) {
          return ExplorerPagePlantResult(plantFound: args.plantFound, message: args.message, lexiconPlantNotFound: args.lexiconPlantNotFound);
        });

      ///

      // Das ist eigentlich nur Legacy, damit die getCurrentStartRoute() funktioniert. War bisher zu faul die umzuschreiben
      case '/explorer_home':
        return MaterialPageRoute(builder: (BuildContext context) => const UniversalPageHome(role: Role.explorer));
      case '/instructor_home':
        return MaterialPageRoute(builder: (BuildContext context) => const UniversalPageHome(role: Role.instructor));

      ///

      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const PageRoutingError();
        });
    }
  }
}
