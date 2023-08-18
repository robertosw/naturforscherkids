import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/data/group.dart';
import 'package:naturforscherkids/ui/explorer/tab_profile_find_group.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ExplorerTabProfile extends StatefulWidget {
  const ExplorerTabProfile({super.key});

  @override
  State<ExplorerTabProfile> createState() => ExplorerTabProfileState();
}

class ExplorerTabProfileState extends State<ExplorerTabProfile> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(body: ListView(children: _getContentArray(context)));
  }

  List<Widget> _getContentArray(BuildContext context) {
    List<Widget> groupCardsForUserGroups = List.empty(growable: true);

    // Alle Gruppen, welchen dieser Nutzer beigetreten ist, als Widgets hinzufügen

    for (Group group in GroupManager().joinedGroups) {
      groupCardsForUserGroups.add(
        NaturfkFindGroupCard(
          title: group.name,
          content: "12 Mitglieder \nLetzte Aktivität \nvor 1 Woche",
          buttonText: "Gruppe verlassen",
          onBtnTap: null,
        ),
      );
    }

    // UI Content
    List<Widget> content = [
      // -------------- Persönliche Daten -------------- //
      const NaturfkCategoryTitle(title: "Persönliche Daten", spaceBefore: false),
      Row(children: const [Expanded(child: PersonalDataCard())]),
      const SizedBox(height: 20),
      NaturfkTextButton(
        text: "Alle Daten löschen",
        onTap: () {
          Globals().userData.clearAll();
          Navigator.pushNamed(context, Globals().getRouteForRole());
        },
      ),
      const SizedBox(height: 60),

      // -------------- Beigetretene Gruppen anzeigen -------------- //
      const NaturfkCategoryTitle(title: "Deine Gruppen", spaceBefore: false),

      // hier sollte groupCardsForUserGroups eingefügt werden

      const SizedBox(height: 20),
      NaturfkTextButton(
        text: "Gruppe finden",
        onTap: () {
          NaturfkNotifyChangeTabPage(
            newPageWidget: const ExplorerTabFindGroup(),
            highlightedTab: ExplorerTabHighlights.profile,
          ).dispatch(context);
        },
      ),
      const SizedBox(height: 60),
    ];

    // Mitgliedergruppenwidgets hinzufügen
    int indexOfGroupTitle = content.indexWhere((element) {
      if (element is NaturfkCategoryTitle) {
        if (element.title == "Deine Gruppen") {
          return true;
        }
      }
      return false;
    });

    content.insertAll(indexOfGroupTitle + 1, groupCardsForUserGroups);
    return content;
  }
}

class PersonalDataCard extends StatelessWidget {
  const PersonalDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Rolle:", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox.square(dimension: 5),
            Text("Username:", style: Theme.of(context).textTheme.bodyMedium),
          ]),
          const SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Entdecker", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox.square(dimension: 5),
            Text(Globals().userData.username.toString(), style: Theme.of(context).textTheme.bodyMedium),
          ]),
        ]),
      ),
    );
  }
}
