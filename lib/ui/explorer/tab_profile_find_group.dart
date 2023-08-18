import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/group.dart';
import 'package:naturforscherkids/data/user_data.dart';
import 'package:naturforscherkids/ui/widgets.dart';
// ignore: unused_import
import 'package:naturforscherkids/data/globals.dart';

class ExplorerTabFindGroup extends StatefulWidget {
  const ExplorerTabFindGroup({super.key});

  @override
  State<ExplorerTabFindGroup> createState() => _ExplorerTabFindGroupState();
}

class _ExplorerTabFindGroupState extends State<ExplorerTabFindGroup> {
  final List<Group> _groupsFiltered = List.empty(growable: true);

  @override
  void initState() {
    // Alle Gruppen, welchen dieser Nutzer beigetreten ist, als Widgets hinzufügen
    for (Group group in GroupManager().serverGroups) {
      if (!UserData().groupIDs.contains(group.id)) {
        _groupsFiltered.add(group);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      headerText: "Gruppe finden",
      body: ListView.separated(
        itemBuilder: (context, index) {
          return NaturfkFindGroupCard(
            title: _groupsFiltered[index].name.toString(),
            content: "12 Mitglieder\n\nLetzte Aktivität\nvor 1 Woche",
            buttonText: "Beitritt anfragen",
            onBtnTap: () {},
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: _groupsFiltered.length,
        padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
      ),
      bottomRow: NaturfkBottomRow3(
        leftSquare: NaturfkSquareIconBtn(
          icon: Icons.arrow_back,
          onTap: () => NaturfkNotifyGoBackOneTabPage().dispatch(context),
        ),
        center: NaturfkSearchBar(hintText: "Gruppenname eingeben", onChanged: (text) {}),
      ),
    );
  }
}
