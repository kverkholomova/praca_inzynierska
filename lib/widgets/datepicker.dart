
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings_vol_info.dart';

/// The hove page which hosts the calendar
class DatePicker extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final CalendarController _controller = CalendarController();
  String _text = '';

  void selectionChanged(CalendarSelectionDetails details) {
    if (_controller.view == CalendarView.month ||
        _controller.view == CalendarView.timelineMonth) {
      _text = DateFormat('dd, MMMM yyyy').format(details.date!).toString();
    } else {
      _text = DateFormat('dd, MMMM yyyy').format(details.date!).toString();
    }
    setState(() {

    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingsVol()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            SfCalendar(
              onSelectionChanged: selectionChanged,
              appointmentTextStyle: TextStyle(color: background),
              viewHeaderStyle: ViewHeaderStyle(
                  dateTextStyle: TextStyle(color: Colors.white),
                  dayTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  backgroundColor: blueColor),
              viewNavigationMode: ViewNavigationMode.none,
              showCurrentTimeIndicator: false,
              allowViewNavigation: false,
              showDatePickerButton: true,
              maxDate: DateTime.now(),
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: blueColor, width: 2),
                shape: BoxShape.rectangle,
              ),
              firstDayOfWeek: 1,
              todayTextStyle: TextStyle(color: blueColor),
              headerStyle: CalendarHeaderStyle(
                // textStyle: ,
                backgroundColor: blueColor,
              ),
              // blackoutDatesTextStyle: const TextStyle(color: Colors.orangeAccent),
              headerHeight: 150,
              todayHighlightColor: background,
              cellBorderColor: blueColor,
              view: CalendarView.month,
            ),
            // Padding(
            //   padding:
            //   EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            //   child: IconButton(
            //     icon: Icon(Icons.close),
            //     onPressed: () {
            //       // userInput = '0.00';
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => SettingsVol()),
            //       );
            //     },
            //   ),
            // ),
          ],
        ));
  }
}