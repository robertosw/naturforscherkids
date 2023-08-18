import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:naturforscherkids/data/globals.dart';

enum ExplorerTabHighlights { garden, missions, lexicon, profile }

class NaturfkBottomRow2 extends StatelessWidget {
  final Widget left;

  final Widget right;
  const NaturfkBottomRow2({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(children: [
        Expanded(child: left),
        const SizedBox(width: 15),
        Expanded(child: right),
      ]),
    );
  }
}

class NaturfkBottomRow3 extends StatelessWidget {
  final NaturfkSquareIconBtn? leftSquare;

  final Widget center;
  final NaturfkSquareIconBtn? rightSquare;
  const NaturfkBottomRow3({
    super.key,
    this.leftSquare,
    required this.center,
    this.rightSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(children: [
        if (leftSquare != null) leftSquare!,
        if (leftSquare != null) const SizedBox(width: 15),
        Expanded(child: center),
        if (rightSquare != null) const SizedBox(width: 15),
        if (rightSquare != null) rightSquare!,
      ]),
    );
  }
}

class NaturfkCard extends StatelessWidget {
  static const double _lineGap = 7.5;

  final String title;
  final String content;
  const NaturfkCard({super.key, required this.title, required this.content});

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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: _lineGap * 2),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class NaturfkCategoryTitle extends StatelessWidget {
  final String title;

  final bool spaceBefore;
  const NaturfkCategoryTitle({super.key, required this.title, required this.spaceBefore});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spaceBefore ? const SizedBox(height: 40) : const SizedBox(height: 0),
        Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 20),
      ],
    );
  }
}

class NaturfkFindGroupCard extends StatelessWidget {
  static const double _lineGap = 7.5;

  // TODO Um den Button in der Card zu umgehen, vielleicht einfach die ganze Card als Button machen?
  // Dann steht an einer Stelle der Button Text in Orange, aber wenn man drauf klickt, wird die ganze Card gehighlited
  // Man kann im child von einem TextButton ja alles machen

  final String title;
  final String content;
  final String buttonText;
  final void Function()? onBtnTap;
  const NaturfkFindGroupCard({super.key, required this.title, required this.content, required this.buttonText, required this.onBtnTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 13.5, horizontal: 20.25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: _lineGap * 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text(content, style: Theme.of(context).textTheme.bodyMedium)),
                      OutlinedButton(onPressed: onBtnTap, child: Text(buttonText)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NaturfkNotifyChangeTabPage extends Notification {
  final Widget newPageWidget;

  /// Falls der für den Nutzer aktive Tab verändert werden soll, kann das hiermit getan werden. <br>
  /// Wenn kein Wert angegeben wird, wird der Tab nicht verändert
  final ExplorerTabHighlights? highlightedTab;
  NaturfkNotifyChangeTabPage({required this.newPageWidget, this.highlightedTab});
}

class NaturfkNotifyGoBackOneTabPage extends Notification {}

/// Die Standard-Seite: <br>
/// Unten gibt es eine NaturforscherBottomRow, darüber den body
/// <br> <br>
/// Padding etc. wurde bereits angewendet
class NaturfkPage extends StatelessWidget {
  final String? headerText;

  final Widget body;

  /// Verwendet können hier: <br>
  /// - NaturforscherBottomRow2 mit
  ///   - zwei gleich breite NaturforscherFixedHeightTextBtn
  /// - NaturforscherBottomRow3 mit
  ///   - optional links ein NaturforscherSquareIconBtn
  ///   - optional rechts ein NaturforscherSquareIconBtn
  ///   - mittig ein NaturforscherFixedHeightTextBtn
  final Widget? bottomRow;

  const NaturfkPage({
    super.key,
    this.headerText,
    required this.body,
    this.bottomRow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
      child: Column(children: [
        if (headerText != null) NaturfkCategoryTitle(title: headerText!, spaceBefore: false),
        Expanded(child: body),
        if (bottomRow != null) bottomRow!,
      ]),
    );
  }
}

/// Diese Seite hat kein header und zeigt den body ohne Padding an. <br>
/// Wenn eine bottomRow verwendet wird, hat diese allerdings Padding
class NaturfkPageSlim extends StatelessWidget {
  final Widget body;

  /// Verwendet können hier: <br>
  /// - NaturforscherBottomRow2 mit
  ///   - zwei gleich breite NaturforscherFixedHeightTextBtn
  /// - NaturforscherBottomRow3 mit
  ///   - optional links ein NaturforscherSquareIconBtn
  ///   - optional rechts ein NaturforscherSquareIconBtn
  ///   - mittig ein NaturforscherFixedHeightTextBtn
  final Widget? bottomRow;

  /// Wenn nicht angegeben, wird Standardwert verwendet
  final EdgeInsetsGeometry? pagePadding;

  const NaturfkPageSlim({
    super.key,
    this.pagePadding,
    required this.body,
    this.bottomRow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 0, child: body),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: bottomRow,
        )
      ],
    );
  }
}

class NaturfkSearchBar extends StatelessWidget {
  final String hintText;

  final void Function(String) onChanged;
  const NaturfkSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(12, 2, 0, 0),
        child: TextField(
          decoration: InputDecoration(
            icon: const Icon(Icons.search),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class NaturfkSquareIconBtn extends StatelessWidget {
  final void Function()? onTap;

  final IconData icon;
  final bool? isBusy;
  final bool? disabled;
  const NaturfkSquareIconBtn({super.key, required this.icon, required this.onTap, this.isBusy, this.disabled});

  @override
  Widget build(BuildContext context) {
    if (disabled == null || disabled == false) {
      return SizedBox(
        height: 50,
        width: 50,
        child: TextButton(
          onPressed: onTap,
          child: () {
            return (isBusy == true)
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: CircularProgressIndicator(value: null, strokeWidth: 2.75),
                  )
                : Icon(icon);
          }(),
        ),
      );
    } else {
      return SizedBox(
        height: 50,
        width: 50,
        child: TextButton(
          onPressed: null,
          child: () {
            return (isBusy == true)
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: CircularProgressIndicator(value: null, strokeWidth: 2.75),
                  )
                : Icon(icon, color: Colors.grey);
          }(),
        ),
      );
    }
  }
}

class NaturfkTextButton extends StatelessWidget {
  final String text;
  final bool? disabled;
  final Color? textColor;

  final void Function()? onTap;
  const NaturfkTextButton({super.key, required this.text, required this.onTap, this.disabled, this.textColor});

  @override
  Widget build(BuildContext context) {
    if (disabled == null || disabled == false) {
      return TextButton(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 0, horizontal: 10),
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: (textColor == null) ? Theme.of(context).primaryColor : textColor),
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: null,
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 0, horizontal: 10),
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }
}
