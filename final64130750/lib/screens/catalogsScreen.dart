import 'package:final_app/constants/api.dart';
import 'package:final_app/screens/bookingScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogsScreen extends StatefulWidget {
  @override
  _CatalogsScreenState createState() => _CatalogsScreenState();
}

class _CatalogsScreenState extends State<CatalogsScreen> {
  List<dynamic> cars = [];

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    final response = await http.get(Uri.parse('$apiEndpoint/car.php'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        cars = json.decode(response.body);
      });
    } else {
      throw Exception('การดึงข้อมูลรถล้มเหลว');
    }
  }

  void searchCarsBySize() {
    final List<dynamic> filteredCars = cars.where((car) {
      return car['cSize'] ==
          'ขนาดที่ต้องการค้นหา'; 
    }).toList();

    setState(() {
      cars = filteredCars;
    });
  }

  void searchCarsByBrand() {
    final List<dynamic> filteredCars = cars.where((car) {
      return car['cBrand'] ==
          'แบรนด์ที่ต้องการค้นหา';
    }).toList();

    setState(() {
      cars = filteredCars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบจองรถ'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'ขนาด') {
                searchCarsBySize();
              } else if (value == 'แบรนด์') {
                searchCarsByBrand();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'ขนาด',
                child: Text('ค้นหารถตามขนาด'),
              ),
              const PopupMenuItem<String>(
                value: 'แบรนด์',
                child: Text('ค้นหารถตามแบรนด์'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      cars[index]['cImage'],
                      height: 200,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        cars[index]['cName'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('ประเภท: ${cars[index]['cBrand']}'),
                        Text('ขนาด: ${cars[index]['cType']}'),
                        Text('จำนวนผู้โดยสาร: ${cars[index]['cPassengers']}'),
                        Text('ราคา: ${cars[index]['cPrice']} บาท'),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingScreen(car: cars[index]),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            child: Text('จองรถ'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
