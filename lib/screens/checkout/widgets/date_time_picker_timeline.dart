
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';



class TimeLine extends StatefulWidget {
  TimeLine({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();

  void executeAfterBuild() {
    _controller.animateToSelection();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedValue);
    WidgetsBinding.instance!.addPostFrameCallback((_) => executeAfterBuild());
    return 
    // Scaffold(
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.replay),
    //     onPressed: () {
    //       _controller.animateToSelection();
    //     },
    //   ),
    //     appBar: AppBar(
    //       title: Text(widget.title!),
    //     ),
    //     body:
         Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.blueGrey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("You Selected:"),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text(_selectedValue.toString()),
              Padding(
                padding: EdgeInsets.all(20),
              ),
              
              Row(
                children:[

                    InkWell(
                onTap:(){
                    _controller.animateToDate(DateTime.now(),);

                },
                child:Text('back to ')
              ),        
                    Expanded(
                        child:   Container(
                child: DatePicker(
                  DateTime.now(),
                  width: 60,
                  height: 80,
                  locale : "ar_DZ",
                  daysCount:30,
                  controller: _controller,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.black,
                  selectedTextColor: Colors.white,
                  inactiveDates: [
                    // DateTime.now().add(Duration(days: 3)),
                    // DateTime.now().add(Duration(days: 4)),
                    // DateTime.now().add(Duration(days: 7))
                  ],
                  onDateChange: (date) {
                    // New date selected
                    setState(() {
                      _selectedValue = date;
                    });
                  },
                ),
              ),
                    )
                ]
              )
           
            ],
          ),
        );
        //);
  }
}