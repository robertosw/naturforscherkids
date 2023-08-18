import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/data/mission.dart';
import 'package:naturforscherkids/ui/explorer/scanning/route_plant_result.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ExplorerPageCameraPicture extends StatefulWidget {
  const ExplorerPageCameraPicture({super.key});

  @override
  State<ExplorerPageCameraPicture> createState() => _ExplorerPageCameraPictureState();
}

class _ExplorerPageCameraPictureState extends State<ExplorerPageCameraPicture> {
  late String _buttonText;
  bool _submitBtnIsLoading = false;

  @override
  void initState() {
    _buttonText = "Pflanze erkennen";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = Globals().imageFile.path;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Future.sync(() => Navigator.of(context).pop());
          return Future(() => false);
        },
        child: NaturfkPage(
          body: ImageCard(imagePath: imagePath),
          bottomRow: NaturfkBottomRow2(
            left: NaturfkTextButton(
              text: "Neues Bild",
              onTap: () => Navigator.of(context).pop(),
            ),
            right: NaturfkLoadingButton(
              text: _buttonText,
              isLoading: _submitBtnIsLoading,
              onTap: () async {
                setState(() {
                  _buttonText = "Bild wird verarbeitet";
                  _submitBtnIsLoading = true;
                });

                String returnValue = "";
                returnValue = await PictureHandling().makeKIGuess();

                if (returnValue == "falseScore") {
                  Future.sync(() => _clearNavigationStackAndGoToPlantResult(context, plantFound: false, message: "Leider ist sich die KI nicht sicher genug.", lexiconPlantFound: true));
                }
                if (returnValue == "nameEmpty") {
                  Future.sync(() => _clearNavigationStackAndGoToPlantResult(context, plantFound: false, message: "Für deine Pflanze gibt es leider keinen deutschen Namen.", lexiconPlantFound: true));
                }
                if (returnValue == "plantEmpty") {
                  //String commonName = AllGuessedPlants().allGuessedPlants[0].commonName;
                  Future.sync(
                      () => _clearNavigationStackAndGoToPlantResult(context, plantFound: false, message: "Diese Pflanze gibt es leider in unserem App-Lexikon nicht.", lexiconPlantFound: false));
                }
                if (returnValue == "ok") {
                  await PictureHandling().setPlantToInventory();
                  Future.sync(() => _clearNavigationStackAndGoToPlantResult(context, plantFound: true, message: "", lexiconPlantFound: true));
                  // Missionsseite refresh
                  await Missions().serverRequestAllMissionsAnonymous();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _clearNavigationStackAndGoToPlantResult(BuildContext context, {required bool plantFound, required String message, required bool lexiconPlantFound}) {
    Navigator.of(context).popUntil((route) => false); // Alle routen löschen, damit Camera weg ist
    Navigator.of(context).pushNamed("/explorer_home");
    Navigator.of(context).pushNamed("/plant_result", arguments: ExplorerPagePlantResultRoutingArgs(plantFound: plantFound, message: message, lexiconPlantNotFound: lexiconPlantFound));
  }
}

class ImageCard extends StatelessWidget {
  final String imagePath;

  const ImageCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Card(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            scale: 1,
          ),
        ),
      ),
    );
  }
}

class NaturfkLoadingButton extends StatelessWidget {
  static const double _height = 50;

  final String text;
  final bool? disabled;
  final bool isLoading;

  final void Function()? onTap;
  const NaturfkLoadingButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isLoading,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    if (disabled == null || disabled == false) {
      return TextButton(
        onPressed: onTap,
        child: Stack(
          children: [
            // Animation, für Fortschritt
            if (isLoading)
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                child: LinearProgressIndicator(
                  value: null,
                  minHeight: _height,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.075),
                  color: Theme.of(context).primaryColor.withOpacity(0.25),
                ),
              ),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 0, horizontal: 10),
              height: _height,
              alignment: Alignment.center,
              child: Text(text, textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    } else {
      return TextButton(
        onPressed: null,
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 0, horizontal: 10),
          height: 50,
          alignment: Alignment.center,
          child: Text(text, style: const TextStyle(color: Colors.grey)),
        ),
      );
    }
  }
}
