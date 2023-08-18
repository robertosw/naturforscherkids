import 'package:flutter/material.dart';
import 'package:naturforscherkids/ui/instructor/group_details.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class InstructorTabGroups extends StatefulWidget {
  const InstructorTabGroups({super.key});

  @override
  State<InstructorTabGroups> createState() => InstructorTabGroupsState();
}

class InstructorTabGroupsState extends State<InstructorTabGroups> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      headerText: "Deine Gruppen",
      body: ListView(
        children: const [
          NaturfkInstructorGroupCard(
            groupName: "Grundschule am Forst 4a",
            content: "12 Mitglieder\nLetzte Aktivität vor 1 Woche",
          ),
        ],
      ),
      bottomRow: NaturfkBottomRow3(
        center: NaturfkTextButton(
          text: "Neue Gruppe",
          onTap: () {
            NaturfkNotifyChangeTabPage(newPageWidget: const InstructorTabGroupDetails(title: "Neue Gruppe", cancelButton: true)).dispatch(context);
          },
        ),
      ),
    );
  }
}

class NaturfkInstructorGroupCard extends StatelessWidget {
  static const double _lineGap = 7.5;

  //TODO Card klickbar machen
  // muss klickbar sein und auf eine Detailseite der Gruppe führen

  final String groupName;
  final String content;

  /// Welcher Tab wird hervorgehoben, wenn man auf die Karte klickt?
  final ExplorerTabHighlights? highlightedTab;
  const NaturfkInstructorGroupCard({
    super.key,
    required this.content,
    required this.groupName,
    this.highlightedTab,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 13.5, horizontal: 20.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(groupName, style: Theme.of(context).textTheme.titleLarge),
                const Icon(Icons.open_in_new),
                // TODO: Das Icon zu richtigem Button machen
              ],
            ),
            const SizedBox(height: _lineGap * 2),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
      onPressed: () {
        NaturfkNotifyChangeTabPage(
          newPageWidget: InstructorTabGroupDetails(title: groupName, cancelButton: false),
          highlightedTab: highlightedTab,
        ).dispatch(context);
      },
    );
  }
}
