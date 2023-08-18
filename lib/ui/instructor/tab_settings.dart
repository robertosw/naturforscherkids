import 'package:flutter/material.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class InstructorTabSettings extends StatefulWidget {
  const InstructorTabSettings({super.key});

  @override
  State<InstructorTabSettings> createState() => _InstructorTabSettingsState();
}

class _InstructorTabSettingsState extends State<InstructorTabSettings> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: ListView(children: [
        Row(children: const [Expanded(child: PersonalDataCard())]),
        const SizedBox(height: 20),
        NaturfkTextButton(
          text: "Alle Daten löschen & App zurücksetzen",
          onTap: () {
            Globals().userData.clearAll();
            Navigator.pushNamed(context, Globals().getRouteForRole());
          },
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class PersonalDataCard extends StatelessWidget {
  const PersonalDataCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Persönliche Daten", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Nutzername:", style: Theme.of(context).textTheme.bodyMedium),
            ]),
            const SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Globals().userData.username.toString(), style: Theme.of(context).textTheme.bodyMedium),
            ]),
          ]),
        ]),
      ),
    );
  }
}
