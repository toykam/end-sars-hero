import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_heros_endsars/providers/add_to_story_provider.dart';
import 'package:lost_heros_endsars/utils/styles.dart';
import 'package:provider/provider.dart';

class AddToStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Hero(
            tag: 'app_name',
            child: Material(
              color: Colors.transparent,
              child: Text("EndSARS Police Victim", style: GoogleFonts.adamina(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
              ),),
          ),
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 70),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Center(
                child: Hero(
                  tag: 'notice',
                  child: Material(
                    color: Colors.transparent,
                    child: Text("You to verify that you are aware of this event, Please kind say what you know about this event...", style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 16
                    ),),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Consumer<AddToStoryProvider>(
          builder: (context, value, child) {
            value.setBuildContext = context;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: TextFormField(
                        initialValue: "",
                        decoration: getInputDecoration(hintText: "Write story here"),
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        maxLength: 100000,
                        onChanged: (String story) {
                          value.setStory = story;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: TextFormField(
                        initialValue: value.getLocation,
                        decoration: getInputDecoration(hintText: "Location of incidence"),
                        onChanged: (String name) {
                          value.setLocation = name;
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: TextFormField(
                        initialValue: value.getOfficerInCharge,
                        decoration: getInputDecoration(hintText: "Police Officer in Charge (not compulsory)"),
                        onChanged: (String name) {
                          value.setOfficerInCharge = name;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: TextFormField(
                        initialValue: value.getDivision,
                        decoration: getInputDecoration(hintText: "Police Division (not compulsory)"),
                        onChanged: (String name) {
                          value.setDivision = name;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: OutlineButton(
                        child: Text("Submit Story", style: GoogleFonts.acme(
                          color: Colors.black,
                        ),),
                        color: Colors.black,
                        onPressed: () => value.addToStories(context),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
