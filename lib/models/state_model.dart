import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StateModel {
  final String title;
  final Icon? icon;
  StateModel({required this.title, this.icon});

  static List<String> townNames = [
    'Ağdam',
    'Ağdaş',
    'Ağcabədi',
    'Ağstafa',
    'Ağsu',
    'Astara',
    'Ağdərə',
    'Babək',
    'Bakı',
    'Balakən',
    'Bərdə',
    'Beyləqan',
    'Biləsuvar',
    'Daşkəsən',
    'Şabran',
    'Füzuli',
    'Gədəbəy',
    'Gəncə',
    'Goranboy',
    'Göyçay',
    'Göygöl',
    'Hacıqabul',
    'İmişli',
    'İsmayıllı',
    'Cəbrayıl',
    'Culfa',
    'Kəlbəcər',
    'Xaçmaz',
    'Xankəndi',
    'Xocavənd',
    'Xırdalan',
    'Kürdəmir',
    'Lənkəran',
    'Lerik',
    'Masallı',
    'Mingəçevir',
    'Naxçıvan',
    'Naftalan',
    'Neftçala',
    'Oğuz',
    'Ordubad',
    'Qəbələ',
    'Qax',
    'Qazax',
    'Quba',
    'Qubadlı',
    'Qusar',
    'Saatlı',
    'Sabirabad',
    'Şahbuz',
    'Şəki',
    'Şamaxı',
    'Şəmkir',
    'Şərur',
    'Şirvan',
    'Siyəzən',
    'Şuşa',
    'Sumqayıt',
    'Tərtər',
    'Tovuz',
    'Ucar',
    'Yardımlı',
    'Yevlax',
    'Zaqatala',
    'Zərdab',
    'Zəngilan'
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
