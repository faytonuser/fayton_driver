import 'package:driver/common/app_colors.dart';
import 'package:driver/common/custom_button.dart';
import 'package:driver/common/custom_text_field.dart';
import 'package:driver/common/waiting_indicator.dart';
import 'package:driver/models/state_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/navbar_provider.dart';
import 'package:driver/providers/route_provider.dart';
import 'package:driver/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/helpers/show_date_picker.dart';
import 'package:flutter_material_pickers/helpers/show_selection_picker.dart';
import 'package:flutter_material_pickers/helpers/show_time_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../common/app_fonts.dart';

class AddRoutesScreen extends StatefulWidget {
  const AddRoutesScreen({super.key});

  @override
  State<AddRoutesScreen> createState() => _AddRoutesScreenState();
}

class _AddRoutesScreenState extends State<AddRoutesScreen> {
  @override
  void dispose() {
    var routeProvider = Provider.of<RouteProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeProvider.maxTravellerController.dispose();
      routeProvider.estimatedTravelDuration = 0;
      routeProvider.selectedEndDate = null;
      routeProvider.selectedStartDate = null;
      routeProvider.selectedFromRoute = null;
      routeProvider.selectedToRoute = null;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var routeProvider = Provider.of<RouteProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var navigationProvider = Provider.of<NavbarProvider>(context);

    final _addRouteFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yeni marşrut yaradın',
          style: AppFonts.generalTextThemeBig(Colors.black),
        ),
        centerTitle: true,
        /*      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.white,),
        ),
        backgroundColor: Color(0xff502eb2),*/
      ),
      body: SafeArea(
        child: Form(
            key: _addRouteFormKey,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24, top: 75),
                      child: CustomTextField(
                        controller: TextEditingController(
                            text: routeProvider.selectedFromRoute?.title ?? ""),
                        hintText: "Gediş şəhəri",
                        readOnly: true,
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.city,
                          color: AppColors.primaryColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                        onTap: () {
                          showMaterialSelectionPicker<StateModel?>(
                            context: context,
                            title: 'Gediş şəhərini seçin',
                            cancelText: "Ləğv et",
                            confirmText: "Təsdiqlə",
                            items: StateModel.townModels
                                .followedBy(StateModel.villageModels)
                                .followedBy(StateModel.subwayStationModels)
                                .toList(),
                            transformer: (item) => (item?.title),
                            iconizer: (item) => item?.icon,
                            selectedItem: routeProvider.selectedFromRoute,
                            onChanged: (value) => setState(
                                () => routeProvider.selectedFromRoute = value),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24),
                      child: CustomTextField(
                        controller: TextEditingController(
                            text: routeProvider.selectedToRoute?.title),
                        hintText: "Təyinat şəhəri",
                        readOnly: true,
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.city,
                          color: AppColors.primaryColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                        onTap: () {
                          showMaterialSelectionPicker<StateModel?>(
                            context: context,
                            title: "Gedəcəyiniz şəhəri seçin",
                            items: StateModel.townModels
                                .followedBy(StateModel.villageModels)
                                .followedBy(StateModel.subwayStationModels)
                                .toList(),
                            transformer: (item) => (item?.title),
                            cancelText: "Ləğv et",
                            confirmText: "Təsdiqlə",
                            iconizer: (item) => item?.icon,
                            selectedItem: routeProvider.selectedToRoute,
                            onChanged: (value) => setState(
                                () => routeProvider.selectedToRoute = value),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24),
                      child: CustomTextField(
                        controller: routeProvider.estimatedDuration,
                        hintText: "Səyahət vaxtı",
                        readOnly: false,
                        prefixIcon: FaIcon(FontAwesomeIcons.clock),
                        inputType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24),
                      child: CustomTextField(
                        controller: routeProvider.maxTravellerController,
                        hintText: "Boş yer sayı",
                        readOnly: false,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.users,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24),
                      child: CustomTextField(
                        controller: TextEditingController(),
                        validator: (value) {
                          if (routeProvider.selectedStartDate == null) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                        hintText: routeProvider.selectedStartDate == null
                            ? "Yola düşmə vaxtı"
                            : Utils.getFormatedDate(
                                routeProvider.selectedStartDate.toString()),
                        readOnly: true,
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.calendarDay,
                        ),
                        onTap: () async {
                          await showMaterialDatePicker(
                              confirmText: "Təsdiq et",
                              cancelText: "Ləğv et",
                              title: "Yola düşmə vaxtı",
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                              context: context,
                              selectedDate: routeProvider.selectedStartDate ??
                                  DateTime.now(),
                              onChanged: (value) =>
                                  routeProvider.selectedStartDate = value,
                              onConfirmed: () async {
                                await showMaterialTimePicker(
                                    context: context,
                                    selectedTime: routeProvider.startTime ??
                                        TimeOfDay.now(),
                                    onChanged: (value) =>
                                        routeProvider.startTime = value,
                                    onConfirmed: () {
                                      routeProvider.selectedStartDate =
                                          Utils.mergeDateTime(
                                              routeProvider.selectedStartDate,
                                              routeProvider.startTime);
                                    });
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24),
                      child: CustomTextField(
                        controller: TextEditingController(),
                        hintText: routeProvider.selectedEndDate == null
                            ? "Çatma vaxtı"
                            : Utils.getFormatedDate(
                                routeProvider.selectedEndDate.toString()),
                        readOnly: true,
                        validator: (value) {
                          if (routeProvider.selectedEndDate == null) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.calendarCheck,
                        ),
                        onTap: () async {
                          await showMaterialDatePicker(
                            cancelText: "Ləğv et",
                            confirmText: "Təsdiq et",
                            title: "Çatma vaxtı",
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            context: context,
                            selectedDate:
                                routeProvider.selectedEndDate ?? DateTime.now(),
                            onChanged: (value) =>
                                routeProvider.selectedEndDate = value,
                            onConfirmed: () async {
                              await showMaterialTimePicker(
                                context: context,
                                selectedTime:
                                    routeProvider.endTime ?? TimeOfDay.now(),
                                onChanged: (value) =>
                                    routeProvider.endTime = value,
                                onConfirmed: () {
                                  routeProvider.selectedEndDate =
                                      Utils.mergeDateTime(
                                          routeProvider.selectedEndDate,
                                          routeProvider.endTime);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48, bottom: 24),
                      child: CustomTextField(
                        controller: routeProvider.priceController,
                        hintText: "Adambaşı qiymət",
                        readOnly: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.moneyCheckDollar,
                        ),
                        inputType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Zəhmət olmasa, daxil edin';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 48.0, right: 48, top: 12),
                      child: routeProvider.isLoading
                          ? Center(
                              child: const CustomWaitingIndicator(),
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (_addRouteFormKey.currentState!.validate()) {
                                  var response =
                                      await routeProvider.createRoute(
                                          authProvider.currentUserId() ?? "",
                                          authProvider
                                                  .currentUser?.plateNumber ??
                                              "",
                                          authProvider.currentUser);

                                  if (response == true) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Marşrutunuz uğurla yaradıldı",
                                          style: GoogleFonts.nunito(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    navigationProvider.tabController
                                        .jumpToTab(0);
                                    // navigationProvider.tabController.index = 0;
                                    Navigator.pop(context, true);
                                  }
                                }
                              },
                              child: CustomButton(
                                text: 'Yaradın',
                                backgroundColor: AppColors.primaryColor,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
