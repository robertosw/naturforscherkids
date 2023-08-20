import 'package:flutter/material.dart';
import 'package:naturforscherkids/ui/explorer/inventory/tab_inventory.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ExplorerTabGarden extends StatefulWidget {
  const ExplorerTabGarden({super.key, this.plantIdForUnity});

  /// tab_garden sendet diese ID beim Start an Unity, wenn nicht null
  final int? plantIdForUnity;

  // Muss drin sein für Unity-Build
  // @override
  // State<ExplorerTabGarden> createState() => _GardenState();

  // Standard für die Entwicklung für Flutter only
  @override
  State<ExplorerTabGarden> createState() => _GardenEmptyState();
}

// class _GardenState extends State<ExplorerTabGarden> {
//   late UnityWidgetController _uwController;

//   void _onUnityCreated(UnityWidgetController controller) async {
//     _uwController = controller;

//     await _sendPlantToUnity();

//     // GartenLayout an Unity schicken
//     late Map gardenForUnity;

//     if (Inventory().gardenLayout.isNotEmpty) {
//       gardenForUnity = {"beets": Inventory().gardenLayout};
//     } else {
//       gardenForUnity = {"beets": []};
//     }

//     String gardenAsString = gardenForUnity.toString();
//     String gardenRawAsJSON = jsonEncode(gardenForUnity);
//     String gardenStringAsJSON = jsonEncode(gardenForUnity.toString());

//     debugPrint("gardenForUnity als String: $gardenAsString");
//     debugPrint("gardenForUnity raw als JSON Encoded: $gardenRawAsJSON");
//     debugPrint("gardenForUnity string als JSON Encoded: $gardenStringAsJSON");

//     await _uwController.postMessage("Ground", "ReceivePatchData", gardenAsString);
//     await _uwController.postMessage("Ground", "ReceivePatchData", gardenRawAsJSON);
//     await _uwController.postMessage("Ground", "ReceivePatchData", gardenStringAsJSON);
//   }

//   Future<void> _sendPlantToUnity() async {
//     // Einpflanzen einer Pflanze
//     // Zur Sicherheit den String lokal kopieren, weil in der Ausführungszeit hier, könnte sich der Inhalt ändern, weil alle drauf zugreifen können
//     if (widget.plantIdForUnity != null) {
//       int plantId = widget.plantIdForUnity!;

//       Map<String, int> jsonForUnity = {
//         "user_id": UserData().userId,
//         "plant_id": plantId,
//       };
//       await _uwController.postJsonMessage("Ground", "ReceiveFlowerData", jsonForUnity);
//     } else {
//       debugPrint("Es konnte keine Pflanze an Unity gesendet werden. Es wurde keine plantId angegeben.");
//     }
//   }

//   @override
//   void dispose() {
//     _uwController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NaturfkPageSlim(
//       body: SizedBox.expand(
//         child: UnityWidget(
//           // Settings
//           runImmediately: true,
//           unloadOnDispose: false,
//           fullscreen: true,
//           hideStatus: true,

//           // EventHandler
//           onUnityCreated: _onUnityCreated,
//           onUnitySceneLoaded: (SceneLoaded? sceneLoaded) async => await _sendPlantToUnity(),
//           onUnityMessage: (dynamic handler) => print("Message from Unity: $handler"),
//           onUnityUnloaded: () => _uwController.dispose(),
//         ),
//       ),
//       bottomRow: NaturfkBottomRow3(
//         center: NaturfkTextButton(
//           text: "Inventar",
//           onTap: () => NaturfkNotifyChangeTabPage(newPageWidget: const ExplorerTabInventory()).dispatch(context),
//         ),
//         rightSquare: NaturfkSquareIconBtn(icon: Icons.add_a_photo_outlined, onTap: () => Navigator.of(context).pushNamed("/camera")),
//       ),
//     );
//   }
// }

class _GardenEmptyState extends State<ExplorerTabGarden> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: const Center(child: Text("Hier war der Unity Garten zu sehen")),
      bottomRow: NaturfkBottomRow3(
        center: NaturfkTextButton(
          text: "Inventar",
          onTap: () => NaturfkNotifyChangeTabPage(newPageWidget: const ExplorerTabInventory()).dispatch(context),
        ),
        rightSquare: NaturfkSquareIconBtn(icon: Icons.add_a_photo_outlined, onTap: () => Navigator.of(context).pushNamed("/camera")),
      ),
    );
  }
}
