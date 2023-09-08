import 'package:final_app/screens/signInScreen.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://w0.peakpx.com/wallpaper/184/473/HD-wallpaper-home-with-trista-929-design-new-pixel-art-trista-hogue.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profile_image.jpg'),
                radius: 40,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(
                    'ID : 64130750',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Name : พลวัฒน์ เหลือแก้ว',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Phone : 0959941431',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => login(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                primary: Colors.grey, 
              ),
              child: Text('login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => login(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                primary: Colors.grey,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
