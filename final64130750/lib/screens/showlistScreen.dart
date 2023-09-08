import 'package:final_app/screens/editScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/constants/api.dart';
import 'package:final_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> cars = [];
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final uID = await User.getUID();
    print('uID = : $uID');

    final bookingResponse = await http.post(
      Uri.parse('$apiEndpoint/get_bookings.php'),
      body: {'uID': uID},
    );

    if (bookingResponse.statusCode == 200) {
      final List<dynamic> bookingData = json.decode(bookingResponse.body);
      if (mounted) {
        setState(() {
          bookings = bookingData.cast<Map<String, dynamic>>();
          isDataFetched = true;
        });
      }
    } else {
      print('Failed to fetch bookings');
    }

    final carResponse = await http.get(Uri.parse('$apiEndpoint/car.php'));
    if (carResponse.statusCode == 200) {
      final List<dynamic> carData = json.decode(carResponse.body);
      if (mounted) {
        setState(() {
          cars = carData.cast<Map<String, dynamic>>();
        });
      }
    } else {
      throw Exception('Failed to fetch car data');
    }
  }

  Future<Map<String, dynamic>> fetchCarDetails(String cID) async {
    final carDetailsResponse = await http.get(
      Uri.parse('$apiEndpoint/car.php?cID=$cID'),
    );

    if (carDetailsResponse.statusCode == 200) {
      final List<dynamic> carDetailsData = json.decode(carDetailsResponse.body);
      if (carDetailsData.isNotEmpty) {
        return carDetailsData.first;
      }
    }
    return <String, dynamic>{};
  }

  Future<void> _updateBooking(
      String bID, String newDateFrom, String newDateTo) async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/update_booking.php'),
      body: {
        'bID': bID,
        'uDateFrom': newDateFrom,
        'uDateTo': newDateTo,
      },
    );

    if (response.statusCode == 200) {
      print('Booking updated successfully');
    } else {
      print('Failed to update booking');
    }
  }

  void handleSave(String cID, String newDateFrom, String newDateTo) {
    updateBookingDate(cID, newDateFrom, newDateTo);
  }

  void updateBookingDate(String cID, String newDateFrom, String newDateTo) {
    final index = bookings.indexWhere((booking) => booking['cID'] == cID);
    if (index != -1) {
      if (mounted) {
        setState(() {
          bookings[index]['uDateFrom'] = newDateFrom;
          bookings[index]['uDateTo'] = newDateTo;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Booking List'),
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          key: UniqueKey(),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final bID = booking['bID'].toString();
            final cID = booking['cID'].toString();

            final matchingCars =
                cars.where((car) => car['cID'].toString() == cID).toList();

            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        uDateFrom: booking['uDateFrom'] ?? '',
                        uDateTo: booking['uDateTo'] ?? '',
                        onSave: (editedData) async {
                          final newDateFrom = editedData['uDateFrom'] ?? '';
                          final newDateTo = editedData['uDateTo'] ?? '';
                          await _updateBooking(bID, newDateFrom, newDateTo);
                          handleSave(cID, newDateFrom, newDateTo);

                          setState(() {
                            booking['uDateFrom'] = newDateFrom;
                            booking['uDateTo'] = newDateTo;
                          });
                        },
                        onCancel: () {},
                      ),
                    ),
                  );

                  if (result != null) {
                    final newDateFrom = result['uDateFrom'];
                    final newDateTo = result['uDateTo'];
                    await _updateBooking(bID, newDateFrom, newDateTo);
                    updateBookingDate(cID, newDateFrom, newDateTo);
                    handleSave(cID, newDateFrom, newDateTo);
                  }
                },
                leading: matchingCars.isNotEmpty &&
                        matchingCars[0]['cImage'] != null
                    ? Image.network(matchingCars[0]['cImage'].toString())
                    : Icon(Icons.image_not_supported),
                title: Text(
                  'Car: ${matchingCars.isNotEmpty ? matchingCars[0]['cName'].toString() : 'N/A'}',
                ),
                subtitle: Text(
                  matchingCars.isNotEmpty
                      ? 'Type: ${matchingCars[0]['cBrand']?.toString() ?? 'N/A'}\n'
                          'Size: ${matchingCars[0]['cType']?.toString() ?? 'N/A'}\n'
                          'Passengers: ${matchingCars[0]['cPassengers']?.toString() ?? 'N/A'}\n'
                          'Price: ${matchingCars[0]['cPrice']?.toString() ?? 'N/A'} บาท\n'
                          'Start Date: ${booking['uDateFrom']?.toString() ?? 'N/A'}\n'
                          'End Date: ${booking['uDateTo']?.toString() ?? 'N/A'}'
                      : 'N/A',
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
