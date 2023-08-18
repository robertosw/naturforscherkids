import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/group.dart';
import 'package:naturforscherkids/data/share_plant.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ContentBuilder {
  static final ContentBuilder _instance = ContentBuilder._constructor();

  /// Dient dafür, sehr schnell zu wissen welchen Content-Index `y` eine Inventory/GardenCard mit ID `x` hat <br>
  /// Mapped also `<x, y>` = `<inventoryid, contentIndex>` <br>
  /// Jeder Key `x` ist einzigartig
  final LinkedHashMap<int, int> _userIdToListId = LinkedHashMap();
  bool _firstCardAlreadySelected = false;

  static final Widget _noGroupMembersFoundInfo = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Tritt einer Gruppe bei um Pflanzen an Gruppenmitglieder zu versenden.", textAlign: TextAlign.center),
        SizedBox.square(dimension: 6),
        Text("Du kannst im Profil mit dem Button 'Gruppe finden' den Beitritt bei einer Gruppe anfragen.", textAlign: TextAlign.center),
      ],
    ),
  );

  factory ContentBuilder() {
    return _instance;
  }

  ContentBuilder._constructor();

  // ---------------------------------- Methoden ---------------------------------- //

  /// Baut den ListView content anhand der aktuellen Daten in Inventory() <br>
  /// und wählt die erste Pflanzenkarte aus (wenn möglich)
  /// <br><br>
  GroupMember? buildContent(List<Widget> contentPtr) {
    _firstCardAlreadySelected = false;

    // ---------------------- Widgets einfügen ---------------------- //

    // Man ist keiner Gruppe beigetreten -> Das dem Nutzer anzeigen
    if (GroupManager().groupMembers.isEmpty) {
      contentPtr.add(_noGroupMembersFoundInfo);
      return null;
    }

    // Überschrift
    contentPtr.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [Text("Deine Gruppenmitglieder", style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal))],
    ));
    contentPtr.add(const SizedBox.square(dimension: 20));

    // Karten der Mitglieder
    GroupMember selectedMember = _addListOfGroupMembers(GroupManager().groupMembers, contentPtr)!;

    // Wenn man hier mal aus mehreren Gruppen Member hat, dann auf return value von _addListOfGroupMembers achten!

    return selectedMember;
  }

  /// Setzt "selected" bei Karte mit übergebener ID auf true
  /// <br><br>
  /// Returns: Ausgewählten GroupMember
  GroupMember selectNewCard(int selectedUserId, int newSelectedUserId, List<Widget> contentPtr) {
    // derzeit ausgewählte Karte nicht mehr auswählen
    int contentIndexCurrentCard = _userIdToListId[selectedUserId] as int;
    dynamic currentCard = contentPtr[contentIndexCurrentCard];

    if (currentCard is UIUserCard) {
      contentPtr[contentIndexCurrentCard] = _newCardWithSelection(isSelected: false, contentPtr: contentPtr, contentIndex: contentIndexCurrentCard);
    } else {
      throw Exception({
        "message": "Derzeit ausgewählte Card kann nicht gefunden werden. Die übergebenen Infos zeigen nicht auf eine UIUserCard",
        "runtime variables": {
          "currently selectedCard": {"id": selectedUserId, "content length": contentPtr.length}
        }
      });
    }

    // Neue Karte auswählen
    late GroupMember selectedMember;
    int contentIndexTargetCard = _userIdToListId[newSelectedUserId] as int;
    dynamic targetCard = contentPtr[contentIndexTargetCard];

    if (targetCard is UIUserCard) {
      contentPtr[contentIndexTargetCard] = _newCardWithSelection(isSelected: true, contentPtr: contentPtr, contentIndex: contentIndexTargetCard);
      selectedMember = GroupMember(id: targetCard.userId, username: targetCard.userName, prename: targetCard.prename, surname: targetCard.surname);
    } else {
      throw Exception({
        "message": "Auszuwählende Card kann nicht gefunden werden. Die übergebenen Infos zeigen nicht auf eine UIUserCard",
        "runtime variables": {
          "currently selectedCard": {"id": selectedUserId, "content length": contentPtr.length},
          "targeted card": {"id": newSelectedUserId}
        }
      });
    }

    return selectedMember;
  }

  /// Returns: Ausgewählten Member, oder null wenn keiner ausgewählt wurde
  GroupMember? _addListOfGroupMembers(Iterable<GroupMember> members, List<Widget> contentPtr) {
    GroupMember? selectedMember;

    for (GroupMember member in members) {
      // Card pro Member hinzufügen, erste markieren
      if (_firstCardAlreadySelected == false) {
        contentPtr.add(UIUserCard(
          userId: member.id,
          selected: true,
          userName: member.username,
          prename: member.prename,
          surname: member.surname,
        ));
        selectedMember = GroupMember(id: member.id, username: member.username, prename: member.prename, surname: member.surname);
        _firstCardAlreadySelected = true;
      } else {
        contentPtr.add(UIUserCard(
          userId: member.id,
          selected: false,
          userName: member.username,
          prename: member.prename,
          surname: member.surname,
        ));
      }

      // In Map speichern, welchen Index diese Pflanzenkarte im ListView content hat
      int contentIndexOfLastElement = contentPtr.length - 1;
      _userIdToListId.addAll({member.id: contentIndexOfLastElement});

      // Seperator einfügen
      contentPtr.add(const SizedBox.square(dimension: 10));
    }

    return selectedMember;
  }

  Widget _newCardWithSelection({required bool isSelected, required List<Widget> contentPtr, required int contentIndex}) {
    try {
      UIUserCard targetCard = contentPtr[contentIndex] as UIUserCard;
      return UIUserCard(
        userId: targetCard.userId,
        selected: isSelected,
        userName: targetCard.userName,
        prename: targetCard.prename,
        surname: targetCard.surname,
      );
    } catch (e) {
      throw Exception({
        "message": "Die übergebenen Infos zeigen nicht auf eine UIUserCard",
        "runtime variables": {
          "isSelected": isSelected,
          "content length": contentPtr.length,
          "id": contentIndex,
          "targeted element": contentPtr[contentIndex],
        }
      });
    }
  }
}

