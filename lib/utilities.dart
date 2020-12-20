import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

enum SetWallpaperAs{
  Home,Lock,Both
}

const _setAs = {
  SetWallpaperAs.Home: WallpaperManager.HOME_SCREEN,
  SetWallpaperAs.Lock: WallpaperManager.LOCK_SCREEN,
  SetWallpaperAs.Both: WallpaperManager.BOTH_SCREENS,
};

Future<void> setWallpaper({BuildContext context, String url}) async {

  var actionSheet = CupertinoActionSheet(
    title: Text('Set'),
    actions: [
      CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop(SetWallpaperAs.Home);
          },
          child: Text('Home')),
      CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop(SetWallpaperAs.Lock);
          },
          child: Text('Lock')),
      CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop(SetWallpaperAs.Both);
          },
          child: Text('Both'))
    ],
  );

  SetWallpaperAs option =await  showCupertinoModalPopup(
      context: context, builder: (context)=>actionSheet);
  if(option != null) {

    var cacheImage = await DefaultCacheManager().getSingleFile(url);
    if(cacheImage != null) {
      var croppedImage = await ImageCropper.cropImage(
          sourcePath: cacheImage.path,
          aspectRatio: CropAspectRatio(
              ratioX: MediaQuery.of(context).size.width,
              ratioY: MediaQuery.of(context).size.height,
          ),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          hideBottomControls: true,
        ),
      );


    if(croppedImage !=null){
        var result = await WallpaperManager.setWallpaperFromFile(
            croppedImage.path, _setAs[option]);
         if(result != null){
          debugPrint(result);
        }
      }
    }
  }
}