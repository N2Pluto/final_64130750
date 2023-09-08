import 'package:flutter/material.dart';
import 'package:final_app/constants/api.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_app/models/user.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final formKey = GlobalKey<FormState>();

  TextEditingController uPassword = TextEditingController();
  TextEditingController uTelephone = TextEditingController();

  int incorrectAttempts = 0;

  Future<void> sign_in() async {
    String url = "$apiEndpoint/login.php";

    try {
      final response = await http.post(Uri.parse(url), body: {
        'uPassword': uPassword.text,
        'uTelephone': uTelephone.text,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data == "Error") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
            ),
          );

          incorrectAttempts++;
          print('Incorrect login attempts: $incorrectAttempts');

          if (incorrectAttempts >= 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('คุณกรอกข้อมูลผิดติดต่อกัน 3 ครั้ง'),
              ),
            );
          }
        } else {
          incorrectAttempts = 0;
          String uID = data['uID'].toString(); 
          await User.setUID(uID);
          print(uID);
          Navigator.pushNamed(context, 'homeScreen');
        }
      } else {
        print("Server returned status code: ${response.statusCode}");
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 172, 171, 171),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            shrinkWrap: true,
            children: [
              SizedBox(height: 60),
              Center(
                child: Image.network(
                  'https://cdn.pic.in.th/file/picinth/peakpx-removebg-preview.png',
                  height: 400,
                  width: 300,
                ), 
              ),
              SizedBox(height: 60),
              _buildTextField(
                controller: uTelephone,
                hint: 'Phone number',
                icon: Icons.phone_android_outlined,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: uPassword,
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff7C7C7C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  side: BorderSide(
                    color: Color(0xff7C7C7C),
                    width: 2,
                  ),
                ),
                onPressed: () {
                  bool valid = formKey.currentState!.validate();
                  if (valid) {
                    sign_in();
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      style: TextStyle(color: const Color.fromARGB(255, 90, 88, 88)),
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: const Color.fromARGB(
                255, 75, 76, 77),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
