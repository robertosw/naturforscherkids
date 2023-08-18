import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/lexicon.dart';
import 'package:naturforscherkids/ui/explorer/tab_lexicon_plant_details.dart';
// ignore: unused_import
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ExplorerTabLexicon extends StatefulWidget {
  const ExplorerTabLexicon({super.key});

  @override
  State<ExplorerTabLexicon> createState() => ExplorerTabLexiconState();
}

class ExplorerTabLexiconState extends State<ExplorerTabLexicon> {
  List<LexiconPlant> _filteredList = Lexicon().allPlants;
  int _itemCount = Lexicon().allPlants.length;

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).size.height

    return NaturfkPage(
      headerText: "Lexikon",
      body: ListView.separated(
        itemBuilder: (context, i) {
          String name = _filteredList[i].name.toString();
          String taxon = _filteredList[i].taxonName.toString();
          String color = _filteredList[i].farbe.toString();
          String environment = _filteredList[i].umgebung.toString();
          String bloom = _filteredList[i].bluete.toString();
          String smell = _filteredList[i].geruch.toString();

          return NaturfkLexiconCard(
            name: name,
            taxon: taxon,
            color: color,
            environment: environment,
            bloom: bloom,
            smell: smell,
            onTap: () => NaturfkNotifyChangeTabPage(
              newPageWidget: ExplorerPagePlantDetails(name: name, taxon: taxon, color: color, environment: environment, bloom: bloom, smell: smell),
            ).dispatch(context),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: _itemCount,
        padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
        controller: ScrollController(
          // TODO Wenn man von einer Detailseite einer Pflanze zurückkommt, müsste man wieder an der gleichen Scrollposi sein, wie vorher
          // Dafür muss man sicherlich ein ScrollController nutzen
          initialScrollOffset: 0,
          keepScrollOffset: true,
        ),
      ),
      bottomRow: NaturfkBottomRow3(
        center: NaturfkSearchBar(
          hintText: "Nach Pflanze suchen",
          onChanged: (searchText) {
            if (searchText.isEmpty) {
              setState(() => _filteredList = Lexicon().allPlants);
              return;
            }

            final List<LexiconPlant> plantsToShow = Lexicon().allPlants.where((plant) {
              if (plant.name != null) {
                final bool doesPlantSatisfySearch = plant.name!.toLowerCase().contains(searchText.toLowerCase());
                return doesPlantSatisfySearch;
              }
              return false;
            }).toList();

            setState(() {
              _filteredList = plantsToShow;
              _itemCount = _filteredList.length;
            });
          },
        ),
        rightSquare: NaturfkSquareIconBtn(icon: Icons.add_a_photo_outlined, onTap: () => Navigator.of(context).pushNamed("/camera")),
      ),
    );
  }
}

class NaturfkLexiconCard extends StatelessWidget {
  final String name;

  final String taxon;
  final String color;
  final String environment;
  final String bloom;
  final String smell;
  final void Function() onTap;
  const NaturfkLexiconCard({
    super.key,
    required this.name,
    required this.taxon,
    required this.color,
    required this.environment,
    required this.bloom,
    required this.smell,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 13.5, horizontal: 20.25),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("lat. Name:", style: Theme.of(context).textTheme.bodyMedium),
                  Text("Farbe:", style: Theme.of(context).textTheme.bodyMedium),
                  Text("Umgebung:", style: Theme.of(context).textTheme.bodyMedium),
                  Text("Blüte:", style: Theme.of(context).textTheme.bodyMedium),
                  Text("Geruch:", style: Theme.of(context).textTheme.bodyMedium),
                ]),
                const SizedBox(width: 20),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(taxon, style: Theme.of(context).textTheme.bodyMedium),
                  Text(color, style: Theme.of(context).textTheme.bodyMedium),
                  Text(environment, style: Theme.of(context).textTheme.bodyMedium),
                  Text(bloom, style: Theme.of(context).textTheme.bodyMedium),
                  Text(smell, style: Theme.of(context).textTheme.bodyMedium),
                ]),
              ]),
            ]),
          ),
          Icon(Icons.keyboard_arrow_right_sharp, color: Theme.of(context).primaryColor),
        ]),
      ),
    );
  }
}
