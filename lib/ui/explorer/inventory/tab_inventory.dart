import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/inventory.dart';
import 'package:naturforscherkids/ui/explorer/inventory/tab_inventory_widgets.dart';
import 'package:naturforscherkids/ui/explorer/inventory/tab_plant_share.dart';
import 'package:naturforscherkids/ui/explorer/tab_garden.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ContentBuilder {
  static final ContentBuilder _instance = ContentBuilder._constructor();

  /// Dient dafür, sehr schnell zu wissen welchen Content-Index `y` eine Inventory/GardenCard mit ID `x` hat <br>
  /// Mapped also `<x, y>` = `<inventoryid, contentIndex>` <br>
  /// Jeder Key `x` ist einzigartig
  final LinkedHashMap<int, int> _plantIdToListId = LinkedHashMap();
  bool _firstCardAlreadySelected = false;

  final Widget _gardenEmptyInfo = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Du hast noch keine Pflanzen im Garten.", textAlign: TextAlign.center),
        SizedBox.square(dimension: 6),
        Text("Wähle eine Pflanze vom Inventar aus und pflanze sie mit dem Button unten ein.", textAlign: TextAlign.center),
      ],
    ),
  );

  final Widget _inventoryEmptyInfo = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Dein Inventar ist leer.", textAlign: TextAlign.center),
        SizedBox.square(dimension: 6),
        Text("Wenn du Gartenpflanzen auspflanzt, werden sie hier gelagert.", textAlign: TextAlign.center),
      ],
    ),
  );

  final Widget _invAndGardenEmptyInfo = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Du hast noch keine Pflanzen gesammelt.", textAlign: TextAlign.center),
        SizedBox.square(dimension: 6),
        Text("Finde mithilfe der Missionen oder des Lexikons echte Pflanzen und scanne diese mit der App ein.", textAlign: TextAlign.center),
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
  /// Returns InventoryPlant, wenn eine Karte ausgewählt wurde, sonst null
  InventoryPlant? buildContent(List<Widget> contentPtr) {
    _firstCardAlreadySelected = false;
    Iterable<InventoryPlant> unplantedPlants = Inventory().list.where((InventoryPlant plant) => plant.isPlanted == false);
    Iterable<InventoryPlant> plantedPlants = Inventory().list.where((InventoryPlant plant) => plant.isPlanted == true);

    print("unplantedPlants: ${unplantedPlants.length}");

    InventoryPlant? selectedPlant;

    // ---------------------- Widgets einfügen ---------------------- //
    if (unplantedPlants.isEmpty && plantedPlants.isEmpty) {
      contentPtr.add(_invAndGardenEmptyInfo);
      return selectedPlant;
    }

    // Inventar Überschrift
    contentPtr.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [Text("Pflanzen im Inventar", style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal))],
    ));
    contentPtr.add(const SizedBox.square(dimension: 20));

    // Inventarpflanzen
    if (unplantedPlants.isNotEmpty) {
      InventoryPlant? temp = _addListOfPlantCards(false, unplantedPlants, contentPtr);
      if (temp != null) selectedPlant = temp;
    } else {
      contentPtr.add(_inventoryEmptyInfo);
    }

    // Garten Überschrift
    contentPtr.add(const SizedBox.square(dimension: 30));
    contentPtr.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [Text("Pflanzen im Garten", style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal))],
    ));
    contentPtr.add(const SizedBox.square(dimension: 20));

    // Gartenpflanzen
    if (plantedPlants.isNotEmpty) {
      InventoryPlant? temp = _addListOfPlantCards(true, plantedPlants, contentPtr);
      if (temp != null) selectedPlant = temp;
    } else {
      contentPtr.add(_gardenEmptyInfo);
    }

    return selectedPlant;
  }

  /// Setzt "selected" bei Karte mit übergebener ID auf true
  /// <br><br>
  /// Returns InventoryPlant = neu ausgewählte Karte
  InventoryPlant selectNewCard(int selectedPlantId, int newSelectedPlantId, List<Widget> contentPtr) {
    // derzeit ausgewählte Karte nicht mehr auswählen
    int contentIndexCurrentCard = _plantIdToListId[selectedPlantId] as int;
    dynamic currentCard = contentPtr[contentIndexCurrentCard];

    if (currentCard is UIAdaptiveCard) {
      contentPtr[contentIndexCurrentCard] = _newCardWithSelection(isPlanted: currentCard.isPlanted, isSelected: false, contentPtr: contentPtr, contentIndex: contentIndexCurrentCard);
    } else {
      throw Exception({
        "message": "Derzeit ausgewählte Card kann nicht gefunden werden. Die übergebenen Infos zeigen nicht auf eine UIAdaptiveCard",
        "runtime variables": {
          "currently selectedCard": {"id": selectedPlantId, "content length": contentPtr.length}
        }
      });
    }

    // Neue Karte auswählen
    late InventoryPlant selectedPlant;
    int contentIndexTargetCard = _plantIdToListId[newSelectedPlantId] as int;
    dynamic targetCard = contentPtr[contentIndexTargetCard];

    if (targetCard is UIAdaptiveCard) {
      contentPtr[contentIndexTargetCard] = _newCardWithSelection(isPlanted: targetCard.isPlanted, isSelected: true, contentPtr: contentPtr, contentIndex: contentIndexTargetCard);
      selectedPlantId = newSelectedPlantId;
      selectedPlant = InventoryPlant(
        name: targetCard.plantName,
        amount: targetCard.amount,
        plantId: targetCard.plantId,
        waterlevel: targetCard.waterlevel,
        isPlanted: targetCard.isPlanted,
      );
    } else {
      throw Exception({
        "message": "Auszuwählende Card kann nicht gefunden werden. Die übergebenen Infos zeigen nicht auf eine UIAdaptiveCard",
        "runtime variables": {
          "currently selectedCard": {"id": selectedPlantId, "content length": contentPtr.length},
          "targeted card": {"id": newSelectedPlantId}
        }
      });
    }

    return selectedPlant;
  }

  /// Return InventoryPlant, wenn eine Karte ausgewählt wurde, sonst null
  InventoryPlant? _addListOfPlantCards(bool isPlanted, Iterable<InventoryPlant> listOfPlants, List<Widget> contentPtr) {
    InventoryPlant? selectedPlant;

    // Inventarpflanzen
    for (InventoryPlant plant in listOfPlants) {
      // Reihenfolge wichtig, wenn verändert unten Index überprüfen!

      int? waterlevel = plant.waterlevel;

      // Card pro Pflanze hinzufügen, erste markieren
      if (_firstCardAlreadySelected == false) {
        contentPtr.add(UIAdaptiveCard(
          plantId: plant.plantId,
          selected: true,
          plantName: plant.name,
          amount: plant.amount,
          isPlanted: isPlanted,
          waterlevel: waterlevel,
        ));
        selectedPlant = InventoryPlant(name: plant.name, amount: plant.amount, plantId: plant.plantId, waterlevel: plant.waterlevel, isPlanted: plant.isPlanted);
        _firstCardAlreadySelected = true;
      } else {
        contentPtr.add(UIAdaptiveCard(
          plantId: plant.plantId,
          selected: false,
          plantName: plant.name,
          amount: plant.amount,
          isPlanted: isPlanted,
          waterlevel: waterlevel,
        ));
      }

      // In Map speichern, welchen Index diese Pflanzenkarte im ListView content hat
      int contentIndexOfLastElement = contentPtr.length - 1;
      _plantIdToListId.addAll({plant.plantId: contentIndexOfLastElement});

      // Seperator einfügen
      contentPtr.add(const SizedBox.square(dimension: 10));
    }
    return selectedPlant;
  }

  // ---------------------------------- Methoden ---------------------------------- //
  Widget _newCardWithSelection({required bool isPlanted, required bool isSelected, required List<Widget> contentPtr, required int contentIndex}) {
    try {
      UIAdaptiveCard targetCard = contentPtr[contentIndex] as UIAdaptiveCard;
      return UIAdaptiveCard(
        isPlanted: isPlanted,
        plantId: targetCard.plantId,
        selected: isSelected,
        plantName: targetCard.plantName,
        amount: targetCard.amount,
        waterlevel: targetCard.waterlevel,
      );
    } catch (e) {
      throw Exception({
        "message": "Die übergebenen Infos zeigen nicht auf eine UIAdaptiveCard",
        "runtime variables": {
          "isPlanted": isPlanted,
          "isSelected": isSelected,
          "content length": contentPtr.length,
          "id": contentIndex,
          "targeted element": contentPtr[contentIndex],
        }
      });
    }
  }
}

