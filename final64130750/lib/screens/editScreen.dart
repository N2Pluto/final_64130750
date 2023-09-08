import 'package:final_app/constants/api.dart';
import 'package:final_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EditScreen extends StatefulWidget {
  final String uDateFrom;
  final String uDateTo;
  final Function(Map<String, String>) onSave;
  final VoidCallback onCancel;

  EditScreen({
    required this.uDateFrom,
    required this.uDateTo,
    required this.onSave,
    required this.onCancel,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController uDateFromController = TextEditingController();
  TextEditingController uDateToController = TextEditingController();

  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print('Selected Date From: $formattedDate');
      setState(() {
        uDateFromController.text = formattedDate;
      });
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print('Selected Date To: $formattedDate');
      setState(() {
        uDateToController.text = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    uDateFromController.text = widget.uDateFrom;
    uDateToController.text = widget.uDateTo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectDateFrom(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: uDateFromController,
                  decoration:
                      InputDecoration(labelText: 'เลือกวันเริ่มต้นใหม่'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDateTo(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: uDateToController,
                  decoration: InputDecoration(
                    labelText: 'เลือกวันสิ้นสุดใหม่',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newDateFrom =
                    DateTime.parse(uDateFromController.text).toLocal();
                final newDateTo =
                    DateTime.parse(uDateToController.text).toLocal();

                final formattedDateFrom =
                    DateFormat('yyyy-MM-dd').format(newDateFrom);
                final formattedDateTo =
                    DateFormat('yyyy-MM-dd').format(newDateTo);

                print('New Date From: $formattedDateFrom');
                print('New Date To: $formattedDateTo');

                widget.onSave({
                  'uDateFrom': formattedDateFrom,
                  'uDateTo': formattedDateTo
                });

                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.grey,
              ),
              child: Text('บันทึก'),
            ),
            ElevatedButton(
              onPressed: () async {
                final bool shouldDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ยืนยันการลบ'),
                      content:
                          Text('คุณแน่ใจหรือไม่ว่าต้องการลบการจองทั้งหมด?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('ลบ'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldDelete == true) {
                  final uID = await User.getUID();
                  final response = await http.post(
                    Uri.parse('$apiEndpoint/delete_booking.php'),
                    body: {'uID': uID},
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบการจองทั้งหมดเรียบร้อย'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบการจองทั้งหมดล้มเหลว'),
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                primary: const Color.fromARGB(255, 239, 21, 21),
              ),
              child: Text('ลบการจองทั้งหมด'),
            ),
          ],
        ),
      ),
    );
  }
}
