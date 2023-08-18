import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:naturforscherkids/data/user_data.dart';

class GroupManager {
  // ------------------------ Singleton ------------------------ //
  static final GroupManager _instance = GroupManager._constructor();

  factory GroupManager() {
    return _instance;
  }

  GroupManager._constructor();

  // ------------------------ Variablen ------------------------ //

  final List<GroupMember> groupMembers = List.empty(growable: true);
  final List<Group> serverGroups = List.empty(growable: true);
  final List<Group> joinedGroups = List.empty(growable: true);

  // ------------------------ Methoden ------------------------ //

  /// User muss angemeldet sein, Funktion benötigt nur UserName <br>
  /// Bei Neuaufruf werden alte Daten verworfen
  Future<void> getGroupMembersFromServerLoggedIn() async {
    groupMembers.clear();
    // TODO Wenn man die App weitermacht
    // Überprüfen: Wenn man in zwei Gruppen ist, umfasst die Reponse dann Mitglieder beider Gruppen?

    try {
      Response response = await Dio().get(
        "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
        queryParameters: {'command': "get_groupmember", 'username': UserData().username},
      );

      List<dynamic> data = response.data['members'];

      for (Map<String, dynamic> member in data) {
        groupMembers.add(GroupMember(
          id: int.parse(member['person_id']),
          username: member['username'],
          prename: member['first_name'],
          surname: member['last_name'],
        ));
      }

      return;
    } on DioError catch (e) {
      debugPrint("DioError - Inventory: $e");
    } catch (e) {
      debugPrint("Allgemeiner Fehler - Inventory Anfrage: $e");
    }
  }

  /// User muss angemeldet sein, `serverGroups` muss initialisiert sein
  void fillJoinedGroupsFromServerGroupsLoggedIn() {
    joinedGroups.clear();
    for (Group group in serverGroups) {
      if (UserData().groupIDs.contains(group.id)) {
        joinedGroups.add(Group(id: group.id, name: group.name));
      }
    }
  }

  /// Keine Anmeldung und keine weiteren Daten für Aufruf notwendig <br>
  /// Bei Neuaufruf werden alte Daten verworfen
  Future<void> getAllGroupsFromServerAnonymous() async {
    serverGroups.clear();
    Response response = await Dio().get(
      "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
      queryParameters: {'command': "get_groups"},
    );
    debugPrint("GroupsAll Element 1:  ${response.data['groups'][0]}");

    List<dynamic> temp = response.data['groups'];
    for (int i = 0; i < temp.length; i++) {
      serverGroups.add(Group.fromJson(temp[i]));
    }
  }
}

class Group {
  int id;
  String name;

  Group.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['gruppen_id']),
        name = json['name'];

  Group({required this.id, required this.name});
}

class GroupMember {
  final int id;
  final String prename;
  final String surname;
  final String username;
  GroupMember({required this.id, required this.username, required this.prename, required this.surname});
}
