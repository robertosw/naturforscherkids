import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naturforscherkids/data/globals.dart';

class UserData {
  // Singleton
  static final UserData _instance = UserData._constructor();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Wird lokal gespeichert
  Role? activeRole;
  String? username;

  // Wird jedes mal vom Server erhalten
  String? userSecret;

  /// Nachdem der User alle Daten gelöscht hat, ist die UserID bis zum nächsten Anmelden oder bis zum Schließen der App -1 <br>
  /// (Damit umgeht man dass die userID int? was überall null checks benötigt)
  late int userId;
  List<int> groupIDs = List.empty(growable: true);

  factory UserData() {
    return _instance;
  }
  UserData._constructor();

  void clearAll() {
    activeRole = null;
    username = null;
    userSecret = null;
    userId = -1;
    groupIDs.clear();

    _storage.deleteAll();
  }

  Future<void> loadFromLocal() async {
    try {
      username = await _storage.read(key: "keyUsername");

      String? activeR = await _storage.read(key: "keyActiveRole");
      if (activeR != null) {
        activeRole = Role.values.firstWhere((element) => element.toString() == activeR);
      }
    } catch (e) {
      debugPrint("WARNUNG: Nutzerdaten konnten nicht korrekt gelesen werden. Exception: $e");
      clearAll();
    }
  }

  /// Gibt im Fehlerfall eine Beschreibung als String zurück
  /// Bei Erfolg ist Rückgabe leer
  Future<String> loginUserAndSavePersonalData() async {
    late Response? response;
    try {
      response = await Dio().get(
        "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
        queryParameters: {
          'command': 'login',
          'username': Globals().userData.username,
        },
      );
    } on FormatException catch (_) {
      debugPrint("Serverantwort hat unerwartetes Format");
      return "Serverantwort hat unerwartetes Format";
    } catch (e) {
      debugPrint("Unbekannter Fehler beim Login. Type | Fehler: ${e.runtimeType} | $e");
      return "Unbekannter Fehler beim Login";
    }

    try {
      // ------------------- Response verarbeiten ------------------- //
      if (response.data == null) return "Keine Daten vom Server erhalten";

      // --------------- Statuscode in 200er Bereich? --------------- //
      if (response.statusCode! < 200 || response.statusCode! >= 300) return "Unerwarteter Statuscode ${response.statusCode}";

      Map responseData = json.decode(response.data);
      debugPrint("login response: $responseData");
      String status = responseData["status"];

      // ----------------------- Statuscheck ----------------------- //
      if (status != "success") return "Nutzer existiert nicht";

      // ----- Stimmen angebene Daten und Serverdaten überein? ----- //
      String tempRole = responseData["role"];
      String usernameServer = responseData["username"];

      Role roleServer = (tempRole.contains("teacher")) ? Role.instructor : Role.explorer;
      if (roleServer != Globals().userData.activeRole || Globals().userData.username != usernameServer) {
        return "Falsche Rolle";
      }

      // Alles bestanden  -> Speichern
      userId = int.parse(responseData["person_id"]);
      userSecret = responseData["secret"];

      // Die IDs der Gruppen in welchen man Mitglied ist erhalten. Immer Array[int]
      List<dynamic> temp = responseData["groups"];
      for (var element in temp) {
        UserData().groupIDs.add(int.parse(element));
      }

      secureToLocal();

      debugPrint("Angemeldet als user $userId");
      return "";
    } on TypeError catch (e) {
      debugPrint("TypeError beim Login: $e");
      return "Serverantwort hat unerwarteten Datentyp";
    } catch (e) {
      return "Serverantwort kann nicht verarbeiten werden";
    }
  }

  Future<void> secureToLocal() async {
    try {
      await _storage.write(key: "keyUsername", value: username);
      await _storage.write(key: "keyActiveRole", value: activeRole.toString());
    } catch (e) {
      debugPrint("WARNUNG: Nutzerdaten konnten nicht gespeichert werden. Exception: $e");
      clearAll();
    }
  }
}
