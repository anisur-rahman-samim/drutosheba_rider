
import 'package:druto_seba_driver/src/components/trip/trip_vivoroni_details.dart';
import 'package:druto_seba_driver/src/configs/appColors.dart';
import 'package:druto_seba_driver/src/configs/appUtils.dart';
import 'package:druto_seba_driver/src/modules/allGari/controller/vehicles_controller.dart';
import 'package:druto_seba_driver/src/modules/driver/controller/driver_controller.dart';
import 'package:druto_seba_driver/src/modules/trip/controller/confirmed_trip_controller.dart';
import 'package:druto_seba_driver/src/modules/trip/controller/distance_time_controller.dart';
import 'package:druto_seba_driver/src/modules/trip/controller/waiting_bid_trip_controller.dart';
import 'package:druto_seba_driver/src/network/api/api.dart';
import 'package:druto_seba_driver/src/services/text_styles.dart';
import 'package:druto_seba_driver/src/widgets/bottomSheet/customBottomSheet.dart';
import 'package:druto_seba_driver/src/widgets/button/outlineButton.dart';
import 'package:druto_seba_driver/src/widgets/card/customCardWidget.dart';
import 'package:druto_seba_driver/src/widgets/dottedDivider/dotDivider.dart';
import 'package:druto_seba_driver/src/widgets/loader/custom_loader.dart';
import 'package:druto_seba_driver/src/widgets/loader/no_data.dart';
import 'package:druto_seba_driver/src/widgets/text/kText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';



class StartedTripView extends StatefulWidget {
  @override
  State<StartedTripView> createState() => _StartedTripViewState();
}

class _StartedTripViewState extends State<StartedTripView> {
  final ConfirmedTripController confirmTripController = Get.put(ConfirmedTripController());

  final VehiclesController vehiclesController = Get.put(VehiclesController());
  final DriverController driverController = Get.put(DriverController());

  final DistanceTimeController distanceTimeController = Get.put(DistanceTimeController());

  @override
  void initState() {
    confirmTripController.getConfirmedTrip();
    vehiclesController.getVehicles();
    super.initState();
  }

