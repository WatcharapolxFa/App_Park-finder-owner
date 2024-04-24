import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

class SelectWeekDays extends StatefulWidget {
  final List<bool> selectedDays;
  final void Function(List<bool> selectedDays) onSelectedDaysChanged;

  const SelectWeekDays({
    Key? key,
    required this.selectedDays,
    required this.onSelectedDaysChanged,
  }) : super(key: key);

  @override
  SelectWeekDaysState createState() => SelectWeekDaysState();
}

class SelectWeekDaysState extends State<SelectWeekDays> {
  late List<bool> _selectedDays;
  final List<String> _daysOfWeek = [
    "วันจันทร์",
    "วันอังคาร",
    "วันพุธ",
    "วันพฤหัสบดี",
    "วันศุกร์",
    "วันเสาร์",
    "วันอาทิตย์",
  ];
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _selectedDays = List<bool>.from(widget.selectedDays);
  }

  String _getSelectedDays() {
    List<String> selectedDays = [];
    for (int i = 0; i < _daysOfWeek.length; i++) {
      if (_selectedDays[i]) {
        selectedDays.add(_daysOfWeek[i]);
      }
    }
    return selectedDays.join(', ');
  }

  void showSelectWeekDays(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // สร้างสำเนาของ _selectedDays เพื่อใช้ใน dialog
        List<bool> localSelectedDays = List<bool>.from(_selectedDays);

        return StatefulBuilder(
          // ใช้ StatefulBuilder เพื่อจัดการ state ภายใน AlertDialog
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('เลือกวันที่เปิดทำการ'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _daysOfWeek.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      title: Text(_daysOfWeek[index]),
                      value: localSelectedDays[index],
                      onChanged: (bool? value) {
                        setDialogState(() {
                          // ใช้ setDialogState แทน setState
                          localSelectedDays[index] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() {
                      // เมื่อกด OK, อัปเดต state ของ widget นอก dialog
                      _selectedDays = List<bool>.from(localSelectedDays);
                    });
                    widget.onSelectedDaysChanged(_selectedDays);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(
                const BorderSide(width: 1, color: AppColor.appPrimaryColor),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(10),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () => showSelectWeekDays(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.calendar_today,
                    size: 24.0, color: AppColor.appPrimaryColor),
                Text(
                  _getSelectedDays().isNotEmpty
                      ? _getSelectedDays()
                      : 'เลือกวันที่เปิดทำการ',
                  style: const TextStyle(color: AppColor.appPrimaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
