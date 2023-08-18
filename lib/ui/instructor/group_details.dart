import 'package:flutter/material.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class InstructorTabGroupDetails extends StatelessWidget {
  const InstructorTabGroupDetails({super.key, required this.title, required this.cancelButton});

  final String title;
  final bool cancelButton;

  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      headerText: title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(decoration: InputDecoration(border: UnderlineInputBorder(), hintText: "Gruppenname")),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Mitglieder"),
              NaturfkSquareIconBtn(icon: Icons.add, onTap: () {}),
            ],
          ),
          //TODO: Wenn man aufs Plus sollten unter "Mitglieder" zwei Textboxen für Vor- und Nachnamen entstehen & zwei Buttons zum bestätigen und abbrechen
          // Die bereits hinzugefügten Mitglieder werden als Liste angezeigt und brauchen einen Button mit welchem man jedes Mitglied entfernen kann
          // Vielleicht macht man oben neben den + Button noch einen "Bearbeiten" Button. Erst wenn man den drückt kann entscheiden welche Mitglieder man entfernen will
          const SizedBox(height: 40),
          const Text("Missionen zuweisen"),
          const SizedBox(height: 10),
          const NaturfkCard(title: "Missionstitel 1", content: "Missionsbeschreibung"),
          const SizedBox(height: 10),
          const NaturfkCard(title: "Missionstitel 2", content: "Missionsbeschreibung"),
        ],
      ),
      bottomRow: cancelButton
          ? NaturfkBottomRow2(
              left: NaturfkTextButton(
                text: "Zurück",
                onTap: () => NaturfkNotifyGoBackOneTabPage().dispatch(context),
              ),
              right: NaturfkTextButton(
                text: "Speichern",
                onTap: () {
                  NaturfkNotifyGoBackOneTabPage().dispatch(context);
                },
              ),
            )
          : NaturfkBottomRow3(
              center: NaturfkTextButton(
                text: "Speichern",
                onTap: () {
                  NaturfkNotifyGoBackOneTabPage().dispatch(context);
                },
              ),
            ),
    );
  }
}
