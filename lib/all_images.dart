import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:minimalist/models/wallpaper.dart';
import 'package:minimalist/wallpaper_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'models/wallpaper.dart';
import 'package:minimalist/utilities.dart';

class AllImages extends StatefulWidget {
  final List<Wallpaper> wallpapersList;
   AllImages({Key key, this.wallpapersList}) : super(key:key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  @override
  Widget build(BuildContext context) {
        return GridView.builder(
            itemCount: widget.wallpapersList.length,
            itemBuilder: (BuildContext context,int index) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GridTile(
                  child: InkResponse(
                    onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context){
                            return WallpaperGallery(
                              wallpaperList: widget.wallpapersList,
                              initialPage: index,
                                );
                              },
                            ),
                          );
                        },
                     child: CachedNetworkImage(
                      imageUrl: widget.wallpapersList.elementAt(
                          index).url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),

          );

  }
}