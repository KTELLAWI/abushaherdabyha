import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../models/index.dart'
    show AppModel, CartModel, ProductWishListModel, User, UserModel;

class _DateTimePickerConst {
  static const double defaultPickerSheetHeight = 216.0;
}

class DateTimePicker extends StatefulWidget {
  final DateTime? initDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? labelText;
  final Function(DateTime datetime) onChanged;
  final String dateFormat;
  final String timeFormat;

  final String? hintText;
  final TextStyle? hintTextStyle;
  final InputBorder? border;
  final String text;
  final InputDecoration? inputDecoration;

  const DateTimePicker({
    Key? key,
    this.initDate,
    this.minimumDate,
    this.maximumDate,
    // this.showHintText = false,
    this.hintText,
    this.hintTextStyle,
    this.labelText,
    this.text = ' اختر تاريخ ',
    this.dateFormat = DateTimeFormatConstants.ddMMMMyyyy,
    this.timeFormat = DateTimeFormatConstants.timeHHmmFormatEN,
    this.border,
    this.inputDecoration,
    required this.onChanged,
    bool? isEnabled,
    
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final TextEditingController textController = TextEditingController();
  late final DateFormat dateFormat;
  late final DateFormat timeFormat;
  DateTime? _currentDateTime;

  @override
  void initState() {
    super.initState();
    _currentDateTime = widget.initDate;
    dateFormat = DateFormat(widget.dateFormat);
    timeFormat = DateFormat(widget.timeFormat);
    if (_currentDateTime != null) {
      localChange(_currentDateTime);
    } else {
      textController.text = widget.text;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _onPickingDate() async {
    // if (!isAndroid) {
    //   return _showDialogSelectDate();
    // } else {
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: _DateTimePickerConst.defaultPickerSheetHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color:Provider.of<AppModel>(context).darkTheme? Colors.black:Colors.white,
            ),
            child: CupertinoDatePicker(
              onDateTimeChanged: localChange,
              initialDateTime: _currentDateTime,
              minimumDate: widget.minimumDate,
              maximumDate: widget.maximumDate,
             // maximumYear: 2022,
              use24hFormat: false,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.date,
            ),
          );
        },
      );
   // }
  }

  // Future<void> _showDialogSelectDate() {
  //   return showDatePicker(
  //     context: context,
  //     initialDate: widget.initDate ?? DateTime.now(),
  //     firstDate: widget.minimumDate ?? DateTime(1960),
  //     lastDate:
  //         widget.maximumDate ?? DateTime.now().add(const Duration(days: 100)),
  //   )
  //   .then((value) {
  //     if (value == null) return;
  //     final datePicked = value;
  //     showTimePicker(
  //       context: context,
  //       initialTime: const TimeOfDay(hour: 0, minute: 0),
  //       cancelText: S.of(context).cancel,
  //       confirmText: S.of(context).confirm,
  //     )
  //     .then((value) {
  //       if (value == null) return;
  //       //final datePicked = value;
  //       final dateFinal = datePicked.add(Duration(
  //         hours: value.hour,
  //         minutes: value.minute,
  //       ));
  //       localChange(dateFinal);
  //     });
  //   });
  // }

  void localChange(DateTime? dateTime) {
    EasyDebounce.debounce(
        'delivery_date_picker', const Duration(milliseconds: 500), () {
      if (dateTime == null) {
        textController.text = widget.text;
        return;
      }
      _currentDateTime = dateTime;
      textController.text =  '${dateFormat.format(dateTime)} ';
        
    widget.onChanged.call(dateTime);
    });
  }
//${timeFormat.format(dateTime)}
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children:[
         TextField(
          style: TextStyle(fontSize: 14, height: 1.5),
      readOnly: true,
      controller: textController,
      onTap: _onPickingDate,
      decoration: widget.inputDecoration ??
          InputDecoration(
            //labelText: widget.labelText,
            //labelStyle: const TextStyle(fontSize: 13),
            hintText:' اختر تاريخ ',// widget.hintText,
            hintStyle: const TextStyle(fontSize: 13),//widget.hintTextStyle,
            border: widget.border,
            prefixIcon: const Icon(CupertinoIcons.calendar),
            suffixText: 'تغيير',
          ),
    ),
  //}
      ]
    ) ; 
}
}
