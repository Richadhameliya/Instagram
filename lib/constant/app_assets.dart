import 'package:flutter/cupertino.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const camera = "${imagePath}camera.png";
  static const instaTxt = "${imagePath}insta_txt.png";
  static const instaLogo = "${imagePath}instagram.png";
  static const meta = "${imagePath}meta.png";
}

Widget assetImage(String image, {double? height, double? width, Color? color}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
  );
}

AssetImage assetsImage2(String image,
    {double? height, double? width, Color? color}) {
  return AssetImage(image);
}
