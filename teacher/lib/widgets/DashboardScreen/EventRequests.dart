import 'package:flutter/material.dart';
import 'package:teacher/services/mysql_service.dart';
import 'package:http/http.dart' show get;
import 'package:teacher/widgets/ReportPDF/pdf_creator_screen.dart';
import '../../models/event.dart';
import '../../models/report.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class EventRequests extends StatefulWidget {
  const EventRequests({super.key});

  @override
  _EventRequestsState createState() => _EventRequestsState();
}

class _EventRequestsState extends State<EventRequests> {
  List<Event> _events = [];

  Future<void> _createPDF(String? eid) async {
    //Creates a new PDF document
    PdfDocument document = PdfDocument();
    var settings = ConnectionSettings(
      host: 'db4free.net',
      port: 3306,
      user: 'eventflowstudent',
      password: 'eventflow',
      db: 'eventflow',
    );
    var con =await MySqlConnection.connect(settings);
    Results result1 =
    await con.query('SELECT teacher.name AS teacherName, teacher.email AS teacherEmail, teacher.dept AS teacherDept,event.name AS event_name,event.interest AS event_interest, event.start AS event_start,event.end AS event_end,event.description AS event_description,event.status AS event_status, event.graduate AS event_graduate, event.image AS event_image,COUNT(participant.sid) AS participant_count,student.sid,student.name AS student_name,student.email AS student_email,student.dept AS student_dept,student.course AS student_course,COUNT(booking.vid) AS venue_count FROM event JOIN teacher ON event.tid = teacher.tid JOIN booking ON booking.eid = booking.eid LEFT JOIN participant ON event.eid = participant.eid LEFT JOIN student ON event.sid = student.sid WHERE event.eid =? GROUP BY teacher.name, teacher.email, teacher.dept, event.name, event.interest, event.start, event.end, event.description,event.status,event.graduate, event.image, student.sid, student.name, student.email,student.dept,student.course',[eid]);
    var result2 = await con.query(
        'update event set status="COMPLETED" where eid=?',
        [
          eid
        ]);
    con.close();
    try{
      Report report=Report.fromJson(result1.elementAt(0).fields);
    }
    on Exception catch (e){
      print(e);

    }
    Report report=Report.fromJson(result1.elementAt(0).fields);

//Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 50;
    //MySqlService().getReportDetails(eid).then((report) {
    //  _reports = report;
    //});
//Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;
    //Loads the image from base64 string
    //Loads the image from base64 string
    var url ='https://cis-india.org/Christuniversitylogocolour.jpg/image_preview';
    if(report.e_image!=null)
        url = report.e_image;
    var response = await get(Uri.parse(url));
    var data = response.bodyBytes;
    PdfBitmap image = PdfBitmap(data); //Draws the image to the PDF page
    page.graphics.drawImage(image, Rect.fromLTWH(0, 0, 490, 190));
    PdfBrush solidBrush = PdfSolidBrush(PdfColor(255,191,0));
    Rect bounds = Rect.fromLTWH(0, 210, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 16);

//Creates a text element to add the invoice number
    PdfTextElement element =
    PdfTextElement(text: report.e_name+' - '+report.e_graduate+' | '+report.e_interest, font: subHeadingFont);
    element.brush = PdfBrushes.darkMagenta;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(3, bounds.top + 8, 0, 0))!;

//Use 'intl' package for date format.
    String currentDate = 'DATE '+report.e_start + " - "+report.e_end;

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);
    Offset textPosition = Offset(
        graphics.clientSize.width - textSize.width - 10, result.bounds.top);


//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
            result.bounds.top) &
        Size(textSize.width + 2, 20));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
        text: 'Organiser - '+report.s_name,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 50))!;
    element = PdfTextElement(
        text: report.sid+' | '+report.s_email,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(15, result.bounds.bottom + 5, 0, 50))!;

    element = PdfTextElement(
        text: 'Teacher-In Charge - '+report.teacherName,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 14,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 50))!;
    if(report.tid!=null){
      element = PdfTextElement(
          text: 'NULL',
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
              style: PdfFontStyle.bold));
      element.brush = PdfBrushes.black;
      result = element.draw(
          page: page, bounds: Rect.fromLTWH(15, result.bounds.bottom + 5, 0, 50))!;
    }


    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 14);

    element = PdfTextElement(text: report.e_description, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, page.getClientSize().width, page.getClientSize().height), format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    if(report.participant_count==null){
      element = PdfTextElement(
          text: 'No of Participants - 0',
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
              style: PdfFontStyle.bold));}
    else{
      element = PdfTextElement(
          text: 'No of Participants - '+ (report.participant_count).toString(),
          font: timesRoman);}
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, page.getClientSize().width, page.getClientSize().height), format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    element = PdfTextElement(text: 'No of Venues - '+ (report.vcount).toString(), font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 8, page.getClientSize().width, page.getClientSize().height), format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
    element = PdfTextElement(text: 'EVENT IS CLOSED', font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
        ));
    element.brush = PdfBrushes.black;


    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 50))!;

    final directory = await getApplicationSupportDirectory();

//Get directory path
    final path = directory.path;
    List<int> bytes = await document.save();
//Create an empty file to write PDF data
    File file = File('$path/Output.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFilex.open('$path/Output.pdf');

//Dispose the document
    document.dispose();
  }

  @override
  void initState() {
    super.initState();
    MySqlService().getAllTeacherEvents().then((events) {
      setState(() {
        _events = events;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_events.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.red),
          centerTitle: true,
          title: const Text(
            'My Events',
            style: TextStyle(
              color: Colors.white,
            ),
          )
      ),
      body: Stack(
        children: _events
            .asMap()
            .entries
            .map(
              (entry) => _buildDismissibleCard(
            entry.value,
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildDismissibleCard(
      Event event,
      ) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      child: Card(
        color: const Color(0xffffffff),
        elevation: 50.0,
        margin: const EdgeInsets.all(15.0),
        child: Padding(
          padding: const EdgeInsets.all(5.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              event.image == null?
              Image.asset(
                'assets/images/comp.jpg',
                fit: BoxFit.cover,
                height: 300.0,
              ):Image.network(
                event.image ?? '',
                fit: BoxFit.cover,
                height: 300.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                        color: const Color(0xFF410909),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20.0, color: Color(0xff181818)),
                        const SizedBox(width: 8.0),
                        Text(
                          '${DateFormat('MMM dd, yyyy').format(DateTime.parse(event.start))} - ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event.end))}',
                          style: const TextStyle(
                              color: Color(0xff181818),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16.0, color: Color(0xff181818)),
                        const SizedBox(width: 8.0),
                        Text(
                          'Organizer: ${event.sid}',
                          style: const TextStyle(
                              color: Color(0xff181818),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.business, size: 16.0, color: Color(0xff181818)),
                        const SizedBox(width: 8.0),
                        Text(
                          'Department: ${event.interest} | ${event.graduate}',
                          style: const TextStyle(
                              color: Color(0xff181818),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    Text(
                      event.description,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        color: Colors.black,

                      ),
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black87,
                        primary: Colors.amber,
                        minimumSize: Size(88, 36),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      onPressed: () async{
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                            title: const Text('Information'),
                            content: const Text('The event is closed'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Open PDF'),
                                onPressed: () {
                                  _createPDF(event.eid);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                       // Report report= await MySqlService.getReportDetails(event.eid);
                        //Navigator.push(
                          //context,
                          //MaterialPageRoute(builder: (context) => Pdf()),
                        //);
                      },
                      child: Text('COMPLETE'),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
