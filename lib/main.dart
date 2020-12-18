import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:minimalist/all_images.dart';
import 'package:minimalist/fav.dart';
import 'package:minimalist/home.dart';
import 'package:minimalist/providers/fav_wallpaper_manager.dart';
import 'package:minimalist/theme_manager.dart';
import 'package:minimalist/utilities.dart';
import 'package:minimalist/category_wallpapers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:minimalist/models/wallpaper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minimalist/constants.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  await _initApp();
  await Firebase.initializeApp();
  runApp(MyHomePage(title: 'Minimalist Wallpaper App',));
}

Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  var docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);
  var favBox = await Hive.openBox(FAV_BOX);
  if(favBox.get(FAV_LIST_KEY)==null){
    favBox.put(FAV_LIST_KEY,List<dynamic>());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final pageController= PageController(initialPage: 1);
  int currentSelected =1;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>FavWallpaperManager(),
      child: ValueListenableBuilder(
        valueListenable: ThemeManager.notifier,
        child: _buildScaffold(),
        builder: (BuildContext context, ThemeMode themeMode, Widget child) {
          return MaterialApp(
            title: widget.title,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: child,
            );
          },
        ),
    );
  }
  Scaffold _buildScaffold(){
      return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.brightness_5), onPressed:(){
            if(ThemeManager.notifier.value == ThemeMode.dark)
              {
                ThemeManager.setTheme(ThemeMode.light);
              }
            else{
              ThemeManager.setTheme(ThemeMode.dark);
            }

          },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('wallpapers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
            var wallpaperList =List<Wallpaper>();
            var favWallpaperManager = Provider.of<FavWallpaperManager>(context);
            snapshot.data.documents.forEach((documentSnapshot) {
              var wallpaper = Wallpaper.fromDocumentSnapshot(documentSnapshot);
              if(favWallpaperManager.isFavorite(wallpaper)){
                wallpaper.isFavorite=true;
              }
              wallpaperList.add(wallpaper);
            });
            return PageView.builder(
              controller: pageController,
              itemCount: 3,
              itemBuilder: (BuildContext, int index) {
                return _getPageAtIndex(index, wallpaperList);
              },
              onPageChanged: (int index) {
                setState(() {
                  currentSelected = index;
                });
              },
            );
          } else {
            return Center(child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar:_buildBottomNavigationBar(),
    );
  }
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentSelected,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'All Images',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favourite',
        ),
      ],
      onTap: (int index) {
        setState(() {
          currentSelected = index;
          pageController.animateToPage(
            currentSelected,
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 400),
          );
        });
      },
    );
  }

  Widget _getPageAtIndex(int index, List<Wallpaper> wallpaperList) {
    switch(index) {
      case 0:
        return AllImages(
          wallpapersList: wallpaperList,
        );
        break;
      case 1:
        return Home(
          wallpapersList: wallpaperList,);
        break;
      case 2:
        return Favourite(
          wallpapersList: wallpaperList,);
        break;

      default:
        return CircularProgressIndicator();
        break;
    }
  }
}
