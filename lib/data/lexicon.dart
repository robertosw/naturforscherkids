import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class Lexicon {
  // Singleton
  static final Lexicon _instance = Lexicon._constructor();
  List<LexiconPlant> allPlants = List.empty(growable: true);

  factory Lexicon() {
    return _instance;
  }
  Lexicon._constructor();

  Future<void> serverRequestLexiconAnonymous() async {
    // Response response = await Dio().get(
    //   "https://tracktrain.azurewebsites.net/Naturforscher/api.php",
    //   queryParameters: {'command': "get_plants"},
    // );

    Response response = Response(requestOptions: RequestOptions());
    response.data = {
      "inventory": [
        {
          "pflanzen_id": "1",
          "name": "Löwenzahn",
          "taxon": "Taraxacum officinale",
          "blüte": "April bis September",
          "farbe": "gelb",
          "geruch": "leicht",
          "umgebung": "Felder, Wiesen",
          "bestäubung": "Wind",
          "familie": "Korbblütler",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "2",
          "name": "Echte Kamille",
          "taxon": "Matricaria chamomilla",
          "blüte": "Juni bis August",
          "farbe": "weiß",
          "geruch": "stark",
          "umgebung": "Felder",
          "bestäubung": "Insekten",
          "familie": "Korbblütler",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "3",
          "name": "Gänseblümchen",
          "taxon": "Bellis perennis",
          "blüte": "März bis Oktober",
          "farbe": "weiß mit gelber Mitte",
          "geruch": "mild",
          "umgebung": "Wiesen,Gärten",
          "bestäubung": "Insekten",
          "familie": "Korbblütler",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "4",
          "name": "Klatsch-Mohn",
          "taxon": "Papaver rhoeas",
          "blüte": "Juni bis August",
          "farbe": "rot",
          "geruch": "angenehm",
          "umgebung": "Äcker, Brachland",
          "bestäubung": "Insekten",
          "familie": "Mohngewächse",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "5",
          "name": "Magerwiesen-Margerite",
          "taxon": "Leucanthemum vulgare",
          "blüte": "Mai bis August",
          "farbe": "weiß",
          "geruch": "angenehm",
          "umgebung": "Magerwiesen, Kiesgruben",
          "bestäubung": "Insekten",
          "familie": "Korbblütler",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "6",
          "name": "Wiesen-Schaumkraut",
          "taxon": "Cardamine dentata",
          "blüte": "April bis Juni",
          "farbe": "weiß",
          "geruch": "scharf",
          "umgebung": "Feuchte Wiesen, Gräben",
          "bestäubung": "Insekten",
          "familie": "Kreuzblütengewächse",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "7",
          "name": "Wildes Stiefmütterchen/Ackerveilchen",
          "taxon": "Viola tricolor",
          "blüte": "April bis Juni",
          "farbe": "lila mit gelbem Auge",
          "geruch": "leicht süßlich",
          "umgebung": "Felder, Wiesen",
          "bestäubung": "Insekten",
          "familie": "Veilchengewächse",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "8",
          "name": "Wiesen-Fuchsschwanz",
          "taxon": "Alopecurus pratensis",
          "blüte": "Mai bis Juli",
          "farbe": "grünlich-braun",
          "geruch": "neutral",
          "umgebung": "Wiesen, Grasland",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "9",
          "name": "Gewöhnliches Knäuelgras/Knaulgras",
          "taxon": "Dactylis glomerata",
          "blüte": "Juni bis August",
          "farbe": "grün",
          "geruch": "neutral",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "10",
          "name": "Gewöhnliches Glatthafer",
          "taxon": "Arrhenatherum elatius",
          "blüte": "Juni bis Juli",
          "farbe": "grün",
          "geruch": "leicht süßlich",
          "umgebung": "Trockenrasen, Weiden",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "11",
          "name": "Wolliges Honiggras",
          "taxon": "Holcus lanatus",
          "blüte": "Juli bis August",
          "farbe": "grünlich-gelb",
          "geruch": "süß",
          "umgebung": "Weiden, Wegränder",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "12",
          "name": "Rot-Schwingel",
          "taxon": "Festuca rubra",
          "blüte": "Mai bis Juli",
          "farbe": "grün",
          "geruch": "neutral",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "13",
          "name": "Deutsches Weidelgras",
          "taxon": "Lolium perenne",
          "blüte": "Mai bis Juli",
          "farbe": "grün",
          "geruch": "neutral",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "14",
          "name": "Gewöhnliches Rispengras",
          "taxon": "Poa trivialis",
          "blüte": "Juni bis August",
          "farbe": "grün",
          "geruch": "neutral",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "15",
          "name": "Bärlauch",
          "taxon": "Allium ursinum",
          "blüte": "April bis Mai",
          "farbe": "grün",
          "geruch": "knoblauchartig",
          "umgebung": "Laubwälder, Wegränder",
          "bestäubung": "Insekten",
          "familie": "Liliengewächse",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "16",
          "name": "Große Brennnessel",
          "taxon": "Urtica dioica",
          "blüte": "Mai bis Oktober",
          "farbe": "grün",
          "geruch": "scharf",
          "umgebung": "Wiesen, Wegränder",
          "bestäubung": "Wind",
          "familie": "Brennesselgewächse",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "groß (70-120cm), sehr groß (größer als 1.2m)",
          "tee": "1"
        },
        {
          "pflanzen_id": "17",
          "name": "Wiesenklee",
          "taxon": "Trifolium pratense",
          "blüte": "Mai bis September",
          "farbe": "grün",
          "geruch": "leicht süßlich",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Insekten",
          "familie": "Hülsenfrüchtler",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "18",
          "name": "Gemeine Schafgarbe",
          "taxon": "Achillea millefolium",
          "blüte": "Juni bis August",
          "farbe": "weiß",
          "geruch": "aromatisch",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Insekten",
          "familie": "Korbblütler",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "19",
          "name": "Spitzwegerich",
          "taxon": "Plantago lanceolata",
          "blüte": "Mai bis September",
          "farbe": "grün",
          "geruch": "leicht bitter",
          "umgebung": "Wiesen, Weiden",
          "bestäubung": "Wind",
          "familie": "Wegerichgewächse",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "klein (bis zu 30cm), mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "20",
          "name": "Wilde Möhre",
          "taxon": "Daucus carota",
          "blüte": "Juni bis August",
          "farbe": "weiß mit rötlichen Flecken",
          "geruch": "aromatisch",
          "umgebung": "Wiesen, Grasland",
          "bestäubung": "Insekten",
          "familie": "Doldenblütler",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "groß (70-120cm), mittel (30-70cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "21",
          "name": "Borretsch",
          "taxon": "Borago officinalis",
          "blüte": "Juni bis September",
          "farbe": "blauviolett",
          "geruch": "gurkenartig",
          "umgebung": "Gärten, Wegränder",
          "bestäubung": "Insekten",
          "familie": "Raublattgewächse",
          "heilend": "0",
          "herkunft": "Asien, Europa",
          "größe": "mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "22",
          "name": "Steinpilz",
          "taxon": "Boletus edulis",
          "blüte": "Sommer bis Herbst",
          "farbe": "braun",
          "geruch": "angenehm",
          "umgebung": "Laubwälder, Kiefernwälder",
          "bestäubung": "Wind",
          "familie": "Dickröhrlingsverwandte",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "klein (bis zu 30cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "23",
          "name": "Pfifferling",
          "taxon": "Cantharellus cibarius",
          "blüte": "Sommer bis Herbst",
          "farbe": "gelb",
          "geruch": "fruchtig",
          "umgebung": "Laubwälder, Kiefernwälder",
          "bestäubung": "Insekten",
          "familie": "Pfifferlingsartige",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "klein (bis zu 30cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "24",
          "name": "Speisenmorchel",
          "taxon": "Morchella esculenta",
          "blüte": "Frühling bis Frühsommer",
          "farbe": "braun",
          "geruch": "nussig",
          "umgebung": "Laubwälder, Mischwälder",
          "bestäubung": "Wind",
          "familie": "Morchelverwandte",
          "heilend": "0",
          "herkunft": "Asien, Europa, 0rdamerika",
          "größe": "klein (bis zu 30cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "25",
          "name": "Stockschwämmchen",
          "taxon": "Kuehneromyces mutabilis",
          "blüte": "Sommer bis Herbst",
          "farbe": "gelb",
          "geruch": "leicht säuerlich",
          "umgebung": "Laubwälder, Nadelwälder",
          "bestäubung": "Wind",
          "familie": "Schichtpilze",
          "heilend": "0",
          "herkunft": "Europa, 0rdamerika",
          "größe": "klein (bis zu 30cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "26",
          "name": "Ordchidee",
          "taxon": "Orchis purpurea",
          "blüte": "Januar bis März",
          "farbe": "blau, lila, orange, rosa, weiß",
          "geruch": "Blumig",
          "umgebung": "Feucht",
          "bestäubung": "Insekten",
          "familie": "Orchideengewächse",
          "heilend": "0",
          "herkunft": "Asien",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "27",
          "name": "Erdbeerpflanze",
          "taxon": "Gattung Fragaria",
          "blüte": "Mai bis Juli",
          "farbe": "rosa, weiß",
          "geruch": "Fruchtig",
          "umgebung": "Gärten",
          "bestäubung": "Insekten",
          "familie": "Rosengewächse",
          "heilend": "0",
          "herkunft": "Europa",
          "größe": "klein (bis zu 30cm)",
          "tee": "0"
        },
        {
          "pflanzen_id": "28",
          "name": "Gurkenpflanze",
          "taxon": "Cucumis sativus",
          "blüte": "Juni bis August",
          "farbe": "gelb",
          "geruch": "Fruchtig",
          "umgebung": "Gärten",
          "bestäubung": "Insekten",
          "familie": "Kürbisgewächse",
          "heilend": "0",
          "herkunft": "Asien",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "29",
          "name": "Himbeere",
          "taxon": "Rubus idaeus",
          "blüte": "Juli bis September",
          "farbe": "rot",
          "geruch": "Süß",
          "umgebung": "Felder, Gärten, Wald",
          "bestäubung": "Insekten",
          "familie": "Rosengewächse",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "1"
        },
        {
          "pflanzen_id": "30",
          "name": "Blaubeere",
          "taxon": "Vaccinium myrtillus",
          "blüte": "Mai bis Juli",
          "farbe": "blau, weiß",
          "geruch": "Süß",
          "umgebung": "Wald",
          "bestäubung": "Insekten",
          "familie": "Heidekrautgewächse",
          "heilend": "1",
          "herkunft": "0rdamerika",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "31",
          "name": "Brombeere",
          "taxon": "Rubus",
          "blüte": "Juli bis August",
          "farbe": "rosa, weiß",
          "geruch": "Süß",
          "umgebung": "Gärten, Wald",
          "bestäubung": "Insekten",
          "familie": "Rosengewächse",
          "heilend": "1",
          "herkunft": "Europa, Nordamerika",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "1"
        },
        {
          "pflanzen_id": "32",
          "name": "Rose",
          "taxon": "Rosaceae",
          "blüte": "Mai, Juni und September",
          "farbe": "gelb, rot, weiß",
          "geruch": "Blumig",
          "umgebung": "Gärten",
          "bestäubung": "Insekten",
          "familie": "Rosengewächse",
          "heilend": "1",
          "herkunft": "Asien",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "33",
          "name": "Bambuspflanze",
          "taxon": "Bambusa vulgaris",
          "blüte": "---",
          "farbe": "grün",
          "geruch": "Säuerlich",
          "umgebung": "Wald",
          "bestäubung": "Wind",
          "familie": "Süßgräser",
          "heilend": "0",
          "herkunft": "Asien, Südamerika",
          "größe": "sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "34",
          "name": "Bananenbaum",
          "taxon": "Musa × paradisiaca",
          "blüte": "---",
          "farbe": "gelb, lila, rosa",
          "geruch": "Fruchtig",
          "umgebung": "Feucht",
          "bestäubung": "Insekten",
          "familie": "Bananengewächse",
          "heilend": "0",
          "herkunft": "Asien",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "35",
          "name": "Salbei",
          "taxon": "Salvia pratensis",
          "blüte": "Sommer bis Herbst",
          "farbe": "lila",
          "geruch": "stark",
          "umgebung": "Felder, Gärten, Wald",
          "bestäubung": "Insekten",
          "familie": "Lippenblütler",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "mittel (30-70cm)",
          "tee": "1"
        },
        {
          "pflanzen_id": "36",
          "name": "Weide",
          "taxon": "Salix aurita",
          "blüte": "März bis April",
          "farbe": "gelb, grün",
          "geruch": "leicht",
          "umgebung": "Feucht",
          "bestäubung": "Wind",
          "familie": "Weidengewächse",
          "heilend": "1",
          "herkunft": "Asien, Europa",
          "größe": "groß (70-120cm), mittel (30-70cm), sehr groß (größer als 1.2m)",
          "tee": "0"
        },
        {
          "pflanzen_id": "37",
          "name": "Echte Aloe",
          "taxon": "Aloe vera",
          "blüte": "ganzjährig",
          "farbe": "gelb",
          "geruch": "leicht",
          "umgebung": "trocken",
          "bestäubung": "Insekten",
          "familie": "Grasbaumgewächse",
          "heilend": "1",
          "herkunft": "Afrika",
          "größe": "mittel (30-70cm)",
          "tee": "0"
        }
      ]
    };

    List<dynamic> temp = response.data['inventory'];
    debugPrint("Lexicon Element 1: ${temp.first}");

    for (int i = 0; i < temp.length; i++) {
      allPlants.add(LexiconPlant.fromJson(temp[i]));
    }
  }
}

class LexiconForUser {
  // Singleton
  static final LexiconForUser _instance = LexiconForUser._constructor();

  List<LexiconPlant> allShowedPlants = List.empty(growable: true);

  factory LexiconForUser() {
    return _instance;
  }
  LexiconForUser._constructor();
}

class LexiconPlant {
  int? id;
  String? name;
  String? taxonName;
  String? geruch;
  String? umgebung;
  String? farbe;
  String? bluete;
  bool displayPlant;

  LexiconPlant.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['pflanzen_id']),
        name = json['name'],
        taxonName = json['taxon'],
        geruch = json['geruch'],
        umgebung = json['umgebung'],
        farbe = json['farbe'],
        bluete = json['blüte'],
        displayPlant = false;
}
