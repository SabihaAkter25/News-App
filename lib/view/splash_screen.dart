import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainScreen() ));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: media.height,
            width: media.width,
            child: Image.asset(
              "images/splash_pic.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: media.height,
            width: media.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "TOP HEADLINES",
                style: GoogleFonts.anton(
                  letterSpacing: 2,
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Stay informed with the latest news from around the world.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 50),
              const SpinKitFadingCircle(
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }
}


//4f92a27b662a4da49d35bcf044549228
