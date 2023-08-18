import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class InstructorTabRequests extends StatefulWidget {
  const InstructorTabRequests({super.key});

  @override
  State<InstructorTabRequests> createState() => InstructorTabRequestsState();
}

class InstructorTabRequestsState extends State<InstructorTabRequests> {
  @override
  Widget build(BuildContext context) {
    return NaturfkPage(
      body: ListView(
        children: const [
          NaturfkCategoryTitle(title: "Grundschule am Forst 4a", spaceBefore: false),
          NaturfkRequestCard(prename: "Anna", surname: "Müller"),
          NaturfkRequestCard(prename: "Max", surname: "Fischer"),
          NaturfkRequestCard(prename: "Lena", surname: "Wagner"),
          NaturfkRequestCard(prename: "Jonas", surname: "Schmitt"),
          NaturfkRequestCard(prename: "Sarah", surname: "Meier"),
          NaturfkCategoryTitle(title: "Lessing-Gymnasium Kamenz 6b", spaceBefore: true),
          NaturfkRequestCard(prename: "Felix", surname: "Berger"),
          NaturfkRequestCard(prename: "Laura", surname: "Schäfer"),
          NaturfkRequestCard(prename: "David", surname: "Becker"),
          NaturfkRequestCard(prename: "Emily", surname: "Schmidt"),
        ],
      ),
    );
  }
}

class NaturfkRequestCard extends StatelessWidget {
  final String prename;

  final String surname;
  const NaturfkRequestCard({super.key, required this.prename, required this.surname});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 0, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("$prename $surname", style: Theme.of(context).textTheme.titleLarge),
            Expanded(child: Container()),
            TextButton(child: const Icon(Icons.check), onPressed: () {}),
            const SizedBox(width: 5),
            TextButton(child: Icon(Icons.clear, color: Colors.red.shade700), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
