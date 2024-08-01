import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StateModel {
  final String title;
  final Icon? icon;
  StateModel({required this.title, this.icon});

  static List<String> townNames = [
    'Aghdam',
    'Agdash',
    'Aghjabadi',
    'Agstafa',
    'Agsu',
    'Astara',
    'Aghdara',
    'Babek',
    'Baku',
    'Balakən',
    'Barda',
    'Beylagan',
    'Bilasuvar',
    'Dashkasan',
    'Shabran',
    'Fuzuli',
    'Gadabay',
    'Ganja',
    'Goranboy',
    'Goychay',
    'Goygol',
    'Hajigabul',
    'Imishli',
    'Ismayilli',
    'Jabrayil',
    'Julfa',
    'Kalbajar',
    'Khachmaz',
    'Khankendi',
    'Khojavend',
    'Khirdalan',
    'Kurdamir',
    'Lankaran',
    'Lerik',
    'Masally',
    'Mingachevir',
    'Nakhchivan',
    'Naftalan',
    'Neftchala',
    'Oghuz',
    'Ordubad',
    'Qabala',
    'Qakh',
    'Qazakh',
    'Quba',
    'Qubadli',
    'Qusar',
    'Saatlı (city)',
    'Sabirabad',
    'Shahbuz',
    'Shaki',
    'Shamakhi',
    'Shamkir',
    'Sharur',
    'Shirvan',
    'Siyazan',
    'Shusha',
    'Sumgait',
    'Tartar',
    'Tovuz',
    'Ujar',
    'Yardimli',
    'Yevlakh',
    'Zaqatala',
    'Zardab',
    'Zangilan'
  ];
  static List<String> villages = [
    "Maştağa",
    "Buzovna",
    "Qala",
    "Balaxanı",
    "Zığ",
    "Binə",
    "Zirə",
    "Şüvəlan",
    "Türkan",
    "Kürdəxanı",
    "Zabrat",
    "Balaxanı",
    "Keşlə",
    "Binəqədi",
    "Əmircan",
    "Bilgəh",
    "Corat",
    "Bülbülə",
    "Güzdək",
    "Bibiheybət",
    "Biləcəri",
    "Masazır",
    "Əhmədli",
    "Zağulba",
    "Qobustan",
    "Digah",
    "Ramana",
    "Pirşağı",
    "Pirallahı",
    "Mərdəkan",
    "Şağan",
    "Hövsan",
    "Dübəndi",
    "Hökməli",
    "Xocahəsən",
    "Lökbatan",
    "Görədil",
    "Fatmayı",
    "Nardaran",
    "Novxanı",
    "Saray",
    "Sabunçu",
    "Yeni Suraxanı",
    "Məmmədli",
    "Mexkalon",
    "Nübar",
  ];

  static List<String> subwayStations = [
    "İçərişəhər",
    "Sahil",
    "28 May",
    "Gənclik",
    "Nəriman Nərimanov",
    "Bakmil",
    "Ulduz",
    "Koroğlu",
    "Qara Qarayev",
    "Neftçilər",
    "Xalqlar Dostluğu",
    "Əhmədli",
    "Həzi Aslanov"
  ];
  static List<StateModel> townModels = List<StateModel>.generate(
    townNames.length,
    (index) => StateModel(title: townNames[index]),
  );

  static List<StateModel> villageModels = List<StateModel>.generate(
    villages.length,
    (index) => StateModel(
        title: villages[index],
        icon: Icon(
          FontAwesomeIcons.city,
          color: Colors.blue,
        )),
  );

  static List<StateModel> subwayStationModels = List<StateModel>.generate(
    subwayStations.length,
    (index) => StateModel(
        title: subwayStations[index],
        icon: Icon(
          Icons.subway_outlined,
          color: Colors.blue,
        )),
  );
  static List<String> getTowns() => townNames;
  static List<String> getVillages() => villages;
  static List<String> getStations() => subwayStations;
}
