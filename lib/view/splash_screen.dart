import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen() ));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/splash_pic.jpg",
            fit: BoxFit.cover,
          height: media.height*0.5,),
          const SizedBox(height:4 ,),
           Text("TOP HEAD LINES",
             style: GoogleFonts.anton(letterSpacing: .6,
                 color: Colors.grey.shade700),),
          const SizedBox(height:20 ,),
          const SpinKitChasingDots(
            color: Colors.blue,
            size: 40,
          )
        ],
      ),
    );
  }
}


//4f92a27b662a4da49d35bcf044549228
