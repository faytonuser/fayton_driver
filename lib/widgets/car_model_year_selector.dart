import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/globals.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DependentDropdowns extends StatefulWidget {
  @override
  _DependentDropdownsState createState() => _DependentDropdownsState();
}

class _DependentDropdownsState extends State<DependentDropdowns> {


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
    final authProvider = context.read<AuthProvider>();
    openBottomSheet(
      context: context,
      items: manufacturers.map((m) => m['name']!).toList(),
      title: 'Marka Seçin',
      onItemSelected: (selected) {
        setState(() {
          authProvider.updateSelectedManufacturer(selected ?? '');
          authProvider.updateSelectedModel(null);
          authProvider.updateSelectedYear(null);
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
    final authProvider = context.read<AuthProvider>();
    if ( authProvider.selectedManufacturer == null) return;

    openBottomSheet(
      context: context,
      items: models,
      title: 'Model Seçin',
      onItemSelected: (selected) {
        setState(() {
          authProvider.updateSelectedModel(selected);
          authProvider.updateSelectedYear(null);
          years.clear();
          fetchYears();
        });
      },
      onSearch: null,
    );
  }

  void openYearBottomSheet() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.selectedModel == null) return;

    openBottomSheet(
      context: context,
      items: years,
      title: 'İl Seçin',
      onItemSelected: (selected) {
        setState(() {
          authProvider.updateSelectedYear(selected);
          fetchColors();
        });
      },
      onSearch: null,
    );
  }

  void openColorBottomSheet() {
    final authProvider = context.read<AuthProvider>();
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
          authProvider.updateSelectedColor(selected);
        });
      },
      onSearch: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
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
                      authProvider.selectedManufacturer ?? 'Marka Seçin',
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(authProvider.selectedManufacturer, 'Marka') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(authProvider.selectedManufacturer, 'Marka')!,
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
                  onTap: authProvider.selectedManufacturer != null
                      ? openModelBottomSheet
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      authProvider.selectedModel ?? 'Model Seçin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(authProvider.selectedModel, 'Model') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(authProvider.selectedModel, 'Model')!,
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
                  authProvider.selectedModel != null ? openYearBottomSheet : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      authProvider.selectedYear ?? 'İl Seçin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(authProvider.selectedYear, 'İl') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(authProvider.selectedYear, 'İl')!,
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
                  onTap: authProvider.selectedYear != null ? openColorBottomSheet : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      authProvider.selectedColor ?? 'Rəng Seçin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              if (validateSelection(authProvider.selectedColor, 'Rəng') != null)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    validateSelection(authProvider.selectedColor, 'Rəng')!,
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