class ExplorerTabInventory extends StatefulWidget {
  const ExplorerTabInventory({super.key});

  @override
  State<ExplorerTabInventory> createState() => ExplorerTabInventoryState();
}

class ExplorerTabInventoryState extends State<ExplorerTabInventory> {
  List<Widget> _pageContent = List.empty(growable: true);
  bool _isRefreshButtonBusy = false;

  InventoryPlant? _selectedCard;

  @override
  void initState() {
    _buildPageContent();
    _selectedCard = ContentBuilder().buildContent(_pageContent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: NotificationListener(
        onNotification: (notification) => (notification is NotifNewCardSelected) ? _handleNotifNewCardSelected(notification) : false,
        child: (_selectedCard == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageContent,
              )
            : ListView(children: _pageContent),
      ),
      bottomRow: NaturfkBottomRow3(
        leftSquare: NaturfkSquareIconBtn(
          icon: Icons.refresh_sharp,
          onTap: () => _buildPageContent(),
          isBusy: _isRefreshButtonBusy,
        ),
        center: _buildCenterButton(context, _selectedCard),
        rightSquare: _buildShareButton(context, _selectedCard),
      ),
    );
  }

  void _buildPageContent() async {
    if (!mounted) return;

    setState(() => _isRefreshButtonBusy = true);
    await Inventory().serverRequestInventoryLoggedIn();

    _pageContent.clear(); // Altes Inventar löschen
    InventoryPlant? temp = ContentBuilder().buildContent(_pageContent);
    List<Widget> copyOfContent = List.from(_pageContent);

    if (!mounted) return;
    setState(() {
      _selectedCard = temp;

      // content ist eine Liste und wird daher immer als Pointer übergeben.
      // Problem ist das setState dadurch keine Änderungen mitbekommt.
      // Muss also manuell überschrieben werden (nur _content = ...) ist gültig, die ganzen Array-Kopiermethoden funktionieren NICHT!
      _pageContent = copyOfContent;

      _isRefreshButtonBusy = false;
    }); // UI neubauen
  }

