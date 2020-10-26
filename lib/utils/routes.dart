import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_heros_endsars/pages/HomePage/add_new_hero.dart';
import 'package:lost_heros_endsars/pages/HomePage/add_to_story.dart';
import 'package:lost_heros_endsars/pages/HomePage/edit_profile_page.dart';
import 'package:lost_heros_endsars/pages/HomePage/home_page.dart';
import 'package:lost_heros_endsars/pages/HomePage/login.dart';
import 'package:lost_heros_endsars/pages/HomePage/lost_hero_detail.dart';
import 'package:lost_heros_endsars/pages/HomePage/profile.dart';
import 'package:lost_heros_endsars/pages/HomePage/register.dart';
import 'package:lost_heros_endsars/pages/HomePage/splash_screen.dart';
import 'package:lost_heros_endsars/providers/add_new_hero_provider.dart';
import 'package:lost_heros_endsars/providers/add_to_story_provider.dart';
import 'package:lost_heros_endsars/providers/auth_provider.dart';
import 'package:lost_heros_endsars/providers/edit_profile_provider.dart';
import 'package:lost_heros_endsars/providers/profile_provider.dart';
import 'package:lost_heros_endsars/providers/view_hero_detail_provider.dart';
import 'package:provider/provider.dart';

class RouteGenerator {


  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomePage(),);
        break;
      case 'splash_screen':
        return MaterialPageRoute(builder: (context) => SplashScreen(),);
        break;
      case 'add_new_hero':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => AddNewHeroProvider(),
          child: AddNewHeroPage(),
        ),);
        break;
      case 'view_hero_detail':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => ViewHeroDetailProvider(data: settings.arguments),
          child: FallenHeroDetail(),
        ),);
        break;
      case 'add_to_story':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => AddToStoryProvider(data: settings.arguments),
          child: AddToStory(),
        ),);
        break;
      case 'login':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          child: LoginPage(),
        ),);
        break;
      case 'profile':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
          child: ProfilePage(),
        ),);
        break;
      case 'edit_profile':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => EditProfileProvider(),
          child: EditProfilePage(),
        ),);
        break;
      case 'register':
        return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          child: RegisterPage(),
        ),);
        break;
      default:
        return MaterialPageRoute(builder: (context) => Container(
          child: Text("Look like you lost your way"),
        ),);
    }
  }
}