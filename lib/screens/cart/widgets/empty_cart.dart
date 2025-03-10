import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width:
              screenSize.width / (2.5 / (screenSize.height / screenSize.width)),
          child: Stack(
            children: <Widget>[
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: Image.asset(
              //     'assets/images/leaves.png',
              //     width: 120,
              //     height: 120,
              //   ),
              // ),
              Column(
                mainAxisAlignment:MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(height: 60),
                  Text(S.of(context).yourBagIsEmpty,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(S.of(context).emptyCartSubtitle,
                        style: TextStyle(height: 2.0),
                       // Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 50)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
