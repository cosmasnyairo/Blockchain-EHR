import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style:
                  GoogleFonts.montserrat(color: Colors.black54, fontSize: 20),
            ),
            Text(
              'Kenneth Erickson',
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MaterialButton(
                height: 50,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'ADD RECORD',
                  style: GoogleFonts.montserrat(),
                ),
              ),
              SizedBox(width: 50),
              MaterialButton(
                height: 50,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'SHARE RECORDS',
                  style: GoogleFonts.montserrat(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
