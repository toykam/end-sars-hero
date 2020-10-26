import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_heros_endsars/providers/view_hero_detail_provider.dart';
import 'package:lost_heros_endsars/utils/base_provider.dart';
import 'package:lost_heros_endsars/utils/end_points.dart';
import 'package:lost_heros_endsars/utils/useful_functions.dart';
import 'package:provider/provider.dart';

class FallenHeroDetail extends StatelessWidget {
  TextStyle _tabBarStyle = TextStyle(
    color: Colors.black
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ViewHeroDetailProvider>(
        builder: (context, value, child) {
          value.setBuildContext = context;
          print(value.getHeroDetail);
          print(value.userId);
          return Scaffold(
            backgroundColor: Colors.white,
            body: value.getActionState.actionStatus == ActionStatus.Loading ? Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ) : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  flexibleSpace: FadeIn(
                    child: Container(
                        height: 200, width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0, right: 0, bottom: 0, left: 0,
                              child: Hero(
                                tag: "background_${value.getHeroDetail['id']}",
                                child: CachedNetworkImage(imageUrl: baseUrl+"victim/${value.getHeroDetail['image']}", fit: BoxFit.cover,),
                              ),
                            ),
                            Positioned(
                              right: 0, bottom: 0, left: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.6),
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: "text_${value.getHeroDetail['id']}",
                                          child: FadeInUp(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Text("${value.getHeroDetail['victim_name']}", style: GoogleFonts.acme(
                                                    color: Colors.white, fontSize: 20
                                                ), textAlign: TextAlign.start,),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text("Witnesses: ${value.getHeroDetail['witness']}", style: GoogleFonts.adamina(
                                          fontSize: 10, color: Colors.white
                                        ),),
                                      ],
                                    ),
                                    if (value.getFollowed)
                                      ...[OutlineButton(
                                        child: Text("Unfollow Story", style: TextStyle(
                                          color: Colors.red
                                        ),),
                                        onPressed: () => value.unFollowStory(context),
                                      ),],
                                    if (!value.getFollowed)
                                      ...[
                                        OutlineButton(
                                          child: Text("Follow Story", style: TextStyle(
                                            color: Colors.green
                                          ),),
                                          onPressed: () => value.followStory(context),
                                        ),
                                      ]
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              Tab(child: Text("Information", style: _tabBarStyle,),),
                              Tab(child: Text("Stories", style: _tabBarStyle,),),
                            ],
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            unselectedLabelStyle: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                          child: Text("Biography: ", style: GoogleFonts.abel(
                                              fontSize: 20, fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 40, top: 10),
                                          child: Text("${value.getHeroDetail['bio']}"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                          child: Text("Story: ", style: GoogleFonts.abel(
                                              fontSize: 20, fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 40, top: 10),
                                          child: Text("${value.getHeroDetail['story']}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (value.getStories.length == 0)
                                  ...[
                                    Container(
                                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: Text("No Story have been added click on the verify button to add your story about ${value.getHeroDetail['victim_name']} case...",
                                          style: GoogleFonts.abel(
                                          color: Colors.blue,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w400
                                        ),
                                      )
                                    )
                                  ],
                                 if (value.getStories.length > 0)
                                 ...[
                                   SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          ...value.getStories.map((e) {
                                            return Card(
                                              shadowColor: Colors.black,
                                              elevation: 2,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('@${e['username']}', style: GoogleFonts.share(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold
                                                        ),),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        if (to_string(value.oneSignalId) == to_string(e['user_id']))
                                                          ...[
                                                            OutlineButton(
                                                              child: Text("edit story"),
                                                              onPressed: () {},
                                                            )
                                                          ]
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Text('${e['story']}', style: GoogleFonts.montserrat(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  )
                                 ],
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
            persistentFooterButtons: [
              if (value.getActionState.actionStatus == ActionStatus.Loaded)
                ...[
                  if (to_int(value.getHeroDetail['witness']) >= 3)
                    ...[
                      FadeInUp(
                        child: OutlineButton(
                          child: Row(
                            children: [
                              Text("Share story"),
                              SizedBox(width: 5,),
                              Icon(Icons.share)
                            ],
                          ),
                          onPressed: () =>value.shareHeroDetail(),
                        ),
                      )
                    ],
                  if (to_int(value.getHeroDetail['witness']) < 3)
                    ...[
                      FadeInUp(
                        child: OutlineButton(
                          child: Row(
                            children: [
                              Text("Verify Story", style: GoogleFonts.acme(
                                color: Colors.red,
                              ),),
                              SizedBox(width: 5,),
                              Icon(Icons.verified_user, color: Colors.red,)
                            ],
                          ),
                          onPressed: () => Navigator.of(context).pushNamed('add_to_story', arguments: {'victimId': value.getHeroDetail['id']}),
                        ),
                      )
                    ],
                  if (to_int(value.getHeroDetail['witness']) >= 3)
                    ...[
                      FadeInUp(
                        child: OutlineButton(
                          child: Row(
                            children: [
                              Text("Add to story"),
                              SizedBox(width: 5,),
                              Icon(Icons.add)
                            ],
                          ),
                          onPressed: () => Navigator.of(context).pushNamed('add_to_story', arguments: {'victimId': value.getHeroDetail['id']}),
                        ),
                      ),
                    ],
                  FadeInUp(
                    child: OutlineButton(
                      child: Row(
                        children: [
                          Text("Reload"),
                          SizedBox(width: 5,),
                          Icon(Icons.refresh)
                        ],
                      ),
                      onPressed: () => value.reload(),
                    ),
                  ),
                ]
            ],
          );
        },
      ),
    );
  }
}