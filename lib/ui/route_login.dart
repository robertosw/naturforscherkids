import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/data/user_data.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  static const int _minInputLen = 5;
  int _currentStep = 1;
  String? _selectedRoleText;
  String _errorText = "";
  String _loginHintText = "";

  final List<StepState> _stepStates = [
    StepState.indexed,
    StepState.indexed,
    StepState.indexed,
  ];

  @override
  void initState() {
    if (Globals().userData.username != null && (Globals().userData.activeRole == Role.explorer || Globals().userData.activeRole == Role.instructor)) {
      // Alles was ohne fertiges UI geht
      _stepStates[0] = StepState.complete;
      _selectedRoleText = (Globals().userData.activeRole == Role.explorer) ? "Entdecker" : "Lehrkraft";

      // UI bauen lassen
      super.initState();

      // Funktionen, welche fertig gebautes UI brauchen:
      _onTapLogin();
    } else {
      super.initState();
    }
  }

  // ------------------------------------------------ UI Build ------------------------------------------------ //

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: WillPopScope(
        onWillPop: () async {
          //Fängt "Zurück" Button in Android ab
          return Future(() => false);
        },
        child: Scaffold(
          body: Center(
            child: Stepper(
              controlsBuilder: _controlsBuilder,
              currentStep: _currentStep - 1,
              onStepTapped: (int index) {}, // Leer lassen! Man soll nur mit den Buttons weiter oder zurück kommen
              steps: [_buildStep1(), _buildStep2(), _buildStep3()],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildControlsStep1() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          children: [
            Expanded(child: NaturfkTextButton(text: "Lehrkraft", onTap: _onTapRoleSelectionInstructor)),
            const SizedBox(width: 10),
            Expanded(child: NaturfkTextButton(text: "Entdecker", onTap: _onTapRoleSelectionExplorer)),
          ],
        ),
      );

  Padding _buildControlsStep2() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          children: [
            Expanded(child: NaturfkTextButton(text: "Zurück", onTap: _onTapBackToRoleSelection)),
            const SizedBox(width: 10),
            Expanded(child: NaturfkTextButton(text: "Anmelden", onTap: _onTapLogin)),
          ],
        ),
      );

  void _displayLoginError(String info) {
    setState(() {
      _currentStep = 2;
      _stepStates[1] = StepState.error;
      _errorText = info;
    });
  }

  Step _buildStep1() => Step(
        state: _stepStates[0],
        isActive: (_currentStep == 1) ? true : false,
        title: Text((_selectedRoleText != null) ? 'Rolle - $_selectedRoleText' : 'Rolle auswählen'),
        content: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Bitte wähle eine Rolle aus. Du kannst diese später nicht mehr wechseln"),
        ),
      );

  Step _buildStep2() => Step(
        state: _stepStates[1],
        isActive: (_currentStep == 2) ? true : false,
        title: const Text('Nutzernamen angeben'),
        subtitle: (_errorText.isEmpty) ? null : Text(_errorText),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("In dieser Version muss kein Nutzername angegeben werden, da die App vollständig offline funktioniert.\n\nZum Fortfahren einfach 'Anmelden' drücken."),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(border: UnderlineInputBorder(), hintText: "Kein Nutzername notwendig!"),
              onChanged: (text) => Globals().userData.username = text,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\w\d]'))],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );

  Step _buildStep3() => Step(
        state: _stepStates[2],
        isActive: (_currentStep == 3) ? true : false,
        title: const Text("Anmeldevorgang"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LinearProgressIndicator(value: null),
            const SizedBox.square(dimension: 10),
            Text(_loginHintText),
          ],
        ),
      );

  Widget _controlsBuilder(BuildContext context, ControlsDetails details) {
    // details.currentStep (nicht _currentStep) ist 0-basiert,
    // da die Schritte hier aber im UI zwangsweise nummeriert sind,
    // wird das hier auf 1-basiert umgerechnet
    switch (details.currentStep + 1) {
      case 1:
        return _buildControlsStep1();

      case 2:
        return _buildControlsStep2();

      default:
        return Container(); // Hat keine Controls
    }
  }

  // ------------------------------------------------ Logik ------------------------------------------------ //

  void _onTapBackToRoleSelection() {
    setState(() {
      _currentStep -= 1;
      _stepStates[0] = StepState.indexed;
    });
  }

  void _onTapLogin() async {
    // if (Globals().userData.username == null || Globals().userData.username!.length <= _minInputLen) {
    //   _displayLoginError("Nutzername ist zu kurz");
    //   return;
    // }

    // App-interne Bedingungen bestanden -> UI auf Step 3
    setState(() {
      _currentStep = 3;
      _stepStates[1] = StepState.complete;
      _errorText = "";
    });

    // Loginvorgang starten
    setState(() => _loginHintText = "Anmelden..");
    String errorDescription = await UserData().loginUserAndSavePersonalData();

    if (errorDescription.isEmpty) {
      // erfolgreich
      setState(() => _loginHintText = "Daten abrufen..");

      await Globals().getAllServerData();

      Future.sync(() => Navigator.pushNamed(context, Globals().getRouteForRole()));
    } else {
      _displayLoginError(errorDescription);
    }
  }

  void _onTapRoleSelectionExplorer() {
    Globals().userData.activeRole = Role.explorer;
    setState(() {
      _selectedRoleText = "Entdecker";
      _currentStep += 1; // Zum nächsten Step gehen
      _stepStates[0] = StepState.complete;
    });
  }

  void _onTapRoleSelectionInstructor() {
    Globals().userData.activeRole = Role.instructor;
    setState(() {
      _selectedRoleText = "Lehrkraft";
      _currentStep += 1; // Zum nächsten Step gehen
      _stepStates[0] = StepState.complete;
    });
  }
}