class ExplorerTabPlantShare extends StatefulWidget {
  const ExplorerTabPlantShare({super.key, required this.plantId});

  final int plantId;

  @override
  State<ExplorerTabPlantShare> createState() => ExplorerTabPlantShareState();
}

class ExplorerTabPlantShareState extends State<ExplorerTabPlantShare> {
  List<Widget> _content = List.empty(growable: true);
  GroupMember? _selectedMember;

  late String _buttonText;
  Color? _buttonTextColor;

  @override
  void initState() {
    _selectedMember = ContentBuilder().buildContent(_content);
    _buttonText = "Pflanze an ${_selectedMember?.prename} senden";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: NotificationListener(
        onNotification: (notification) => (notification is NotifNewCardSelected) ? _newCardSelected(notification) : false,
        child: (_selectedMember == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _content,
              )
            : ListView(children: _content),
      ),
      bottomRow: NaturfkBottomRow3(
        leftSquare: NaturfkSquareIconBtn(
          icon: Icons.arrow_back,
          onTap: () => NaturfkNotifyGoBackOneTabPage().dispatch(context),
        ),
        center: NaturfkTextButton(
          text: _buttonText,
          onTap: _onShareBtnTapped,
          disabled: (_selectedMember == null) ? true : false,
          textColor: _buttonTextColor,
        ),
      ),
    );
  }

  Future<void> _onShareBtnTapped() async {
    setState(() {
      _buttonText = "Pflanze versenden..";
      _buttonTextColor = Colors.grey.shade800;
    });
    bool status = await SharePlant().sharePlant(widget.plantId, _selectedMember!.id);

    //
    if (status == true) {
      _resetButtonProperties();
      Future.sync(() => NaturfkNotifyGoBackOneTabPage().dispatch(context));
    }

    //
    else {
      setState(() {
        _buttonText = "Fehler beim Versenden";
        _buttonTextColor = Colors.red;
      });

      // Nach 5sek Button wieder zurücksetzen
      Future.delayed(const Duration(seconds: 5), () => _resetButtonProperties());
    }
  }

  void _resetButtonProperties() {
    setState(() {
      _buttonTextColor = null;
      _buttonText = "Pflanze an ${_selectedMember?.prename} senden";
    });
  }

  bool _newCardSelected(NotifNewCardSelected notification) {
    GroupMember temp = ContentBuilder().selectNewCard(_selectedMember!.id, notification.userId, _content);
    List<Widget> copyOfContent = List.from(_content);

    setState(() {
      _selectedMember = temp;
      _buttonText = "Pflanze an ${_selectedMember?.prename} senden";

      // content ist eine Liste und wird daher immer als Pointer übergeben.
      // Problem ist das setState dadurch keine Änderungen mitbekommt.
      // Muss also manuell überschrieben werden (nur _content = ...) ist gültig, die ganzen Array-Kopiermethoden funktionieren NICHT!
      _content = copyOfContent;
    });

    return true;
  }
}

class UIUserCard extends StatelessWidget {
  final int userId;
  final bool selected;
  final String userName;
  final String prename;
  final String surname;

  const UIUserCard({super.key, required this.userId, required this.selected, required this.userName, required this.prename, required this.surname});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NotifNewCardSelected(userId, userName).dispatch(context),
      child: Card(
        shape: _showSelectionState(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2.5, 20, 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 50,
                child: Icon(Icons.person, color: Colors.grey.shade900),
              ),
              const SizedBox.square(dimension: 5),
              Expanded(child: Text("$prename $surname", maxLines: 1, overflow: TextOverflow.ellipsis)),
              Text(userName, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  ShapeBorder? _showSelectionState(BuildContext context) {
    if (selected) {
      return RoundedRectangleBorder(
        side: BorderSide(color: Colors.green.shade600.withOpacity(0.9), width: 2),
        borderRadius: BorderRadius.circular(12),
      );
    } else {
      return Theme.of(context).cardTheme.shape;
    }
  }
}

class NotifNewCardSelected extends Notification {
  final int userId;
  final String userName;
  NotifNewCardSelected(this.userId, this.userName);
}
