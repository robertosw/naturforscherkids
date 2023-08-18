import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class Lexicon {
  // Singleton
  static final Lexicon _instance = Lexicon._constructor();
  List<LexiconPlant> allPlants = List.empty(growable: true);

  factory Lexicon() {
    return _instance;
  }
  Lexicon._constructor();

  Future<void> serverRequestLexiconAnonymous() async {
    Response response = await Dio().get(
      "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
      queryParameters: {'command': "get_plants"},
    );

    List<dynamic> temp = response.data['inventory'];
    debugPrint("Lexicon Element 1: ${temp.first}");

    for (int i = 0; i < temp.length; i++) {
      allPlants.add(LexiconPlant.fromJson(temp[i]));
    }
  }
}

class LexiconForUser {
  // Singleton
  static final LexiconForUser _instance = LexiconForUser._constructor();

  List<LexiconPlant> allShowedPlants = List.empty(growable: true);

  factory LexiconForUser() {
    return _instance;
  }
  LexiconForUser._constructor();
}

class LexiconPlant {
  int? id;
  String? name;
  String? taxonName;
  String? geruch;
  String? umgebung;
  String? farbe;
  String? bluete;
  bool displayPlant;

  LexiconPlant.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['pflanzen_id']),
        name = json['name'],
        taxonName = json['taxon'],
        geruch = json['geruch'],
        umgebung = json['umgebung'],
        farbe = json['farbe'],
        bluete = json['blüte'],
        displayPlant = false;
}
