import 'package:druto_seba_driver/src/configs/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../text/kText.dart';


class DateAndTime extends StatefulWidget {
  final Function(DateTime, TimeOfDay) onDateTimeSelected;

  DateAndTime({Key? key, required this.onDateTimeSelected}) : super(key: key);

  @override
  State<DateAndTime> createState() => DateAndTimeState();
}

class DateAndTimeState extends State<DateAndTime> {
  var dateTime = DateFormat('d MMMM yyyy');
  var selectedDate = DateTime.now();
  var selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      helpText: 'selectJourneyTime'.tr,
      cancelText: 'cancel'.tr,
      confirmText: 'submit'.tr,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
    );
    setState(() {
      selectedDate = picked ?? selectedDate;
      widget.onDateTimeSelected(selectedDate, selectedTime);
    });
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
     // helpText: 'enterTime1hourFromNow'.tr,
      cancelText: 'Cancel',
      confirmText: 'Submit',
      context: context,
      initialTime: selectedTime,
    );
    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
        widget.onDateTimeSelected(selectedDate, selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: KText(
              text: 'Journey Time',
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                    print("${_selectDate(context)}");
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: black45,
                        ),
                        SizedBox(width: 10),
                        KText(
                          text: selectedDate == null
                              ? 'selectDate'
                              : '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 1,
                color: black,
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Ionicons.time_outline,
                          color: black45,
                        ),
                        SizedBox(width: 10),
                        KText(
                          text: selectedTime == null
                              ? 'selectTime'
                              : DateFormat('h:mm a').format(DateTime(
                              2024, 1, 1, selectedTime.hour, selectedTime.minute)).toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
