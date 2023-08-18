import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:naturforscherkids/data/inventory.dart';
import 'package:naturforscherkids/data/user_data.dart';

class SharePlant {
  static final SharePlant _instance = SharePlant._constructor();

  factory SharePlant() {
    return _instance;
  }
  SharePlant._constructor();

  // ------------------------------------------------ Methoden ------------------------------------------------ //

  /// returns: `true` bei Erfolg | `false` bei Misserfolg
  Future<bool> sharePlant(int plantId, int targetUserId) async {
    Dio dio = Dio();
    // dio.interceptors.add(LogInterceptor(request: false, requestHeader: false, requestBody: false, responseBody: true, responseHeader: false));
    Response response = await dio.post(
      "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
      queryParameters: {
        'command': 'share',
        'from_user': UserData().userId,
        'to_user': targetUserId,
        'count': 1,
        'pflanzen_id': plantId,
      },
    );

    try {
      Map<String, dynamic> responseData = jsonDecode(response.data);

      if (responseData['status'] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  // Funktion muss in Inventory und bekommt Id übergeben
  Future<void> setPlantToInventory(int? plantId) async {
    Response response = await Dio().get(
      "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
      queryParameters: {
        'command': 'set_plant',
        'user_id': UserData().userId,
        'plant_id': plantId,
      },
    );

    debugPrint("Plant To Inventory: $response");
    String? responseStatus = response.data["status"];

    if (responseStatus == "success") {
      Inventory().serverRequestInventoryLoggedIn();
    }
  }

  Future<void> getSharePlant() async {
    AllShares().allShares.clear();

    Response response = await Dio().get(
      "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
      queryParameters: {
        'command': 'get_shares',
        'userid': UserData().userId,
      },
    );

    debugPrint("getSharedPlant: $response");

    AllShares().fromJson(response.data);
    //String? responseStatus = response.data["status"];
  }

  Future<void> setAllSharedPlantsToInventory() async {
    for (int i = 0; i < AllShares().allShares.length; i++) {
      setPlantToInventory(AllShares().allShares[i].pflanzenId);
    }
  }
}

class AllShares {
  // Singleton
  static final AllShares _instance = AllShares._constructor();

  List<Share> allShares = List.empty(growable: true);

  List<dynamic> _inv = List.empty(growable: true);

  factory AllShares() {
    return _instance;
  }
  AllShares._constructor();

  fromJson(Map<String, dynamic> json) {
    _inv = json['shares'];
    for (int i = 0; i < _inv.length; i++) {
      allShares.add(Share.fromJson(_inv[i]));
    }
  }
}

class Share {
  int? teilenId;
  String? von;
  String? an;
  String? pflanzenName;
  int? pflanzenId;
  int? anzahl;

  Share.fromJson(Map<String, dynamic> json)
      : teilenId = int.parse(json['teilen_id']),
        von = json['von'],
        an = json['an'],
        pflanzenName = json['pflanzen_name'],
        pflanzenId = int.parse(json['pflanzen_id']),
        anzahl = int.parse(json['anzahl']);
}
