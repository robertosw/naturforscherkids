import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/globals.dart';

class ExplorerPageCamera extends StatefulWidget {
  const ExplorerPageCamera({super.key});

  @override
  State<ExplorerPageCamera> createState() => _ExplorerPageCameraState();
}

class _ExplorerPageCameraState extends State<ExplorerPageCamera> {
  late CameraController _camController;
  bool _camIsInitialized = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        body: Stack(children: [
          SizedBox.expand(
            // ^ Sämtlichen Platz einnehmen

            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.cover,
              // ^ AspectRatio vom CameraPreview beibehalten, und einfach so groß zoomen,
              // dass alle Ränder vom Parent berührt werden

              clipBehavior: Clip.none,
              // ^ Das CameraPreview ist jetzt eigentlich außerhalb des Bildschirms noch "aktiv",
              // aber so verbraucht man weniger Performance weil man keine Zeit aufwendet die Kanten
              // zu finden und das Preview dort abzuschneiden

              child: _camIsInitialized
                  ? SizedBox(
                      // ^ Aus irgendwelchen Dubiosen Gründen muss das Preview in einer Box mit fester Größe sein..
                      // Numerische Width und Height der Box sind egal, Verhältnis muss stimmen

                      height: 1 * _camController.value.aspectRatio,
                      width: 1,
                      // _camController.value.aspectRatio ist ~ 0.55
                      // Das beschreibt eigentlich, dass `Breite = Höhe * 0.55` ...
                      // aber for some reason ist das Bild nur korrekt wenn man Höhe * aspectRatio rechnet

                      child: CameraPreview(_camController),
                    )
                  : Container(
                      // Konnte hier kein ProgressIndicator einbauen, weil das zu aufwändig und Zeitverschwendung wäre
                      // Also ist die Seite einfach schwarz solange die Kamera initialisiert
                      color: Colors.transparent,
                    ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: _cameraBtnTapped,
              child: Container(
                height: 75,
                width: 75,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _camController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // An sich wird nicht garantiert darauf gewartet, dass die Kamera initialisiert ist, bevor build() aufgerufen wird.
    // Das ist aber auch nicht so schlimm, weil das UI verändert wird, wenn die Kamera dann ready ist.
    //
    // Bei .initialize().then().onError() wurde auch nicht gewartet.
    // Jetzt ist es mit try-catch und await, was mittlerweile der empfohlene Weg ist
    _initCamController();

    super.initState();
  }

  void _cameraBtnTapped() async {
    // Foto machen
    try {
      if (!_camIsInitialized) return; // Wenn der Button gedrückt wurde, bevor Kamera initialisiert ist, einfach ignorieren

      // Fotoversuch starten
      XFile temp = await _camController.takePicture();
      Globals().imageFile = temp;

      // Foto auf neuer Seite anzeigen
      if (!mounted) return;
      Navigator.of(context).pushNamed('/camera_picture');
    } catch (e) {
      debugPrint("Exception beim Versuch ein Bild aufzunehmen: $e");
    }
  }

  _initCamController() async {
    try {
      _camController = CameraController(
        Globals().cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _camController.initialize();

      setState(() => _camIsInitialized = true);
    } catch (e) {
      debugPrint("Exception bei _initCamController: $e");
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // TODO Wenn man die App weiterentwickelt
            // Hier Overlay anzeigen, welches Nutzer sagt das Berechtigungen fehlen
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }
}