  var selectedDriver = RxString('');
  var selectedDriverId = RxString('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Padding(
            padding: paddingH10,
            child: Obx(() => confirmTripController.isLoading.value == true? CustomLoader(color: black, size: 30): confirmTripController.startTripList.isEmpty? Center(child: NoDataView()) : RefreshIndicator(
              onRefresh: ()async{
                await   confirmTripController.getConfirmedTrip();
                vehiclesController.getVehicles();
              },
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: confirmTripController.startTripList.length,
                  itemBuilder: ((context, index) {
                    String pickUpCoordinates =  confirmTripController.startTripList[index].getTripDetails!.map.toString();
                    List<String> pickUpParts = pickUpCoordinates.split(' ');

                    double upLat = double.parse(pickUpParts[0]);
                    double upLng = double.parse(pickUpParts[1]);

                    String downCoordinates =  confirmTripController.startTripList[index].getTripDetails!.dropoffMap.toString();
                    List<String> downUpParts = downCoordinates.split(' ');

                    double downLat = double.parse(downUpParts[0]);
                    double downLng = double.parse(downUpParts[1]);

                    distanceTimeController.calculateDistanceAndDuration(upLat, upLng, downLat, downLng);
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: (){
                          Get.to(() => TripVivoroniDetails(confirmedTrips: confirmTripController.startTripList[index]));
                        },
                        child: CustomCardWidget(
                          color: white,
                          radius: 10,
                          child: Padding(
                            padding: paddingH20V10,
                            child: Column(
                              children: [
                                confirmTripController.startTripList[index].tripStarted == 1 && confirmTripController.startTripList[index].status == 0?
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: blue,
                                      ),
                                      sizeW10,
                                      Text("Running Trip",style: h2.copyWith(fontSize: 14),)
                                    ],
                                  ),
                                ):SizedBox.shrink(),
                                Row(
                                  children: [
                                    KText(
                                      text: 'ট্রিপ: ',
                                      color: black54,
                                      fontSize: 12,
                                    ),
                                    KText(
                                      text: '${confirmTripController.startTripList[index].trackingId}',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: KText(
                                          text: confirmTripController.startTripList[index].getVehicleBrand?.name,
                                          fontSize: 14,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                sizeH10,
                                DotDividerWidget(
                                  fillRate: .5,
                                ),
                                sizeH10,
                                SizedBox(
                                  height: 90,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                shape: BoxShape.circle),
                                            child: ClipOval(
                                              child: Image.network(
                                                Api.getImageURL(
                                                    confirmTripController
                                                        .startTripList[index]
                                                        .getCar
                                                        ?.vehicleDrivingFront),
                                                width: 30,
                                                height: 40,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          sizeW5,
                                          KText(
                                            text:
                                            '${confirmTripController.startTripList[index].getCar?.brandName}',
                                            fontSize: 13,
                                            color: black,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      sizeW20,
                                      Column(
                                        children: [
                                          sizeH5,
                                          Image.asset(
                                            "assets/img/pick.png",
                                            scale: 20,
                                          ),
                                          // sizeH5,
                                          Expanded(
                                            child: Container(
                                              // height: 50,
                                              width: .7,
                                              color: grey,
                                            ),
                                          ),
                                          sizeH5,
                                          Image.asset(
                                            "assets/img/map.png",
                                            scale: 20,
                                          ),
                                        ],
                                      ),
                                      sizeW10,
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: 'শুরু: ',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              // sizeW5,
                                              Container(
                                                width: Get.width / 2.2,
                                                child: KText(
                                                  text: confirmTripController.startTripList[index].getTripDetails?.pickupLocation,
                                                  fontSize: 14,
                                                  maxLines: 2,
                                                  color: black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: 'শেষ: ',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              // sizeW5,
                                              Container(
                                                width: Get.width / 2.2,
                                                // color: primaryColor,
                                                child: KText(
                                                  text:
                                                  confirmTripController.startTripList[index].getTripDetails?.dropoffLocation,
                                                  fontSize: 14,
                                                  maxLines: 2,
                                                  color: black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                sizeH10,
                                DotDividerWidget(
                                  fillRate: .5,
                                ),
                                sizeH10,
                                rawText(
                                  title: 'যাত্রার সময়',
                                  content: confirmTripController.startTripList[index].getTripDetails?.datetime,
                                ),
                                sizeH5,
                                confirmTripController.startTripList[index].getTripDetails?.roundTrip == 1?  rawText(
                                  title: 'ফিরতি তারিখ',
                                  content: confirmTripController.startTripList[index].getTripDetails?.roundDatetime,
                                ): SizedBox.shrink(),
                                sizeH5,
                                rawText(
                                  title: 'রাউন্ড ট্রিপ',
                                  content: confirmTripController.startTripList[index].getTripDetails?.roundTrip == 1? 'হ্যাঁ': "না",
                                ),
                                /*sizeH5,
                                rawText(
                                  title: 'দুরুত্ব',
                                  content: '${distanceTimeController.totalDistance} কি:মি',
                                ),*/
                                sizeH5,
                                rawText(
                                  title: 'এয়ার কন্ডিশন',
                                  content: vehiclesController.vehiclesList[int.parse(confirmTripController.startTripList[index].vehicleId.toString())].aircondition == "yes"? 'হ্যাঁ': "না",
                                ),
                                sizeH5,
                                Row(
                                  children: [
                                    KText(
                                      text: '${vehiclesController.vehiclesList[int.parse(confirmTripController.startTripList[index].vehicleId.toString())].metro}-'
                                          '${vehiclesController.vehiclesList[int.parse(confirmTripController.startTripList[index].vehicleId.toString())].metroType}-'
                                          '${vehiclesController.vehiclesList[int.parse(confirmTripController.startTripList[index].vehicleId.toString())].metroNo}',
                                      fontSize: 14,
                                    ),
                                    Spacer(),
                                    KText(
                                      text: 'রেন্টাল ভাড়া ৳ ${confirmTripController.startTripList[index].amount}',
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                                sizeH10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    outlineButton(
                                      buttonName: confirmTripController.startTripList[index].status == 1? "COMPLETED" :"TRIP START",
                                      textColor: white,
                                      backgroundColor: HexColor('#842a8f'),
                                      outlineColor: HexColor('#842a8f'),
                                      radius: 5,
                                      height: 30,
                                      width: 90,
                                      fontSize: 14,
                                      onTap: () {},
                                    ),

                                    confirmTripController.startTripList[index].assignedDriverId != null ?   Text("Driver: ${confirmTripController.startTripList[index].getDriver!.name.toString()}",style: h4,):   Row(
                                      children: [
                                        Text(confirmTripController.startTripList[index].getDriver?.name != null? confirmTripController.startTripList[index].getDriver!.name.toString():"",style: h4,),
                                        sizeW10,
                                        InkWell(
                                          onTap: (){
                                            customBottomSheet(
                                              context: context,
                                              height: Get.height / 1.4,
                                              child: ListView(
                                                shrinkWrap: true,
                                                primary: false,
                                                children: [
                                                  Center(
                                                    child: KText(
                                                      text: 'ড্রাইভার নির্বাচন করুন',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  sizeH10,
                                                  Container(
                                                    height: Get.height / 1.7,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemCount: driverController.approvedDriverList.length,
                                                        itemBuilder: (c, i) {
                                                          final item = driverController.approvedDriverList[i];
                                                          return InkWell(
                                                            borderRadius: BorderRadius.circular(5),
                                                            onTap: () {
                                                              setState(() {
                                                                selectedDriver.value =
                                                                    item.name.toString();
                                                                selectedDriverId.value =
                                                                    item.id.toString();
                                                                driverController.driverAssign(driverId: item.id.toString(), tripId: confirmTripController.startTripList[index].getTripDetails?.id.toString());
                                                                Navigator.pop(context);
                                                                setState(() {

                                                                });
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.all(10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                                children: [
                                                                  /* Image.asset(
                                                      Api.getImageURL(item.image.toString(),),
                                                      width: 50,
                                                      // width: Get.width / 6,
                                                    ),*/
                                                                  sizeW20,
                                                                  SizedBox(
                                                                    width: Get.width / 1.5,
                                                                    child: Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        KText(
                                                                          text: item.name,
                                                                          fontSize: 14,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                        ),
                                                                        SizedBox(width: 3),
                                                                        /* KText(
                                                text: item.capacity,
                                                fontSize: 12,
                                                color: black45,
                                              ),*/
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  CircleAvatar(
                                                                    radius: 10,
                                                                    backgroundColor:
                                                                    selectedDriver.value ==
                                                                        item.name
                                                                        ? primaryColor
                                                                        : grey,
                                                                    child: CircleAvatar(
                                                                      backgroundColor:
                                                                      selectedDriver.value ==
                                                                          item.name
                                                                          ? primaryColor
                                                                          : white,
                                                                      radius: 9,
                                                                      child: selectedDriver.value ==
                                                                          item.name
                                                                          ? Icon(
                                                                        Icons.done,
                                                                        size: 15,
                                                                        color: white,
                                                                      )
                                                                          : null,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: black54,
                                            child: CircleAvatar(
                                              radius: 11,
                                              backgroundColor: white,
                                              child: Icon(
                                                Ionicons.person_add_outline,
                                                color: black45,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
            ),)
        ),
      ),
    );
  }

  rawText({
    required title,
    required content,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KText(
            text: title == null ? '' : '$title:',
            fontSize: 14,
            color: black45,
          ),
          title == null ? sizeH10 : sizeW10,
          KText(
            text: content,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ],
      );
}