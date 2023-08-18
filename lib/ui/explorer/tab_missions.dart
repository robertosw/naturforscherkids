// Das ist keine "richtige" Seite sondern nur ein Teil der Hauptseite, welche die Tabbar enthält

import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/mission.dart';
import 'package:naturforscherkids/ui/explorer/tab_profile_find_group.dart';
import 'package:naturforscherkids/ui/widgets.dart';
// ignore: unused_import
import 'package:naturforscherkids/data/globals.dart';

class ExplorerTabMissions extends StatefulWidget {
  const ExplorerTabMissions({super.key});

  @override
  State<ExplorerTabMissions> createState() => _ExplorerTabMissionsState();
}

class _ExplorerTabMissionsState extends State<ExplorerTabMissions> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: Column(
        children: [
          const NaturfkCategoryTitle(title: "Allgemeine Missionen", spaceBefore: false),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
              itemBuilder: (context, index) => NaturfkMissionCard(
                title: Missions().list[index].title,
                content: Missions().list[index].description,
                isCompleted: Missions().list[index].isComplited,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: Missions().list.length,
            ),
          )
        ],
      ),
      bottomRow: NaturfkBottomRow3(
        center: NaturfkTextButton(
          text: "Gruppen finden",
          onTap: () {
            //await Globals().loadGroups();
            NaturfkNotifyChangeTabPage(
              newPageWidget: const ExplorerTabFindGroup(),
              highlightedTab: ExplorerTabHighlights.profile,
            ).dispatch(context);
          },
        ),
        rightSquare: NaturfkSquareIconBtn(icon: Icons.add_a_photo_outlined, onTap: () => Navigator.of(context).pushNamed("/camera")),
      ),
    );
  }
}

class NaturfkMissionCard extends StatelessWidget {
  static const double _lineGap = 7.5;

  final String title;
  final String content;
  final bool isCompleted;
  const NaturfkMissionCard({super.key, required this.title, required this.content, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 13.5, horizontal: 20.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
                Icon(
                  (isCompleted) ? Icons.task_alt : Icons.timelapse_outlined,
                  // (isCompleted) ? Icons.done_all_sharp : Icons.update,
                  // (isCompleted) ? Icons.done : Icons.query_builder,
                  color: (isCompleted) ? Theme.of(context).primaryColor : Colors.amber.shade700,
                ),
              ],
            ),
            const SizedBox(height: _lineGap * 2),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
