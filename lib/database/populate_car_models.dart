import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fetchAndSaveManufacturers() async {
  final response = await http.get(Uri.parse('https://www.carqueryapi.com/api/0.3/?cmd=getMakes'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List manufacturers = data['Makes'];

    for (var manufacturer in manufacturers) {
      String makeId = manufacturer['make_id'];
      String makeName = manufacturer['make_display'];

      // Firestore-da sənəd ID-si yaradaraq istehsalçıları əlavə edir
      await FirebaseFirestore.instance.collection('manufacturers').doc(makeId).set({
        'id': makeId,
        'name': makeName,
      });
      print("ISTEHSALÇI DOLDURULUR ${makeName}");
    }
  } else {
    throw Exception('Failed to load manufacturers');
  }
}



Future<void> fetchAndSaveCarModels() async {
  // Bütün istehsalçıları əldə edir
  QuerySnapshot manufacturersSnapshot = await FirebaseFirestore.instance.collection('manufacturers').get();

  for (var manufacturer in manufacturersSnapshot.docs) {
    String makeId = manufacturer['id'];

    final modelResponse = await http.get(Uri.parse('https://www.carqueryapi.com/api/0.3/?cmd=getModels&make=$makeId'));

    if (modelResponse.statusCode == 200) {
      var modelData = json.decode(modelResponse.body);
      List models = modelData['Models'];

      for (var model in models) {
        await FirebaseFirestore.instance.collection('car_models').add({
          'manufacturer_id': makeId,  // Bu modelin hansı istehsalçıya aid olduğunu göstərir
          'model_name': model['model_name'],
        });
        print("Modellər DOLDURULUR ${model["model_name"]}");
      }
    }
  }
}


Future<void> fetchAndSaveCarProductionYears() async {
  try {
    // Firestore-dan məlumatları alın
    QuerySnapshot carModelsSnapshot = await FirebaseFirestore.instance.collection('car_models').get();

    if (carModelsSnapshot.docs.isEmpty) {
      print("Heç bir avtomobil modeli tapılmadı.");
    } else {
      print("Tapılan sənəd sayı: ${carModelsSnapshot.docs.length}");
    }

    for (var carModel in carModelsSnapshot.docs) {
      String modelName = carModel['model_name'];
      String manufacturerId = carModel['manufacturer_id'];

      print("Model adı: $modelName, İstehsalçı ID: $manufacturerId");

      // API sorğusu
      final yearResponse = await http.get(Uri.parse('https://www.carqueryapi.com/api/0.3/?cmd=getTrims&model=$modelName'));

      if (yearResponse.statusCode == 200) {
        var yearData = json.decode(yearResponse.body);
        List years = yearData['Trims'];

        print("API Response Data: $yearData");
        print("Years Data: $years");

        if (years.isEmpty) {
          print("Heç bir il məlumatı tapılmadı.");
        } else {
          for (var year in years) {
            print("Year Details: ${year['model_year']}");

            await FirebaseFirestore.instance.collection("car_production_year").add({
              'manufacturer_id': manufacturerId,
              'model_name': modelName,
              'production_year': year['model_year'],
            });

            print("İllər DOLDURULUR ${year['model_year']}");
          }
        }
      } else {
        print("API sorğusu uğursuz oldu: ${yearResponse.statusCode}");
      }
    }
  } catch (e) {
    print("Səhv baş verdi: $e");
  }
}





