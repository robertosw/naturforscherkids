import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:naturforscherkids/data/user_data.dart';

class Inventory {
  static final Inventory _instance = Inventory._constructor();
  List<InventoryPlant> list = List.empty(growable: true);
  List<Map<String, dynamic>> gardenLayout = List.empty(growable: true);

  factory Inventory() {
    return _instance;
  }
  Inventory._constructor();

  Future<void> serverRequestInventoryLoggedIn() async {
    Response? response = await _getInventory();
    if (response != null) {
      _processInventoryRequestData(response);
    } else {
      debugPrint("Fehler beim Empfangen der Inventardaten! Reponse ist null");
    }
  }

  Future<void> serverRequestGardenLayoutLoggedIn() async {
    Response? response = await _getLayout();
    if (response != null) {
      _processLayoutRequestData(response);
    } else {
      debugPrint("Fehler beim Empfangen der Inventardaten! Reponse ist null");
    }
  }

  Future<Response?> _getInventory() async {
    try {
      Response response = await Dio().get(
        "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
        queryParameters: {'command': "get_inventory", 'user': UserData().userId.toString()},
      );

      return response;
    } on DioError catch (e) {
      debugPrint("DioError - Inventory: $e");
    } catch (e) {
      debugPrint("Allgemeiner Fehler - Inventory Anfrage: $e");
    }

    return null;
  }

  Future<Response?> _getLayout() async {
    try {
      Response response = await Dio().get(
        "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
        queryParameters: {'command': "get_layout", 'userid': UserData().userId},
      );

      return response;
    } on DioError catch (e) {
      debugPrint("DioError - Pflanzenfarben: $e");
    } catch (e) {
      debugPrint("Allgemeiner Fehler - Pflanzenfarben-Anfrage: $e");
    }

    return null;
  }

  void _processInventoryRequestData(Response<dynamic> response) {
    // Hat der Nutzer etwas im Inventar?
    // Wenn es das Feld "status"/"reason" in der Rückgabe gibt, dann war etwas nicht erfolgreich.

    try {
      Map<dynamic, dynamic> responseData = response.data;
      if (responseData.isEmpty) {
        debugPrint("Inventar für userId ${UserData().userId} ist leer");
        return;
      }

      String status = response.data["status"];
      String reason = response.data["reason"];

      if (reason == "nothing found") {
        debugPrint("Inventar für userId ${UserData().userId} ist leer");
        return;
      } else {
        debugPrint("Es konnte nicht bestimmt werden ob Inventar leer oder voll ist. status: $status");
        return;
      }
    } on TypeError catch (_) {
      // Dieser Fall tritt auf, wenn es das Feld status/reason nicht gibt.
      // Also wenn das korrekte inventar zurückgegeben wird

      // Inventar speichern
      List<dynamic> invDynamic = response.data['inventory'];
      debugPrint("Inventory Element 1: ${invDynamic.first}");

      // Alle Pflanzen die die gleiche plant_id haben, aufsummieren und nur als eine Pflanze speichern
      List<InventoryPlant> invUnprocessed = List.empty(growable: true);
      for (int i = 0; i < invDynamic.length; i++) {
        invUnprocessed.add(InventoryPlant.fromJson(invDynamic[i]));
      }

      List<InventoryPlant> filtered = doStuff(invUnprocessed);

      //invUnprocessed is processed from here on

      list.clear(); // Damit diese Funktion beim Refresh neu aufgerufen werden kann
      for (int i = 0; i < filtered.length; i++) {
        list.add(filtered[i]);
      }
    } catch (e) {
      debugPrint("Fehler beim Auswerten der Inventory Daten: $e");
    }
  }

  List<InventoryPlant> doStuff(List<InventoryPlant> inventory) {
    List<InventoryPlant> uniqueInventory = [];
    List<int> uniquePlantIds = [];

    for (InventoryPlant plant in inventory) {
      if (uniquePlantIds.contains(plant.plantId)) {
        int indexOfUniquePlant = uniqueInventory.indexWhere((InventoryPlant uniquePlant) => plant.plantId == uniquePlant.plantId);
        uniqueInventory[indexOfUniquePlant].amount++;
      } else {
        uniqueInventory.add(plant);
        uniquePlantIds.add(plant.plantId);
      }
    }

    return uniqueInventory;
  }

  void _processLayoutRequestData(Response<dynamic> response) {
    // Hat der Nutzer etwas im Beet?
    // Wenn es das Feld "status"/"reason" in der Rückgabe gibt, dann war etwas nicht erfolgreich.

    try {
      Map<dynamic, dynamic> responseData = response.data;
      if (responseData.isEmpty) {
        debugPrint("Garten für userId ${UserData().userId} ist leer");
        return;
      }

      String status = response.data["status"];
      // String reason = response.data["reason"];

      if (status == "failed") {
        debugPrint("Garten für userId ${UserData().userId} ist leer");
        return;
      }
    } on TypeError catch (_) {
      // Dieser Fall tritt auf, wenn es das Feld status/reason nicht gibt.
      // Also wenn das Gartenlayout zurückgegeben wird
    } catch (e) {
      debugPrint("Fehler beim Auswerten der Inventory Daten: $e");
      return;
    }

    try {
      // Garten Layout  speichern
      gardenLayout.clear();

      for (Map<String, dynamic> element in response.data['beets']) {
        gardenLayout.add(element);
      }

      debugPrint("Garden Layout Element 1: ${gardenLayout.first}");
    } catch (e) {
      debugPrint("Fehler beim Verarbeiten des GartenLayouts: $e");
      return;
    }
  }
}

class InventoryPlant {
  String name;
  int amount;
  int plantId;
  int waterlevel;
  bool isPlanted;

  InventoryPlant({
    required this.name,
    required this.amount,
    required this.plantId,
    required this.waterlevel,
    required this.isPlanted,
  });

  InventoryPlant.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        amount = int.parse(json['anzahl']),
        plantId = int.parse(json['pflanzen_id']),
        waterlevel = int.parse(json['wasserlevel']),
        isPlanted = json['garden'];
}
