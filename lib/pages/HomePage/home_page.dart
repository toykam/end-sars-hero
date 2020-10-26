import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart' as stg;
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lost_heros_endsars/pages/HomePage/lost_hero_detail.dart';
import 'package:lost_heros_endsars/providers/home_page_provider.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';
import 'package:lost_heros_endsars/utils/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, subtitle: "Here are our heroes, that have experienced police brutality, Always remember them in your prayers...", title: "EndSARS Hero"),
      body: Consumer<HomePageProvider>(
        builder: (context, value, child) {
          value.setBuildContext = context;
          return stg.AnimationLimiter(
            child: WatchBoxBuilder(
              box: Hive.box(victimBox),
              builder: (context, box) {
                var victims = box.get(victim_list) == null ? [] : box.get(victim_list);
                return GridView.count(
                    primary: false,
                    crossAxisCount: 2,
                    children: [
                      ...victims.map((index) {
                        return stg.AnimationConfiguration.staggeredGrid(
                          position: int.parse(index['id']),
                          duration: const Duration(milliseconds: 375),
                          columnCount: 20,
                          child: stg.ScaleAnimation(
                            child: FadeIn(
                              child: InkWell(
                                onTap: () => Navigator.of(context).pushNamed('view_hero_detail', arguments: ({'victimId':index['id'], 'userId': index['user_id']})),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 2, spreadRadius: 1
                                        )
                                      ]
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0, right: 0, bottom: 0, left: 0,
                                        child: Hero(
                                          tag: "background_${index['id']}",
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                image: DecorationImage(
                                                  // image: AssetImage('assets/images/endsars.jpg'),
                                                  // image: NetworkImage('$baseUrl../victim/${index['image']}'),
                                                    image: CachedNetworkImageProvider(baseUrl+'victim/${index['image']}'),
                                                    fit: BoxFit.cover
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                                            ),
                                            height: 150, width: 150,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 0, right: 0, bottom: 0, left: 0,
                                          child: Hero(
                                            tag: "overlay_background_${index['id']}",
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                color: Colors.black.withOpacity(0.4),
                                              ),
                                            ),
                                          )
                                      ),
                                      Positioned(
                                        right: 0, bottom: 0, left: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          color: Colors.black,
                                          child: Hero(
                                            tag: "text_${index['id']}",
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Material(
                                                  color: Colors.transparent,
                                                  child: Text("${index['victim_name']}", style: TextStyle(
                                                      color: Colors.red
                                                  ),),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: Text("${index['status']}", style: TextStyle(
                                                      color: Colors.red, fontWeight: FontWeight.bold
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      ),
                      if (value.getFallenHero.length == 0 && value.getActionState.actionStatus == ActionStatus.Loaded)
                        ...[
                          Container(
                            color: Colors.blue.withOpacity(0.4),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text("No Hero is found!, be the first to add a hero!!!"),
                            ),
                          )
                        ],
                      if (value.getFallenHero.length == 0 && value.getActionState.actionStatus == ActionStatus.Loading)
                        ...[
                          Container(
                            color: Colors.blue.withOpacity(0.4),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text("Loading Our Fallen Hero"),
                            ),
                          )
                        ],
                      if (value.getFallenHero.length == 0 && value.getActionState.actionStatus == ActionStatus.ErrorOccurred)
                        ...[
                          Container(
                            color: Colors.red.withOpacity(0.4),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Text("An error occurred, Please try again later"),
                          )
                        ]
                    ]
                );
              },
            ),
          );
        },
      ),
      persistentFooterButtons: [
        Consumer<HomePageProvider>(
          builder: (context, value, child) {
            return OutlineButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Refresh", style: TextStyle(
                      color: Colors.black
                  ),),
                  SizedBox(width: 10,),
                  Icon(Icons.refresh, color: Colors.black,)
                ],
              ),
              onPressed: () => value.reload(),
            );
          },
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pushNamed('add_new_hero'),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Add New Hero", style: TextStyle(
                color: Colors.white
              ),),
              SizedBox(width: 10,),
              Icon(Icons.add, color: Colors.white,)
            ],
          ),
        )
      ],
    );
  }
}
