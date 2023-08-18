import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class ExplorerPagePlantDetails extends StatefulWidget {
  final String name;

  final String taxon;
  final String color;
  final String environment;
  final String bloom;
  final String smell;
  const ExplorerPagePlantDetails({
    super.key,
    required this.name,
    required this.taxon,
    required this.color,
    required this.environment,
    required this.bloom,
    required this.smell,
  });

  @override
  State<ExplorerPagePlantDetails> createState() => ExplorerPagePlantDetailsState();
}

class ExplorerPagePlantDetailsState extends State<ExplorerPagePlantDetails> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      headerText: widget.name,
      body: ListView(
        children: [
          NaturfkPlantDetailsCard(
            title: "Informationen",
            taxon: widget.taxon,
            color: widget.color,
            environment: widget.environment,
            bloom: widget.bloom,
            smell: widget.smell,
          ),
          const SizedBox(height: 20),
          const NaturfkCard(title: "Verlauf", content: "Hier Liste mit Funden (Datum und Uhrzeit)"),
        ],
      ),
      bottomRow: NaturfkBottomRow3(
        center: NaturfkTextButton(text: "Zurück", onTap: () => NaturfkNotifyGoBackOneTabPage().dispatch(context)),
      ),
    );
  }
}

class NaturfkPlantDetailsCard extends StatelessWidget {
  final String title;

  final String taxon;
  final String color;
  final String environment;
  final String bloom;
  final String smell;
  const NaturfkPlantDetailsCard({
    super.key,
    required this.title,
    required this.taxon,
    required this.color,
    required this.environment,
    required this.bloom,
    required this.smell,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 13.5, horizontal: 20.25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
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
    );
  }
}
