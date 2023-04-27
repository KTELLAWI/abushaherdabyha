import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white.withOpacity(0.8),
      child: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children:[SpinKitDoubleBounce(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      ),
     // Text('لطفاً انتظر',style:TextStyle(fontSize:17)),

        ]
      )
      
    );
  }
}
