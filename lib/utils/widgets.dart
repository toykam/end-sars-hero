import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar getAppBar(BuildContext context, {title, subtitle, height = 70.0, bool showProfile = true}) {
  return AppBar(
    leading: CircleAvatar(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/'),
        child: Image.asset('assets/images/end_sars_logo.png', height: 20, width: 20,)
      ),
      backgroundColor: Colors.transparent,
    ),
    centerTitle: true,
    title: Hero(
      tag: 'app_name',
      child: Material(
        color: Colors.transparent,
        child: Text("$title", style: GoogleFonts.adamina(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
        ),),
    ),
    actions: [
      if (showProfile)
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => Navigator.of(context).pushNamed('profile'),
        )
    ],
    bottom: PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, height),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Center(
          child: Hero(
            tag: 'notice',
            child: Material(
              color: Colors.transparent,
              child: Text("$subtitle", style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                  fontSize: 16
              ),),
            ),
          ),
        ),
      ),
    ),
  );
}