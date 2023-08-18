// Der Sinn dieser Datei ist es, in jeder anderen Datei eingebunden zu sein,
// damit überall enums und selbst erstellte Klassen genutzt werden können und
// global zu speichernde Daten einfach geschrieben und gelesen werden können

// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naturforscherkids/data/group.dart';
import 'package:naturforscherkids/data/inventory.dart';
import 'package:naturforscherkids/data/lexicon.dart';
import 'package:naturforscherkids/data/mission.dart';
import 'package:naturforscherkids/data/user_data.dart';

class Globals {
  static final Globals _instance = Globals._constructor();

  final UserData userData = UserData();
  final Dio dio = Dio();

  late List<CameraDescription> cameras;
  late XFile imageFile;

  factory Globals() {
    return _instance;
  }
  Globals._constructor();

  // ------------------------------------------------ Methoden ------------------------------------------------ //

  Future<void> getAllServerData() async {
    // Future.wait sorgt dafür das alle darin enthaltenen async Funktionen multithreaded aufgerufen und abgewartet werden
    // Hier also aufpassen, dass die Funktionen nicht gegenseitig auf den gleichen Variablen schreiben oder die eine schreibt und die andere ließt
    await Future.wait([
      GroupManager().getAllGroupsFromServerAnonymous(),
      GroupManager().getGroupMembersFromServerLoggedIn(),
      Inventory().serverRequestInventoryLoggedIn(),
      Inventory().serverRequestGardenLayoutLoggedIn(),
      Lexicon().serverRequestLexiconAnonymous(),
      Missions().serverRequestAllMissionsAnonymous(),
    ]);
    GroupManager().fillJoinedGroupsFromServerGroupsLoggedIn();
    buildLexiconForUser();
  }

  /// Diese Funktion entscheidet auf welcher Seite die App nach Login beginnt <br>
  String getRouteForRole() {
    // Keine Rolle ausgewählt -> App zum ersten mal gestartet -> Auswahlbildschirm
    if (userData.activeRole == null || userData.username == null) {
      return '/login';
    }

    // Rolle ausgewählt & Daten vorhanden -> Startbildschirm der Rolle
    if (userData.activeRole == Role.explorer) {
      return '/explorer_home';
    } else {
      return '/instructor_home';
    }
  }

  void buildLexiconForUser() {
    LexiconForUser().allShowedPlants = List.from(Lexicon().allPlants);

    // Pflanzen ermitteln, die nicht vollständig angezeigt werden sollen
    for (int i = 0; i < Inventory().list.length; i++) {
      for (int j = 0; j < LexiconForUser().allShowedPlants.length; j++) {
        String invPlant = Inventory().list[i].name.toString();
        String lexPlant = LexiconForUser().allShowedPlants[j].name.toString();
        if (invPlant.compareTo(lexPlant) == 0) {
          LexiconForUser().allShowedPlants[j].displayPlant = true;
        }
      }
    }

    // Pflanzen, die nicht vollständig angezeigt werden sollen, modifizieren
    for (int j = 0; j < LexiconForUser().allShowedPlants.length; j++) {
      if (LexiconForUser().allShowedPlants[j].displayPlant == false) {
        LexiconForUser().allShowedPlants[j].farbe = "-";
        LexiconForUser().allShowedPlants[j].geruch = "-";
        LexiconForUser().allShowedPlants[j].taxonName = "-";
        LexiconForUser().allShowedPlants[j].bluete = "-";
      }
    }
  }
}

class PictureHandling {
  // Die jetzt leeren Funktionen nutzen die API von inaturalist

  // Singleton
  static final PictureHandling _instance = PictureHandling._constructor();

  int? observationId;
  int? guessedPlantId;

  String? observationUuid;
  factory PictureHandling() {
    return _instance;
  }
  PictureHandling._constructor();

  Future<void> _createNewObservation() async {
    debugPrint("_createNewObservation aufgerufen, Funktion ist in diesem Projekt leer.");
  }

  Future<void> _postObservationPhotos() async {
    debugPrint("_postObservationPhotos aufgerufen, Funktion ist in diesem Projekt leer.");
  }

  Future<String> _guessPlant() async {
    debugPrint("_guessPlant aufgerufen, Funktion ist in diesem Projekt leer.");
    return "Ok";
  }

  Future<void> setPlantToInventory() async {
    debugPrint("setPlantToInventory aufgerufen, Funktion ist in diesem Projekt leer.");
  }

  Future<String> makeKIGuess() async {
    await _createNewObservation();
    await _postObservationPhotos();
    return await _guessPlant();
  }
}

class AllGuessedPlants {
  static final AllGuessedPlants _instance = AllGuessedPlants._constructor();
  List<GuessedPlant> allGuessedPlants = List.empty(growable: true);

  factory AllGuessedPlants() {
    return _instance;
  }
  AllGuessedPlants._constructor();

  fromJson(List<dynamic> input) {
    for (int i = 0; i < input.length; i++) {
      AllGuessedPlants().allGuessedPlants.add(GuessedPlant.fromJson(input[i]));
    }
  }
}

class GuessedPlant {
  String taxonName;
  String commonName;
  double score;

  GuessedPlant.fromJson(Map<String, dynamic> json)
      : taxonName = json['taxon_name'],
        commonName = json['common_name'],
        score = json['score'];
}

enum Role { instructor, explorer }
