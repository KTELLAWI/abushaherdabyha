import 'package:flutter/material.dart';

import '../../../models/entities/index.dart';
import '../../../widgets/common/flux_image.dart';

class CategoryColumnItem1 extends StatelessWidget {
  final  category;

  const CategoryColumnItem1(this.category);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        LayoutBuilder(builder: (context, constraints) {
          return FluxImage(
            imageUrl: category.image!,
            fit: BoxFit.contain,
            width: constraints.maxWidth,
          );
        }),
        Container(
            decoration: BoxDecoration(
                  // color: const Color.fromRGBO(255, 255,0, 0.1),
               // color:Colors.white,
                          borderRadius: BorderRadius.circular(0.0),

//                 boxShadow:[
// BoxShadow(
//                           blurRadius:0.5 ,//commonConfig.boxShadow!.blurRadius,
//                           color: Theme.of(context).primaryColor,
//                         //       .withOpacity(
//                         //    0.5
//                         ),],

            //    border: Border.all(
            //       color: Theme.of(context).primaryColor, width: 0.5)
            ),
          
      
          child: Text(""),
        //   Center(
        //     child: Text(
        //       category.name!,
        //       style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        ),
        // LayoutBuilder(builder: (context, constraints) {
        //   return FluxImage(
        //     imageUrl: category.image!,
        //     fit: BoxFit.contain,
        //     width: constraints.maxWidth,
        //   );
        // }),
      ],
    );
  }
}
