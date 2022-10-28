
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/settings_vol_info.dart';

int currentAgeVolunteer = 0;
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

class DatePicker extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
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
      print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
      print(DateFormat('yyyy').format(details.date!));
      print(DateFormat('MMMM').format(DateTime.now()));
      month.forEach((element) {
        if(element == DateFormat('MMMM').format(DateTime.now())){
          currentDate=month.indexOf(element)+1;

        }
        if(element == DateFormat('MMMM').format(details.date!)){
         bDate = month.indexOf(element)+1;

        }});
        print(currentDate);
        print(bDate);
        if(bDate<currentDate){
          currentAgeVolunteer = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!));
          print(currentAgeVolunteer);
        }
        else if(bDate>currentDate){
          currentAgeVolunteer = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!))-1;
              // - DateFormat('yyyy').format(details.date!);
        }
        else if(bDate==currentDate){
          if(int.parse(DateFormat('dd').format(DateTime.now())) > int.parse(DateFormat('dd').format(details.date!))){
            currentAgeVolunteer = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!));
          } else{
            currentAgeVolunteer = int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(DateFormat('yyyy').format(details.date!))-1;
          }
        }

      dateOfBirth = text;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingsVol()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 30, color: background,),
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsVol()));
        },
      ),
        body: Stack(
          children: [
            SfCalendar(
              onSelectionChanged: selectionChanged,
              appointmentTextStyle: TextStyle(color: blueColor),
          // headerStyle: CalendarHeaderStyle(
          //     textAlign: TextAlign.center,
          //     backgroundColor: Color(0xFF7fcd91),
          //     textStyle: TextStyle(
          //         fontSize: 25,
          //         fontStyle: FontStyle.normal,
          //         letterSpacing: 5,
          //         color: Color(0xFFff5eaea),
          //         fontWeight: FontWeight.w500)),

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
                // color: Colors.transparent,
                border: Border.all(color: blueColor, width: 2),
                shape: BoxShape.rectangle,
              ),
              firstDayOfWeek: 1,
              todayTextStyle: TextStyle(color: blueColor),
              headerStyle: CalendarHeaderStyle(
                textStyle: GoogleFonts.raleway(
                  fontSize: 22,
                  color: Colors.white,
                ),
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