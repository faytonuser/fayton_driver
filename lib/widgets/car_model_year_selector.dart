import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/globals.dart';
import 'package:flutter/material.dart';

class DependentDropdowns extends StatefulWidget {
  @override
  _DependentDropdownsState createState() => _DependentDropdownsState();
}

class _DependentDropdownsState extends State<DependentDropdowns> {
  String? selectedManufacturer;
  String? selectedModel;
  String? selectedYear;
  String? selectedColor;

  List<Map<String, String>> manufacturers = [];
  List<String> models = [];
  List<String> years = [];
  List<String> colors = [];

  bool isLoadingManufacturers = true;

  @override
  void initState() {
    super.initState();
    fetchManufacturers();
    fetchColors();
  }

  String? validateSelection(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName seçilməlidir';
    }
    else {
      isCarFormValid = true;
    }
    return null;
  }

  Future<void> fetchManufacturers() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('manufacturers').get();
      setState(() {
        manufacturers = querySnapshot.docs
            .map((doc) => {
          'id': doc.id,
          'name': doc['name'].toString(),
        })
            .toList();
        isLoadingManufacturers = false;
      });
    } catch (e) {
      print("Error fetching manufacturers: $e");
    }
  }

  Future<void> fetchModels(String manufacturerId) async {
    setState(() {
      models = [];
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('car_models')
          .where('manufacturer_id', isEqualTo: manufacturerId)
          .get();
      setState(() {
        models = querySnapshot.docs
            .map((doc) => doc['model_name'].toString())
            .toList();
      });
    } catch (e) {
      print("Error fetching models: $e");
    }
  }

  Future<void> fetchYears() async {
    setState(() {
      years = [];
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('car_production_year')
          .get();

      List<String> fetchedYears = querySnapshot.docs.map((doc) {
        if (doc.exists) {
          return doc['year'].toString();
        } else {
          return 'Unknown';
        }
      }).toList();

      setState(() {
        years = fetchedYears;
      });

      print('Fetched years: $years');
    } catch (e) {
      print("Error fetching years: $e");
    }
  }

  Future<void> fetchColors() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('car_colors').get();
      setState(() {
        colors =
            querySnapshot.docs.map((doc) => doc['color'].toString()).toList();
      });
      print("Fetched colors: $colors");
    } catch (e) {
      print("Error fetching colors: $e");
    }
  }

  void openBottomSheet({
    required BuildContext context,
    required List<String> items,
    required String title,
    required Function(String?) onItemSelected,
    required Future<void> Function()? onSearch,
  }) {
    TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(items);
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Axtarış',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) async {
                      setState(() {
                        isLoading = true;
                      });
                      if (onSearch != null) await onSearch();
                      setState(() {
                        filteredItems = items
                            .where((item) => item
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                            .toList();
                        isLoading = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredItems.isNotEmpty
                      ? ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredItems[index]),
                        onTap: () {
                          onItemSelected(filteredItems[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  )
                      : Center(child: Text('Heç bir məlumat tapılmadı')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void openManufacturerBottomSheet() {
    openBottomSheet(
      context: context,
      items: manufacturers.map((m) => m['name']!).toList(),
      title: 'Marka Seçin',
      onItemSelected: (selected) {
        setState(() {
          selectedManufacturer = selected;
          selectedModel = null;
          selectedYear = null;
          models.clear();
          years.clear();
          final manufacturerId =
          manufacturers.firstWhere((m) => m['name'] == selected)['id']!;
          fetchModels(manufacturerId);
        });
      },
      onSearch: null,
    );
  }

  void openModelBottomSheet() {
    if (selectedManufacturer == null) return;

    openBottomSheet(
      context: context,
      items: models,
      title: 'Model Seçin',
      onItemSelected: (selected) {
        setState(() {
          selectedModel = selected;
          selectedYear = null;
          years.clear();
          fetchYears();
        });
      },
      onSearch: null,
    );
  }

  void openYearBottomSheet() {
    if (selectedModel == null) return;

    openBottomSheet(
      context: context,
      items: years,
      title: 'İl Seçin',
      onItemSelected: (selected) {
        setState(() {
          selectedYear = selected;
          fetchColors();
        });
      },
      onSearch: null,
    );
  }

  void openColorBottomSheet() {
    if (colors.isEmpty) {
      print("Colors list is empty, cannot open color bottom sheet.");
      return;
    }

    openBottomSheet(
      context: context,
      items: colors,
      title: "Rəng Seçin",
      onItemSelected: (selected) {
        setState(() {
          selectedColor = selected;
        });
      },
      onSearch: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: GestureDetector(
                  onTap:
                  isLoadingManufacturers ? null : openManufacturerBottomSheet,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      selectedManufacturer ?? 'Marka Seçin',
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(selectedManufacturer, 'Marka') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(selectedManufacturer, 'Marka')!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: GestureDetector(
                  onTap: selectedManufacturer != null
                      ? openModelBottomSheet
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      selectedModel ?? 'Model Seçin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(selectedModel, 'Model') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(selectedModel, 'Model')!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: GestureDetector(
                  onTap:
                  selectedModel != null ? openYearBottomSheet : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      selectedYear ?? 'İl Seçin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(selectedYear, 'İl') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(selectedYear, 'İl')!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: GestureDetector(
                  onTap: selectedYear != null ? openColorBottomSheet : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      selectedColor ?? 'Rəng Seçin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(selectedColor, 'Rəng') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(selectedColor, 'Rəng')!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
