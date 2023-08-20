import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:naturforscherkids/data/user_data.dart';

class Missions {
  static final Missions _instance = Missions._constructor();
  List<Mission> list = List.empty(growable: true);

  factory Missions() {
    return _instance;
  }
  Missions._constructor();

  Future<void> serverRequestAllMissionsAnonymous() async {
    Response? response = await _getRequest();
    if (response != null) {
      _processRequestData(response);
      await checkMission();
    } else {
      debugPrint("Fehler beim Empfangen der Missionsdaten! Reponse ist null");
    }
  }

  Future<Response?> _getRequest() async {
    try {
      // Response response = await Dio().get(
      //   "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
      //   queryParameters: {'command': "get_missions"},
      // );

      Response response = Response(requestOptions: RequestOptions());
      response.data = {
        "missions": [
          {"mission_id": "1", "titel": "Korbblütler", "beschreibung": "Sammle 3 Korbblütler", "typ": "single"},
          {"mission_id": "2", "titel": "Pflanzen (Insekten)", "beschreibung": "Finde 6 Pflanzen, die von Insekten bestäubt werden.", "typ": "single"},
          {"mission_id": "3", "titel": "Pflanzen (Wind)", "beschreibung": "Finde 6 Pflanzen, die durch den Wind bestäubt werden", "typ": "single"},
          {"mission_id": "4", "titel": "Pflanzen (Asien)", "beschreibung": "Finde 4 Pflanzen die ursprünglich aus Asien stammen", "typ": "single"},
          {"mission_id": "5", "titel": "Pflanzen (Wiese)", "beschreibung": "Finde 2 Pflanzen, die auf Wiesen zu finden sind", "typ": "single"},
          {"mission_id": "6", "titel": "Pflanzen (gelb/weiß)", "beschreibung": "Finde 5 Pflanzen, die weiß oder gelb blühen", "typ": "single"},
          {
            "mission_id": "7",
            "titel": "Süßgräser,Heilpflanzen, starker Geruch",
            "beschreibung": "Sammelt 5 Süßgräser,\n1 Pflanze, die ursprünglich aus Afrika stammt,\n4 Pflanzen mit einer heilenden Wirkung,\n3 Pflanzen die einen starken Geruch verströmen",
            "typ": "group"
          }
        ]
      };

      return response;
    } on DioError catch (e) {
      debugPrint("DioError - Missionen: $e");
    } catch (e) {
      debugPrint("Allgemeiner Fehler - Missionen Anfrage: $e");
    }

    return null;
  }

  void _processRequestData(Response<dynamic> response) {
    // Gibt es Missionen?
    // Wenn es das Feld "status"/"reason" in der Rückgabe gibt, dann war etwas nicht erfolgreich.
    try {
      // String status = response.data["status"];
      String reason = response.data["reason"];

      if (reason == "nothing found") {
        debugPrint("Keine Missionen auf Server vorhanden");
        return;
      } else {
        debugPrint("Unbekannter Fehler beim Verarbeiten der Missions-Response: $response");
        return;
      }
    } on TypeError catch (_) {
      // Dieser Fall tritt auf, wenn es das Feld status/reason nicht gibt.
      // Also wenn das korrekte inventar zurückgegeben wird

      // Missionen speichern
      List<dynamic> temp = response.data['missions'];
      debugPrint("Missionen Element 1: ${temp.first}");

      for (int i = 0; i < temp.length; i++) {
        list.add(Mission.fromJson(temp[i]));
      }
    } catch (e) {
      debugPrint("Fehler beim Auswerten der Missions Daten: $e");
    }
  }

  Future<void> _checkPlantForMission(int listId, String taxonName) async {
    // Response response = await Dio().get(
    //   "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
    //   queryParameters: {
    //     'command': 'check_plant',
    //     'taxon_name': taxonName,
    //     'mission_id': listId,
    //   },
    // );

    // debugPrint("Check Plant for Mission $listId : $response");
  }

  Future<void> checkPlantForAllMissions(String taxonName) async {
    // for (int i = 0; i < list.length; i++) {
    //   _checkPlantForMission(list[i].id, taxonName);
    // }
  }

  Future<void> checkMission() async {
    List<MissionStatus> listStatus = List.empty(growable: true);

    // Response response = await Dio().get(
    //   "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
    //   queryParameters: {
    //     'command': 'check_mission',
    //     'userid': UserData().userId,
    //   },
    // );

    Response response = Response(requestOptions: RequestOptions());
    response.data = {
      "mission_status": [
        {"mission_id": 1, "status": "success"},
        {"mission_id": 2, "status": "incomplete"},
        {"mission_id": 3, "status": "incomplete"},
        {"mission_id": 4, "status": "incomplete"},
        {"mission_id": 5, "status": "success"},
        {"mission_id": 6, "status": "incomplete"},
        {"mission_id": 7, "status": "incomplete"}
      ]
    };

    List<dynamic> temp = response.data['mission_status'];

    for (int i = 0; i < temp.length; i++) {
      listStatus.add(MissionStatus.fromJson(temp[i]));
      if (listStatus[i].status == "success") {
        list.firstWhere((element) => element.id == listStatus[i].id).isComplited = true;
      }
      if (listStatus[i].status == "incomplete") {
        list.firstWhere((element) => element.id == listStatus[i].id).isComplited = false;
      }
    }
  }
}

class Mission {
  int id;
  String title;
  String description;

  String type;

  //String _status = "incomplete";
  bool isComplited = false;

  Mission.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['mission_id']),
        title = json['titel'],
        description = json['beschreibung'],
        type = json['typ'];
}

class MissionStatus {
  int id;
  String status;

  MissionStatus.fromJson(Map<String, dynamic> json)
      : id = json['mission_id'],
        status = json['status'];
}
