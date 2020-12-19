import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimalist/models/wallpaper.dart';
import 'package:minimalist/utilities.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'models/wallpaper.dart';
import 'providers/fav_wallpaper_manager.dart';

class WallpaperGallery extends StatefulWidget {
  final List<Wallpaper> wallpaperList;
  final int initialPage;
  WallpaperGallery({Key key,@required this.wallpaperList,@required this.initialPage}) : super(key:key);

  @override
  _WallpaperGalleryState createState() => _WallpaperGalleryState();
}

class _WallpaperGalleryState extends State<WallpaperGallery> {
  PageController _pageController;
  int _currentIndex;

  @override
  void initState(){
    super.initState();
    _pageController=PageController(initialPage: widget.initialPage);
    _currentIndex =widget.initialPage;
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    var favWallpaperManager =Provider.of<FavWallpaperManager>(context);
   return Scaffold(

           body: Stack(children: [
                PhotoViewGallery.builder(
                 pageController: _pageController,
                 itemCount:widget.wallpaperList.length,
                 builder: (BuildContext context,int index){
                   var favWallpaperManager =Provider.of<FavWallpaperManager>(context);
                   return PhotoViewGalleryPageOptions(
                     imageProvider: CachedNetworkImageProvider(
                       widget.wallpaperList.elementAt(index).url,
                     ),
                   );
                 },
                  onPageChanged: (index){
                   setState(() {
                     _currentIndex = index;
                   });

                  },
               ),
                 Align
                   ( alignment: Alignment.bottomCenter,
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(30.0),
                     child: Container(
                       width: 150.0,
                       color:Color(IconTheme.of(context).color.value ^ 0xffffff),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               IconButton(
                                 icon: Icon(Icons.format_paint),
                                 onPressed: () async {
                                 await setWallpaper(
                                     context: context,
                                     url: widget.wallpaperList.elementAt(_currentIndex).url);
                                  },
                               ),
                               IconButton(
                                   icon: Icon(widget.wallpaperList
                                       .elementAt(_currentIndex)
                                       .isFavorite ? Icons.favorite : Icons.favorite_border,
                                     color : Colors.red,
                                   ),
                                   onPressed: (){
                                            if(widget.wallpaperList
                                                .elementAt(_currentIndex)
                                                .isFavorite) {
                                              favWallpaperManager.removeFromFav(
                                                widget.wallpaperList
                                              .elementAt(_currentIndex),);
                                            }else{
                                              favWallpaperManager.addToFav(widget.wallpaperList
                                                .elementAt(_currentIndex),);

                                            }
                                            widget.wallpaperList.elementAt(_currentIndex).isFavorite =
                                            !widget.wallpaperList
                                                .elementAt(_currentIndex).isFavorite;
                               }),
                             ],
                           ),
                         ),
                       ),
                      )
                    ]),
                  );
                }
              }