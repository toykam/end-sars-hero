import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void _moveToNextPage(BuildContext context) async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToNextPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: ZoomIn(
                  child: Image.asset('assets/images/end_sars_logo.png', height: 150, width: 150,),
                ),
              ),
            ),
            SizedBox(height: 15,),
            FadeIn(
              child: Hero(
                tag: 'app_name',
                child: Material(
                  color: Colors.transparent,
                  child: Text("EndSARS Heroes", style: GoogleFonts.adamina(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                  ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
