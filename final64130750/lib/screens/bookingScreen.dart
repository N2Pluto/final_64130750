import 'package:final_app/constants/api.dart';
import 'package:final_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final dynamic car;

  BookingScreen({required this.car});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? uDateFrom;
  DateTime? uDateTo;

  Future<void> _selectUDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != uDateFrom) {
      setState(() {
        uDateFrom = picked;
      });
    }
  }

  Future<void> _selectUDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != uDateTo) {
      setState(() {
        uDateTo = picked;
      });
    }
  }

  Future<void> _submitBooking(DateTime uDateFrom, DateTime uDateTo) async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/booking.php'),
      body: {
        'cID': widget.car['cID'],
        'uDateFrom': uDateFrom.toLocal().toString(),
        'uDateTo': uDateTo.toLocal().toString(),
        'uID': await User.getUID(),
      },
    );

    if (response.statusCode == 200) {
      // สำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกข้อมูลการจองรถเรียบร้อย'),
        ),
      );
    } else {
      // ไม่สำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('การบันทึกข้อมูลการจองรถล้มเหลว'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จองรถ'),
      ),
      body: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('ข้อมูลรถที่จอง:'),
              Image.network(
                widget.car['cImage'],
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
              Text('ชื่อ: ${widget.car['cName']}'),
              Text('ประเภท: ${widget.car['cBrand']}'),
              Text('ขนาด: ${widget.car['cType']}'),
              Text('ราคา: ${widget.car['cPrice']} บาท'),
              SizedBox(height: 20),
              Text(
                'วันเวลาเริ่มต้น:',
                style: TextStyle(
                  color: Color(0xff53B175),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectUDateFrom(context);
                },
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
                child: Text(
                  uDateFrom != null
                      ? uDateFrom!.toLocal().toString().split(' ')[0]
                      : 'เลือกวันเริ่มต้น',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'วันเวลาสิ้นสุด:',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 5, 5),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectUDateTo(context);
                },
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
                child: Text(
                  uDateTo != null
                      ? uDateTo!.toLocal().toString().split(' ')[0]
                      : 'เลือกวันสิ้นสุด',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (uDateFrom != null && uDateTo != null) {
                    _submitBooking(uDateFrom!, uDateTo!);

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('กรุณาเลือกวันเวลาเริ่มต้นและสิ้นสุด'),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
                child: Text('ยืนยันการจองรถ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
