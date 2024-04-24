import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

class ParkingSlotCounter extends StatefulWidget {
  final Function(int) onCounterChanged;
  const ParkingSlotCounter({super.key, required this.onCounterChanged});

  @override
  ParkingSlotCounterState createState() => ParkingSlotCounterState();
}

class ParkingSlotCounterState extends State<ParkingSlotCounter> {
  int _counter = 1; // เริ่มต้นด้วยรถ 1 คัน

 void _incrementCounter() {
    if (_counter < 3) { // จำกัดจำนวนสูงสุดที่ 3
      setState(() {
        _counter++;
        widget.onCounterChanged(_counter); 
      });
    }
  }

  void _decrementCounter() {
    if (_counter > 1) { // จำกัดจำนวนต่ำสุดที่ 1
      setState(() {
        _counter--;
        widget.onCounterChanged(_counter); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('จำนวนรถที่จอดได้: '),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove,
                  color: _counter > 1 ? AppColor.appPrimaryColor : Colors.grey),
              onPressed: _counter > 1 ? _decrementCounter : null,
            ),
            Text('$_counter',
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            IconButton(
              icon: const Icon(Icons.add, color: AppColor.appPrimaryColor),
              onPressed: _incrementCounter,
            ),
          ],
        ),
      ],
    );
  }
}
