## Vorhandene Routen

`Abkürzung | Routename | Erklärung`

- **I** | `/explorer_home`           | Startseite
- **C** | `/camera`                  | Bild aufnehmen
- **P** | `/camera_picture`  | Aufgenommenes Bild anzeigen und entscheiden ob dieses verworfen wird oder ob die KI das auswerten soll
- **R** | `/plant_result`            | KI Auswertung dem Nutzer anzeigen


## Mögliche Wege
1.  I > C > P > R > I                | Der erwartete Weg. Man öffnet die Kamera, macht ein Bild, schickt das an die KI und die KI erkennt eine Pflanze
2.  I > C > P > C                    | Das gemachte Bild wird verworfen
3.  I > C > P > R > C                | KI hat im Bild keine Pflanze erkannt

Bei 1. kann man im Result-Screen nicht "Zurück" drücken, oder es führt genauso wie der OK Button zur Startseite
    1.1 `Im Gartentab ankommen`: Aufm Stack geht man also wirklich I > C > P > R > I, da in I die Zurücktaste abgefangen wird und die App geschlossen wird. 
        Dann startet man die route_home im ersten Tab, also dem Garten
        Hierbei bin ich mir nicht sicher ob das immer funktioniert, hängt wahrscheinlich vom RAM des Handys ab, wieviel Infos über die alten Stack Seiten aktiv bleiben
    1.2 `Bei vorher geöffnetem Tab ankommen`: Aufm Stack geht man I > C > P > R und löscht dann CPR
                                                                  I <<<<<<<<<<<

Bei 2. sollte "Zurück" von P zu C führen. Dabei muss P vom Stack genommen werden
    Aufm Stack geht man also I > C > P und löscht dann P
                                 C <<<

Bei 3. müssen P und R vom Stack genommen werden, "Zurück" müsste zur Kamera gehen
    Aufm Stack geht man also I > C > P > R und löscht dann R und P
                                 C <<<<<<<


**Generell**: Solange man nicht zum Inventar / Startseite geht, löscht man einfach die aktuelle Seite wieder vom Stack.
