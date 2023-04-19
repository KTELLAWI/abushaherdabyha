import 'package:flutter/material.dart';

import '../../screens/base_screen.dart';
import 'flux_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class StaticSplashScreen extends StatefulWidget {
  final String? imagePath;
  final Function? onNextScreen;
  final int duration;
  final Color backgroundColor;
  final BoxFit boxFit;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  const StaticSplashScreen({
    this.imagePath,
    key,
    this.onNextScreen,
    this.duration = 2500,
    this.backgroundColor = Colors.white,
    this.boxFit = BoxFit.contain,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  }) : super(key: key);

  @override
  BaseScreen<StaticSplashScreen> createState() => _StaticSplashScreenState();
}

class _StaticSplashScreenState extends BaseScreen<StaticSplashScreen> {

 @override
 void initState() {
    super.initState();
  //  checkInternetConnection();
   
  }

Future<void> checkInternetConnection() async {
   bool isConnected = await InternetConnectionChecker().hasConnection;
     if (isConnected) {
    //      showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text('لايوجد اتصال بالانترنت'),
    //       content: Text('برجى تفقد الاتصال وتشغيل التطبيق مرة آخرى.',
    //       textDirection: TextDirection.rtl,),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: Text('خروج'),
    //         ),
           
    //       ],
    //     ),
    //   );
      // Perform actions when there is an internet connection
      print('You are connected to the internet.');
      widget.onNextScreen?.call();
    
    } else {
            showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('لايوجد اتصال بالانترنت'),
          content: Text('برجى تفقد الاتصال وتشغيل التطبيق مرة آخرى.',
          textDirection: TextDirection.rtl,),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('خروج'),
            ),
           
          ],
        ),
      );
      // Perform actions when there is no internet connection
      print('No internet connection. Please check your connection.');
    }
//     var connectivityResult = await Connectivity().checkConnectivity();
//  print(connectivityResult);
//     if (connectivityResult == ConnectivityResult.none) {
//  showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('No Internet Connection'),
//           content: Text('Please check your internet connection.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => widget.onNextScreen?.call(),
//               child: Text('Exit'),
//             ),
//             TextButton(
//               onPressed: () => widget.onNextScreen?.call(),
//               child: Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

}
  @override
 void afterFirstLayout(BuildContext context)  {
    //checkInternetConnection();

// var connectivityResult = await Connectivity().checkConnectivity();
//  print(connectivityResult);
//     if (connectivityResult == ConnectivityResult.none) {
//  showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('No Internet Connection'),
//           content: Text('Please check your internet connection.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => widget.onNextScreen?.call(),
//               child: Text('Exit'),
//             ),
//             TextButton(
//               onPressed: () => widget.onNextScreen?.call(),
//               child: Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }
  // checkInternetConnection();

    Future.delayed(Duration(milliseconds: widget.duration), () {
          checkInternetConnection();

     //  widget.onNextScreen?.call();
//      Navigator.of(context).pushReplacement(
//          MaterialPageRoute(builder: (context) => widget.onNextScreen));
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:widget.backgroundColor,
      body: Container(
        //alignment: Alignment.center,
        // padding: EdgeInsets.only(
        //   top: widget.paddingTop,
        //   bottom: widget.paddingBottom,
        //   left: widget.paddingLeft,
        //   right: widget.paddingRight,
        // ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FluxImage(
              imageUrl: widget.imagePath!,
              fit: widget.boxFit,
              height: constraints.maxHeight,
              width: constraints.maxWidth,
            );
          },
        ),
      ),
    );
  }
}
