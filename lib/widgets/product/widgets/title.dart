import 'package:flutter/material.dart';

import '../../../models/entities/product.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final bool hide;
  final TextStyle? style;
  final int? maxLines;

  const ProductTitle({
    Key? key,
    required this.product,
    this.style,
    required this.hide,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hide
        ? const SizedBox()
        // : Center(
        //   child:
        : 
        Padding(
          padding:const EdgeInsets.only(right:0),
          child:    
          
          //textDirection:TextDirection.
             Text('${product.name}',
           textAlign: TextAlign.center,
            style: style ??
                Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize:18,
                  color:Colors.white,
                ),
            maxLines:2, //maxLines ?? 2,
          ),
        ) ;
  
       // );

  }
}
