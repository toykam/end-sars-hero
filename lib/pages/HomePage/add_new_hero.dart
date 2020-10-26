import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_heros_endsars/providers/add_new_hero_provider.dart';
import 'package:lost_heros_endsars/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class AddNewHeroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          tag: 'app_name',
          child: Material(
            color: Colors.transparent,
            child: Text("EndSARS Our Heros", style: GoogleFonts.adamina(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            ),),
        ),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.black,
            child: Center(
              child: Hero(
                tag: 'notice',
                child: Material(
                  color: Colors.transparent,
                  child: Text("Please make sure the information you are providing here is valid.\nNote that information provided here will undergo verification before it goes public", style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 16
                  ),),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<AddNewHeroProvider>(
        builder: (context, value, child) {
          return Container(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroName,
                      decoration: getInputDecoration(hintText: "Case Title"),
                      onChanged: (String name) {
                        value.setHeroName = name;
                      },
                    ),
                  ),
                  /// Victim Name
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroName,
                      decoration: getInputDecoration(hintText: "Victim Name"),
                      onChanged: (String name) {
                        value.setHeroName = name;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroBio,
                      decoration: getInputDecoration(hintText: "Victim Bio"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      onChanged: (String name) {
                        value.setHeroBio = name;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroStory,
                      decoration: getInputDecoration(hintText: "Victim Case Story"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      onChanged: (String name) {
                        value.setHeroStory = name;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroIncidenceLocation,
                      decoration: getInputDecoration(hintText: "Location of incidence"),
                      onChanged: (String name) {
                        value.setHeroIncidenceLocation = name;
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: SmartSelect.single(
                      value: value.getHeroState,
                      onChange: (state) {
                        value.setHeroState = state.value;
                      },
                      choiceItems: [
                        S2Choice(value: 'null', title: ''),
                        S2Choice(value: 'dead', title: 'Killed and Dead'),
                        S2Choice(value: 'injured', title: 'Severely Brutalized/Injured'),
                        S2Choice(value: 'alive', title: 'Alive'),
                      ],
                      title: "Victim state after incidence",
                      modalType: S2ModalType.bottomSheet,
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroPoliceInCharge,
                      decoration: getInputDecoration(hintText: "Culprit (who did it? not compulsory)"),
                      onChanged: (String name) {
                        value.setHeroPoliceInCharge = name;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      initialValue: value.getHeroPoliceDivision,
                      decoration: getInputDecoration(hintText: "Where to find culprit (not compulsory)"),
                      onChanged: (String name) {
                        value.setHeroPoliceDivision = name;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: FlatButton(
                      onPressed: () => value.selectImage(context),
                      child: Row(
                        children: [
                          Text("${value.getImageFile == null ? 'Add Victim' : 'Change'} Picture"),
                          SizedBox(width: 10,),
                          Icon(Icons.image)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    height: 150, width: MediaQuery.of(context).size.width,
                    child: value.displayImage,
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: OutlineButton(
                      onPressed: () => value.confirmSubmission(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add Victim"),
                          SizedBox(width: 10,),
                          Icon(Icons.add)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
