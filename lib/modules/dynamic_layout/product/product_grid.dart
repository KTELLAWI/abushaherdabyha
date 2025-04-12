import 'package:flutter/material.dart';
import 'package:fstore/models/index.dart';
import 'package:provider/provider.dart';

import '../../../services/index.dart';
import '../config/product_config.dart';
import '../helper/custom_physic.dart';
import '../helper/helper.dart';
import '../../../widgets/product/product_glass_view.dart';
import 'dart:collection';
import 'dart:ui';
class ProductGrid extends StatelessWidget {
  final products;
  final maxWidth;
  final ProductConfig config;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.maxWidth,
    required this.config,
  }) : super(key: key);

  double getGridRatio() {
    switch (config.layout) {
      case Layout.twoColumn:
        return 1.5;
      case Layout.threeColumn:
      default:
        return 1.7;
    }
  }

  double getHeightRatio() {
    switch (config.layout) {
      case Layout.twoColumn:
        return 1.7;
      case Layout.threeColumn:
      default:
        return 1.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      return const SizedBox();
    }
    var ratioProductImage = config.imageRatio;
    const padding = 12.0;
    var width = maxWidth - padding;
    var rows = config.rows;
    var productHeight = Layout.buildProductHeight(
      layout: config.layout,
      defaultHeight: maxWidth,
    );
   
//    List<Widget>? getChildren()
// {
//   for ( var i = 0 ; i< products.length;  i++){
//     print(i);
//     return
//          ProductGlass(
//         item: products[i],
//         width: maxWidth,
//         maxWidth: maxWidth,
//         config: config..imageRatio =  1.2,
//       );
//   }

// }
  // final list = getChildren();
    return          SizedBox(
  width: MediaQuery.of(context).size.width/2,
   child: Column(
     // crossAxisAlignment:CrossAxisAlignment.start,
      children: [
     GridView.builder(

      itemCount: products!.length,
      physics: const NeverScrollableScrollPhysics(),
       shrinkWrap: true,
       padding: const EdgeInsets.symmetric(vertical: 4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 0.90,
      ),
      itemBuilder: (context, index) {
        return  
         BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child:
         Container(
          margin:const EdgeInsets.all(8),
           decoration: BoxDecoration(
               boxShadow: [
                 // if (widget.config.boxShadow != null)
                    BoxShadow(
                     color:  Provider.of<AppModel>(context, listen: true).darkTheme ?  Color(0xffeac85f).withOpacity(0.5) :Theme.of(context).backgroundColor ,
                     //Colors.white.withOpacity(0.5),: Color(0xffffdf90),
                    // Theme.of(context).backgroundColor.withOpacity(0.5),
                     //Colors.white.withOpacity(0.5),
                      offset: Offset(
                         0.1,
                        0.1,
                      ),
                      blurRadius: 1.0,
                    ),
                ],
            //color:Colors.red,
           /// color: Colors.lightBlue.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
               topRight: Radius.circular(20.0),
            )
            ),

child:  
 ProductGlass(
        item: products[index],
        width: maxWidth,
        maxWidth: maxWidth,
        config: config..imageRatio =  1.2,
      ),
         )
        ) ;  
        
        
       
        
        //CategoryColumnItem(categories![index]);
      },
    ),
    SizedBox(height:40),
      ]
    ),
    );
   // Container(
      //padding: const EdgeInsets.only(left: padding, top: padding,bottom:padding),
      //decoration: BoxDecoration(
       // color:Colors.black, //Theme.of(context).backgroundColor,
      ///  borderRadius: BorderRadius.circular(2),
      //),
      //height:3 * productHeight * getHeightRatio(),
     // width:0,
    //  child:
 
      





      
//       Column(
//         children:<Widget>[
// //  List.generate(text.length,(index){
// //             return Text(text[index].toString());
// //           }),


// Text('ddd'),
//           ...List.generate(products.length,(index){
//             final i=index ;
//             print(index);
//             return  Row(
//               children:<Widget>[
//                 Expanded(
//                   child:        ProductGlass(
//         item: products[i],
//         width: maxWidth,
//         maxWidth: maxWidth,
//         config: config..imageRatio =  1.2,
//       ),
//                 ),
//                 Expanded(child:        ProductGlass(
//         item: products[i],
//         width: maxWidth,
//         maxWidth: maxWidth,
//         config: config..imageRatio =  1.2,
//       ),
                
//                 )
//               ]
//             );
       
              
              
            


//           }),
//         ]
   
//     // getChildren()!,
        
//       )
      //  GridView.count(
      //   childAspectRatio: ratioProductImage * getGridRatio(),
      //   scrollDirection: Axis.horizontal,
      //   physics: config.isSnapping ?? false
      //       ? CustomScrollPhysic(
      //           width: Layout.buildProductWidth(
      //               screenWidth: width / ratioProductImage,
      //               layout: config.layout))
      //       : const ScrollPhysics(),
      //   crossAxisCount: columns,
      //   children: List.generate(products.length, (i) {

      //     return Container(
      //       margin:const EdgeInsets.all(5),

           

      //      decoration: BoxDecoration(
      //          boxShadow: [
      //            // if (widget.config.boxShadow != null)
      //               BoxShadow(
      //                // color: Colors.white.withOpacity(1),
      //                 offset: Offset(
      //                    1.1,
      //                   1,
      //                 ),
      //                 blurRadius:  1.0,
      //               ),
      //           ],
      //       color:Colors.red,
      //      /// color: Colors.lightBlue.withOpacity(0.5),
      //       // borderRadius: const BorderRadius.only(
      //       //   topLeft: const Radius.circular(50.0),
      //       //    topRight: const Radius.circular(50.0),
      //       // )
      //       ),
      
      //       child:
      //       Center(
      //       // child:  

      //       //     Services().widget.renderProductCardView(
      //       //     item: products[i],
      //       //     width: maxWidth,
      //       //     // Layout.buildProductWidth(
      //       //     //     screenWidth: width, layout: config.layout),
      //       //     maxWidth:maxWidth ,  /// Layout.buildProductMaxWidth(layout: config.layout),
      //       //     height: productHeight,
      //       //     ratioProductImage: ratioProductImage,
      //       //     config: config,
      //       //   )
      //       // ),
           
      //     );

         
      //   }),
      // ),
   // );
  }
}



