import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/inventory.dart';
import 'package:naturforscherkids/ui/explorer/inventory/tab_inventory.dart';

/// Beim erstellen einer **Gartenpflanze** muss das *Wasserlevel* angegeben werden!
class UIAdaptiveCard extends StatelessWidget {
  final int plantId;
  final bool selected;
  final int amount;
  final String plantName;
  final bool isPlanted;
  final int waterlevel;

  const UIAdaptiveCard({
    super.key,
    required this.plantId,
    required this.selected,
    required this.plantName,
    required this.amount,
    required this.isPlanted,
    required this.waterlevel,
  });

  @override
  Widget build(BuildContext context) {
    if (isPlanted) {
      return UIGardenCard(amount: amount, plantId: plantId, selected: selected, plantName: plantName, waterlevel: waterlevel);
    } else {
      return UIInventoryCard(amount: amount, plantId: plantId, selected: selected, plantName: plantName);
    }
  }
}

class UIChipPlantAmount extends StatelessWidget {
  final int amount;

  const UIChipPlantAmount({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.green.shade600.withOpacity(0.8),
        border: Border.all(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$amount", style: const TextStyle(color: Colors.white)),
          const SizedBox.square(dimension: 1.2),
          const Text("x", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class UIChipPlantWater extends StatelessWidget {
  final int waterCount;

  const UIChipPlantWater({super.key, required this.waterCount});

  @override
  Widget build(BuildContext context) {
    Widget singleDrop = Container(
      height: 22,
      width: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue.shade600.withOpacity(0.8),
        border: Border.all(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(
        Icons.water_drop_outlined,
        color: Colors.white,
        size: 15,
      ),
    );

    List<Widget> waterDrops = List.empty(growable: true);

    for (int i = 0; i < waterCount; i++) {
      waterDrops.add(singleDrop);
      waterDrops.add(const SizedBox.square(dimension: 2));
    }

    return Row(children: waterDrops);
  }
}

class UIGardenCard extends StatelessWidget {
  final int plantId;
  final bool selected;
  final int amount;
  final String plantName;
  final int waterlevel;

  const UIGardenCard({
    super.key,
    required this.plantId,
    required this.selected,
    required this.plantName,
    required this.amount,
    required this.waterlevel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NotifNewCardSelected(plantId, plantName).dispatch(context),
      child: Card(
        shape: (selected)
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.green.shade600.withOpacity(0.9), width: 2),
                borderRadius: BorderRadius.circular(12),
              )
            : Theme.of(context).cardTheme.shape,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 50,
                child: Icon(Icons.local_florist_outlined, color: Colors.grey.shade900),
              ),

              // Eigentlich war hier ein Bild der Pflanze aus Unity, statt dem Icon, zu sehen:
              // Container(
              //   height: 50,
              //   width: 50,
              //   padding: const EdgeInsets.all(6),
              //   child: getColorCodedPlantImage(),
              // ),
              const SizedBox.square(dimension: 5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plantName),
                    const SizedBox.square(dimension: 5),
                    Row(
                      children: [
                        UIChipPlantAmount(amount: amount),
                        const SizedBox.square(dimension: 5),
                        UIChipPlantWater(waterCount: waterlevel),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image getColorCodedPlantImage() {
    int indexOfTargetedPlant = Inventory().gardenLayout.indexWhere((element) => element.containsValue(plantName));
    Map<String, dynamic> targetPlant = Inventory().gardenLayout.elementAt(indexOfTargetedPlant);
    String? colorOfTargetedPlant;

    targetPlant.forEach((key, value) {
      if (key == "Farbe") {
        colorOfTargetedPlant = value;
      }
    });

    if (colorOfTargetedPlant != null) {
      debugPrint("colorOfTargetedPlant: $colorOfTargetedPlant");
      return Image.asset("assets/plant_icons/$colorOfTargetedPlant.png");
    } else {
      return Image.asset("assets/plant_icons/unknown.png");
    }
  }
}

class UIInventoryCard extends StatelessWidget {
  final int plantId;
  final bool selected;
  final int amount;
  final String plantName;

  const UIInventoryCard({super.key, required this.plantId, required this.selected, required this.plantName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NotifNewCardSelected(plantId, plantName).dispatch(context),
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
                child: Icon(Icons.local_florist_outlined, color: Colors.grey.shade900),
              ),
              const SizedBox.square(dimension: 5),
              Expanded(child: Text(plantName)),
              UIChipPlantAmount(amount: amount),
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
