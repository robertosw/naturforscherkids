import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ExplorerPagePlantResultRoutingArgs {
  final bool plantFound;
  final String message;
  final bool lexiconPlantNotFound;
  ExplorerPagePlantResultRoutingArgs({required this.plantFound, required this.message, required this.lexiconPlantNotFound});
}

class ExplorerPagePlantResult extends StatefulWidget {
  final bool plantFound;
  final String message;
  final bool lexiconPlantNotFound;
  const ExplorerPagePlantResult({super.key, required this.plantFound, required this.message, required this.lexiconPlantNotFound});

  @override
  State<ExplorerPagePlantResult> createState() => _ExplorerPagePlantResult();
}

class _ExplorerPagePlantResult extends State<ExplorerPagePlantResult> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: WillPopScope(
        onWillPop: () async {
          if (widget.plantFound) {
            Navigator.of(context).pushNamed("/explorer_home");
          } else {
            Navigator.of(context).popUntil((route) => false); // Alle routen löschen, damit Camera weg ist
            Navigator.of(context).pushNamed("/explorer_home");
            Navigator.of(context).pushNamed("/camera");
          }

          return Future(() => false);
        },
        child: Scaffold(
          body: widget.plantFound ? const PageContentPlantFound() : PageContentNoPlantFound(message: widget.message, lexiconPlantFound: widget.lexiconPlantNotFound),
        ),
      ),
    );
  }
}

class PageContentNoPlantFound extends StatelessWidget {
  const PageContentNoPlantFound({super.key, required this.message, required this.lexiconPlantFound});
  final String message;
  final bool lexiconPlantFound;

  static String commonName = AllGuessedPlants().allGuessedPlants[0].commonName;

  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          lexiconPlantFound ? const NaturfkCategoryTitle(title: "Keine Pflanze gefunden", spaceBefore: false) : const NaturfkCategoryTitle(title: "Falsche Pflanze gefunden", spaceBefore: false),
          const SizedBox.square(dimension: 8),
          //Text("In deinem Bild konnten wir keine Pflanze finden.", textAlign: TextAlign.center),
          Text(message, textAlign: TextAlign.center),
          const SizedBox.square(dimension: 8),
          lexiconPlantFound
              ? const Text("Bitte mach ein neues Bild und achte darauf, dass die wichtigen Merkmale der Pflanze deutlich sichtbar sind", textAlign: TextAlign.center)
              : ((commonName.isNotEmpty)
                  ? Text("Versuche es bald erneut '$commonName' einzuscannen. Die App ist noch in der Entwicklung und es werden bald noch weitere Pflanzen hinzugefügt!", textAlign: TextAlign.center)
                  : Text("Versuche es bald erneut '$commonName' einzuscannen. Die App ist noch in der Entwicklung und es werden bald noch weitere Pflanzen hinzugefügt!", textAlign: TextAlign.center)),
        ],
      ),
      bottomRow: NaturfkBottomRow2(
        left: NaturfkTextButton(
          text: "Zurück zur Übersicht",
          onTap: () {
            Navigator.of(context).popUntil((route) => false); // Alle routen löschen, damit Camera weg ist
            Navigator.of(context).pushNamed("/explorer_home");
          },
        ),
        right: NaturfkTextButton(
          text: "Neues Foto",
          onTap: () {
            Navigator.of(context).popUntil((route) => false); // Alle routen löschen, damit Camera weg ist
            Navigator.of(context).pushNamed("/explorer_home");
            Navigator.of(context).pushNamed("/camera");
          },
        ),
      ),
    );
  }
}

class PageContentPlantFound extends StatelessWidget {
  const PageContentPlantFound({super.key});

  static String commonName = AllGuessedPlants().allGuessedPlants[0].commonName;
  static String taxonName = AllGuessedPlants().allGuessedPlants[0].taxonName;

  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NaturfkCategoryTitle(title: "Pflanze hinzugefügt", spaceBefore: false),
          const SizedBox.square(dimension: 8),
          (commonName.isNotEmpty)
              ? Text("Die Pflanze '$commonName' wurde deinem Inventar hinzugefügt.", textAlign: TextAlign.center)
              : Column(
                  children: [
                    Text("Die Pflanze mit dem lateinischem Namen '$taxonName' wurde deinem Inventar hinzugefügt.", textAlign: TextAlign.center),
                    const SizedBox.square(dimension: 16),
                    const Text(
                      "Wir haben leider nicht für alle Pflanzen den sogenannten 'Alltagsnamen' (z.B. Gänseblümchen). Vorallem Pflanzen welche in Deutschland selten vorkommen, fehlen uns noch.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ],
      ),
      bottomRow: NaturfkBottomRow2(
        left: NaturfkTextButton(
          text: "Weitere Pflanze",
          onTap: () {
            Navigator.of(context).popUntil((route) => false); // Alle routen löschen, damit Camera weg ist
            Navigator.of(context).pushNamed("/explorer_home");
            Navigator.of(context).pushNamed("/camera");
          },
        ),
        right: NaturfkTextButton(
          text: "Ok",
          onTap: () => Navigator.of(context).pushNamed("/explorer_home"),
        ),
      ),
    );
  }
}
