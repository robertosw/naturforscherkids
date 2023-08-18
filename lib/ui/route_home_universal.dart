import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naturforscherkids/ui/explorer/tab_garden.dart';
import 'package:naturforscherkids/ui/explorer/tab_lexicon.dart';
import 'package:naturforscherkids/ui/explorer/tab_missions.dart';
import 'package:naturforscherkids/ui/explorer/tab_profile.dart';
import 'package:naturforscherkids/data/globals.dart';
import 'package:naturforscherkids/ui/instructor/tab_groups.dart';
import 'package:naturforscherkids/ui/instructor/tab_requests.dart';
import 'package:naturforscherkids/ui/instructor/tab_settings.dart';
import 'package:naturforscherkids/ui/widgets.dart';

class UniversalPageHome extends StatefulWidget {
  const UniversalPageHome({super.key, required this.role});
  final Role role;

  @override
  State<UniversalPageHome> createState() => _UniversalPageHomeState();
}

class _UniversalPageHomeState extends State<UniversalPageHome> {
  int _visibleTabHighlightIndex = 0;
  late Widget _visiblePageWidget;
  late List<BottomNavigationBarItem> _visibleNavBarItems;

  final List<Widget> _pageHistoryStack = List.empty(growable: true);
  final List<int> _tabHighlightStack = List.empty(growable: true);

  // ---------------- Explorer ---------------- //

  final List<Widget> _defaultExplorerPageWidgets = [
    // Wenn man hier etwas ändert, dann auch im enum ExplorerTabHighlights in widgets.dart
    const ExplorerTabGarden(),
    const ExplorerTabMissions(),
    const ExplorerTabLexicon(),
    const ExplorerTabProfile(),
  ];

  static const List<BottomNavigationBarItem> _defaultExplorerNavBarItems = [
    // Wenn man hier etwas ändert, dann auch im enum ExplorerTabHighlights in widgets.dart
    BottomNavigationBarItem(icon: Icon(Icons.local_florist_outlined), label: 'Garten'),
    BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted_sharp), label: 'Missionen'),
    BottomNavigationBarItem(icon: Icon(Icons.my_library_books_outlined), label: 'Lexikon'),
    BottomNavigationBarItem(icon: Icon(Icons.person_sharp), label: 'Profil'),
  ];

  // ---------------- Instructor ---------------- //

  final List<Widget> _defaultInstructorPageWidgets = [
    const InstructorTabRequests(),
    const InstructorTabGroups(),
    const InstructorTabSettings(),
  ];

  static const List<BottomNavigationBarItem> _defaultInstructorNavBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Anfragen'),
    BottomNavigationBarItem(icon: Icon(Icons.group_sharp), label: 'Gruppen'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Einstellungen'),
  ];

  @override
  void initState() {
    _navigationInitStacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: WillPopScope(
        onWillPop: () async {
          // Wenn möglich zurück navigieren, sonst App schließen
          if (_pageHistoryStack.length > 1) {
            _navigationGoBack();
          } else {
            SystemNavigator.pop();
          }

          // TODO: Der unten stehende Code funktioniert noch nicht so wirklich.
          // Wenn man ins Inventar geht, dann mit ein "Einpflanzen" Button wieder zum Garten navigiert wird,
          // dann kann man mit dem Zurück Button wieder ins Inventar kommen.
          // Das sollte nicht so sein, sondern die App sollte sich schließen wenn man auf einer der Hauptseiten der Tabs ist

          // Ist man auf einer der direkten Tabseiten?
          // Dann App schließen
          // if (widget.role == Role.explorer && _defaultExplorerPageWidgets.contains(_visiblePageWidget)) {
          //   SystemNavigator.pop();
          // }

          // if (widget.role == Role.instructor && _defaultInstructorPageWidgets.contains(_visiblePageWidget)) {
          //   SystemNavigator.pop();
          // }

          //Fängt "Zurück" Button in Android ab
          return Future(() => false);
        },
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is NaturfkNotifyChangeTabPage) {
              _navigationSetPage(widget: notification.newPageWidget, highlightedTab: notification.highlightedTab);
              return true;
            }

            if (notification is NaturfkNotifyGoBackOneTabPage) {
              _navigationGoBack();
              return true;
            }

            return false;
          },
          child: Scaffold(
            body: _visiblePageWidget,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              items: _visibleNavBarItems,
              currentIndex: _visibleTabHighlightIndex,
              iconSize: 28,
              elevation: 16,
              onTap: (int indexOfClickedTab) => _navigationSetPageFromDefault(indexOfPageInDefault: indexOfClickedTab),
            ),
          ),
        ),
      ),
    );
  }

  void _navigationGoBack() {
    _pageHistoryStack.removeAt(0); // Aktuelle Seite entfernen, vorherige wird dann Index 0
    setState(() => _visiblePageWidget = _pageHistoryStack[0]);

    _tabHighlightStack.removeAt(0);
    setState(() => _visibleTabHighlightIndex = _tabHighlightStack[0]);
  }

  void _navigationInitStacks() {
    int startingPageIndex = 0;

    if (widget.role == Role.explorer) {
      _visiblePageWidget = _defaultExplorerPageWidgets[startingPageIndex];
      _visibleNavBarItems = _defaultExplorerNavBarItems;
    } else {
      _visiblePageWidget = _defaultInstructorPageWidgets[startingPageIndex];
      _visibleNavBarItems = _defaultInstructorNavBarItems;
    }
    _pageHistoryStack.insert(0, _visiblePageWidget);
    _tabHighlightStack.insert(0, startingPageIndex);
  }

  void _navigationSetPage({required Widget widget, ExplorerTabHighlights? highlightedTab, int? highlightIndex}) {
    _pageHistoryStack.insert(0, widget);

    if (highlightIndex == null) {
      // Man zeigt eine Seite an, welche nicht in _defaultPageWidgets liegt
      int highlightIndex = _highlightEnumToIndex(highlightedTab) ?? _visibleTabHighlightIndex;
      _tabHighlightStack.insert(0, highlightIndex);
    } else {
      // Man zeigt eine Seite aus den _defaultPageWidgets an
      _tabHighlightStack.insert(0, highlightIndex);
    }

    setState(() {
      _visiblePageWidget = _pageHistoryStack[0];
      _visibleTabHighlightIndex = _tabHighlightStack[0];
    });
  }

  void _navigationSetPageFromDefault({required int indexOfPageInDefault}) {
    _pageHistoryStack.clear();
    _tabHighlightStack.clear();
    if (widget.role == Role.explorer) {
      _navigationSetPage(widget: _defaultExplorerPageWidgets[indexOfPageInDefault], highlightIndex: indexOfPageInDefault);
    } else {
      _navigationSetPage(widget: _defaultInstructorPageWidgets[indexOfPageInDefault], highlightIndex: indexOfPageInDefault);
    }
  }

  int? _highlightEnumToIndex(ExplorerTabHighlights? highlightedTab) {
    // Wenn sich das Highlight ändert, dann ändern, ansonsten aktuelles weiter nutzen
    switch (highlightedTab) {
      case ExplorerTabHighlights.garden:
        return 0;
      case ExplorerTabHighlights.missions:
        return 1;
      case ExplorerTabHighlights.lexicon:
        return 2;
      case ExplorerTabHighlights.profile:
        return 3;
      case null:
        return null;
    }
  }
}
