import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_heros_endsars/providers/auth_provider.dart';
import 'package:lost_heros_endsars/utils/styles.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (context, value, child) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: FadeInUp(
                        child: Image.asset('assets/images/end_sars_logo.png', height: 80, width: 80,),
                      )
                    ),
                  ),
                  SizedBox(height: 1,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Hero(
                      tag: 'app_name',
                      child: Material(
                        color: Colors.transparent,
                        child: Text("EndSARS Lost Heros", style: GoogleFonts.adamina(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w900
                        ),
                      ),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: FadeInUp(
                      child: TextFormField(
                        initialValue: value.getEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: getInputDecoration(hintText: "Email"),
                        onChanged: (String name) {
                          value.setEmail = name;
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: FadeInUp(
                      child: TextFormField(
                        initialValue: value.getPassword,
                        decoration: getInputDecoration(hintText: "Password"),
                        onChanged: (String name) {
                          value.setPassword = name;
                        },
                        obscureText: value.getHidePassword,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => value.setHidePassword = !value.getHidePassword,
                          child: FadeInLeft(child: Text("${value.getHidePassword? 'Show Password' : 'Hide Password'}"))
                        ),
                        FadeInRight(
                          child: OutlineButton(
                            child: Text('Login'),
                            onPressed: () => value.login(context),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: InkWell(
                        onTap: () => Navigator.pushReplacementNamed(context, 'register'),
                        child: FadeInLeft(child: Text("Don't have an account? Register now"))
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