  bool _handleNotifNewCardSelected(NotifNewCardSelected notification) {
    InventoryPlant temp = ContentBuilder().selectNewCard(_selectedCard!.plantId, notification.plantId, _pageContent);
    List<Widget> copyOfContent = List.from(_pageContent);

    setState(() {
      _selectedCard = temp;

      // content ist eine Liste und wird daher immer als Pointer übergeben.
      // Problem ist das setState dadurch keine Änderungen mitbekommt.
      // Muss also manuell überschrieben werden (nur _content = ...) ist gültig, die ganzen Array-Kopiermethoden funktionieren NICHT!
      _pageContent = copyOfContent;
    });
    return true;
  }

  /// Es ist zwar bisschen umständlicher wenn die beiden Funktionen static sind, aber Vorteile:
  /// 1. Fester Wert von selectedCard. So läuft man in keine Fehler wenn der Nutzer genau in der Ausführungszeit der Funktion eine andere Karte anklickt
  /// 2. Immer der aktuelle BuildContext: <br>
  ///    Da die static sind kennen die ja nichts mehr aus der Klasse, was nicht auch static ist.
  ///    Daher können die auch keinen veralteten BuildContext verwenden, sondern bekommen immer den aktuellen.
  ///    Damit verwendet man nie den falschen, was schrecklich herauszufinden und zu debuggen wäre :)))
  static NaturfkTextButton _buildCenterButton(BuildContext context, InventoryPlant? selectedCard) {
    if (selectedCard == null) return const NaturfkTextButton(text: "Einpflanzen", onTap: null, disabled: true);

    if (selectedCard.isPlanted) {
      return NaturfkTextButton(
        text: "${selectedCard.name} auspflanzen",
        onTap: null,
        disabled: true,
      );
    } else {
      return NaturfkTextButton(
        text: "${selectedCard.name} einpflanzen",
        onTap: () {
          debugPrint("einpflanzen tap");
          NaturfkNotifyChangeTabPage(
            newPageWidget: ExplorerTabGarden(plantIdForUnity: selectedCard.plantId),
          ).dispatch(context);
        },
      );
    }
  }

  /// Es ist zwar bisschen umständlicher wenn die beiden Funktionen static sind, aber Vorteile:
  /// 1. Fester Wert von selectedCard. So läuft man in keine Fehler wenn der Nutzer genau in der Ausführungszeit der Funktion eine andere Karte anklickt
  /// 2. Immer der aktuelle BuildContext: <br>
  ///    Da die static sind kennen die ja nichts mehr aus der Klasse, was nicht auch static ist.
  ///    Daher können die auch keinen veralteten BuildContext verwenden, sondern bekommen immer den aktuellen.
  ///    Damit verwendet man nie den falschen, was schrecklich herauszufinden und zu debuggen wäre :)))
  static NaturfkSquareIconBtn _buildShareButton(BuildContext context, InventoryPlant? selectedCard) {
    if (selectedCard == null) return const NaturfkSquareIconBtn(icon: Icons.share_sharp, onTap: null, disabled: true);

    if (selectedCard.isPlanted) {
      return const NaturfkSquareIconBtn(
        icon: Icons.share_sharp,
        onTap: null,
        disabled: true,
      );
    } else {
      return NaturfkSquareIconBtn(
        icon: Icons.share_sharp,
        onTap: () => NaturfkNotifyChangeTabPage(newPageWidget: ExplorerTabPlantShare(plantId: selectedCard.plantId)).dispatch(context),
        disabled: false,
      );
    }
  }
}

class NotifNewCardSelected extends Notification {
  final int plantId;
  final String cardName;
  NotifNewCardSelected(this.plantId, this.cardName);
}
