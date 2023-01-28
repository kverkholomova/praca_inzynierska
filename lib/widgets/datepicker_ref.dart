
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wol_pro_1/constants.dart';

import '../screens/menu/refugee/home_page/settings_ref/settings_ref_info.dart';

int currentAgeRefugee = 0;
List month = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

class DatePickerRefugee extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const DatePickerRefugee({Key? key}) : super(key: key);

  @override
  _DatePickerRefugeeState createState() => _DatePickerRefugeeState();
}

class _DatePickerRefugeeState extends State<DatePickerRefugee> {
  final CalendarController _controller = CalendarController();
  String text = '';

  void selectionChanged(CalendarSelectionDetails details) {
    if (_controller.view == CalendarView.month ||
        _controller.view == CalendarView.timelineMonth) {
      text = DateFormat('dd, MMMM yyyy').format(details.date!).toString();
    } else {
      text = DateFormat('dd, MMMM yyyy').format(details.date!).toString();
    }
    setState(() {
      var currentDate;
      var bDate;

      month.forEach((element) {
        if(element == DateFormat('MMMM').format(DateTime.now())){
          currentDate=month.indexOf(element)+1;

        }
        if(element == DateFormat('MMMM').format(details.date!)){
         bDate = month.indexOf(element)+1;

        }});

        if(bDate<currentDate){
          currentAgeRefugee = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!));
          print(currentAgeRefugee);
        }
        else if(bDate>currentDate){
          currentAgeRefugee = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!))-1;
              // - DateFormat('yyyy').format(details.date!);
        }
        else if(bDate==currentDate){
          if(int.parse(DateFormat('dd').format(DateTime.now())) > int.parse(DateFormat('dd').format(details.date!))){
            currentAgeRefugee = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!));
          } else{
            currentAgeRefugee = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!))-1;
          }
        }

      dateOfBirthRefugee = text;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingsRef()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // setState(() {
        //   controllerTabBottomVol = PersistentTabController(initialIndex: 0);
        // });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => SettingsRef()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: redColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 30, color: backgroundRefugee,),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingsRef()));
            },
          )
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        // floatingActionButton: ,
          body: Stack(
            children: [
              SfCalendar(
                onSelectionChanged: selectionChanged,
                appointmentTextStyle: TextStyle(color: redColor),

                viewHeaderStyle: ViewHeaderStyle(
                    dateTextStyle: TextStyle(color: Colors.white),
                    dayTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    backgroundColor: redColor),
                viewNavigationMode: ViewNavigationMode.none,
                showCurrentTimeIndicator: false,
                allowViewNavigation: false,
                showDatePickerButton: true,
                maxDate: DateTime.now(),
                selectionDecoration: BoxDecoration(
                  // color: Colors.transparent,
                  border: Border.all(color: redColor, width: 2),
                  shape: BoxShape.rectangle,
                ),
                firstDayOfWeek: 1,
                todayTextStyle: TextStyle(color: redColor),
                headerStyle: CalendarHeaderStyle(
                  textStyle: GoogleFonts.raleway(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  backgroundColor: redColor,
                ),
                // blackoutDatesTextStyle: const TextStyle(color: Colors.orangeAccent),
                headerHeight: 150,
                todayHighlightColor: backgroundRefugee,
                cellBorderColor: redColor,
                view: CalendarView.month,
              ),

            ],
          )),
    );
  }
}