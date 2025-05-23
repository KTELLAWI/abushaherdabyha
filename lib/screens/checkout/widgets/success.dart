import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Order, UserModel, PointModel;
import '../../../services/index.dart';
import '../../base_screen.dart';

class OrderedSuccess extends StatefulWidget {
  final Order? order;

  const OrderedSuccess({this.order});

  @override
  BaseScreen<OrderedSuccess> createState() => _OrderedSuccessState();
}

class _OrderedSuccessState extends BaseScreen<OrderedSuccess> {
  @override
  void afterFirstLayout(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user;
    if (user != null &&
        user.cookie != null &&
        kAdvanceConfig.enablePointReward) {
      Services().api.updatePoints(user.cookie, widget.order);
      Provider.of<PointModel>(context, listen: false).getMyPoint(user.cookie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return Center( 
     // alignment:Alignment.center,
      child:
    Container(
    //  margin: EdgeInsets.only(top:MediaQuery.of(context).size.width/2),
      color:Colors.white.withOpacity(0.5),
      child: Center(
        child:
      //)
    
    BackdropFilter(
            filter: ImageFilter.blur(sigmaX:0.0, sigmaY: 0.0),
            child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
    //  padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        Container(
         margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(color:Colors.transparent, //Theme.of(context).primaryColorLight
          ),
          child: Center(
            // padding:
            //  const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  S.of(context).itsOrdered,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                if (widget.order?.number != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        S.of(context).orderNo,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: 
                        Text(
                          '#${widget.order!.number}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Text(
        //   S.of(context).orderSuccessTitle1,
        //   style: TextStyle(
        //       fontSize: 18, color: Theme.of(context).colorScheme.secondary),
        // ),
    //    const SizedBox(height: 15),
        // Text(
        //   S.of(context).orderSuccessMsg1,
        //   style: TextStyle(
        //       color: Theme.of(context).colorScheme.secondary,
        //       height: 1.4,
        //       fontSize: 14),
        // ),
        if (userModel.user != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal:30),
            child: Row(
             //  margin: EdgeInsets.only(top:MediaQuery.of(context).size.width/5),
              children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      final user =
                          Provider.of<UserModel>(context, listen: false).user;
                      Navigator.of(context).pushNamed(
                        RouteList.orders,
                        arguments: user,
                      );
                    },
                    child: Text(
                      S.of(context).showAllMyOrdered.toUpperCase(),
                    ),
                  ),
                ),
              ),
            ]),
          ),
       const SizedBox(height: 40),
        // Text(
        //   S.of(context).orderSuccessTitle2,
        //   style: TextStyle(
        //       fontSize: 18, color: Theme.of(context).colorScheme.secondary),
        // ),
     //   const SizedBox(height: 10),
        // Text(
        //   S.of(context).orderSuccessMsg2,
        //   style: TextStyle(
        //       color: Theme.of(context).colorScheme.secondary,
        //       height: 1.4,
        //       fontSize: 14),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      S.of(context).backToShop.toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
    ),
    ),
    ),
    );
  }
}
