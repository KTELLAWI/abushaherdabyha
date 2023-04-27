import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:collection';
import 'dart:ui';
import '../../models/index.dart' show Product, CartModel;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../../common/tools.dart';
import 'action_button_mixin.dart';
import 'index.dart'

    show
        CartIcon,
        HeartButton,
        ProductImage,
        ProductOnSale,
        ProductPricing,
        ProductTitle;
import 'widgets/cart_button_with_quantity.dart';

class ProductGlass extends StatelessWidget with ActionButtonMixin {
  final Product item;
  final double? width;
  final double? maxWidth;
  final offset;
  final ProductConfig config;

  const ProductGlass({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
   //ProductPricing(product: item, hide: config.hidePrice);
   
   final s =  PriceTools.getCurrencyFormatted(
                          item.price ??  '0', null)!;
    Widget productImage = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              BorderRadius.circular(0),
          child: Stack(
            children: [
              ProductImage(
                width: width!,
                product: item,
                config: config,
                ratioProductImage: config.imageRatio,
                offset: offset,
                onTapProduct: () => onTapProduct(context, product: item),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: ProductOnSale(
                  product: item,
                  config: ProductConfig.empty()..hMargin = 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(config.borderRadius ?? 12),
                    ),
                  ),
                ),
              ),
              if (config.showCartButtonWithQuantity)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Selector<CartModel, int>(
                      selector: (context, cartModel) =>
                          cartModel.productsInCart[item.id!] ?? 0,
                      builder: (context, quantity, child) {
                        return CartButtonWithQuantity(
                          quantity: quantity,
                          borderRadiusValue: config.cartIconRadius,
                          increaseQuantityFunction: () {
                            // final minQuantityNeedAdd =
                            //     widget.item.getMinQuantity();
                            // var quantityWillAdd = 1;
                            // if (quantity == 0 &&
                            //     minQuantityNeedAdd > 1) {
                            //   quantityWillAdd = minQuantityNeedAdd;
                            // }
                            addToCart(
                              context,
                              quantity: 1,
                              product: item,
                            );
                          },
                          decreaseQuantityFunction: () {
                            if (quantity <= 0) return;
                            updateQuantity(
                              context: context,
                              quantity: quantity - 1,
                              product: item,
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );

    Widget productInfo = Column(
                       //  mainAxisAlignment:MainAxisAlignment.start,

   //  mainAxisSize: MainAxisSize.max,
  // crossAxisAlignment: CrossAxisAlignment.start,
  // padding:const EdgeInsets.all(5),
      children: [
      const SizedBox(height: 5),
        ProductTitle(
          product: item,
          hide: config.hideTitle,
          maxLines: config.titleLine,
        ),
        SizedBox(height:5),
        // Text('   يبدأ من ${s}',style:TextStyle(fontSize:12)),
        // SizedBox(height:5),
       
        //    ProductTitle(
        //   product: item,
        //   hide: config.hideTitle,
        //   maxLines: config.titleLine,
        // ),
       // const SizedBox(height: 5),
        // Row(
        //   children: [
        //     ProductPricing(product: item, hide: config.hidePrice),
          
        //     CartIcon(
        //       config: config,
        //       quantity: 1,
        //       product: item,
        //     ),
        //   ],
        // )
      ],
    );

    return GestureDetector(
      onTap: () => onTapProduct(context, product: item),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: <Widget>[
           ClipRRect(
          borderRadius:
              BorderRadius.circular(20),
       child:   BackdropFilter(
            filter: ImageFilter.blur(sigmaX:0.5, sigmaY: 0.5),
            child:
            Align(
             alignment:Alignment.bottomCenter,
            // bottom:10,
          child:  BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child:
          productImage
          ) 
          ), 
          ),
           ),
          Positioned(
            bottom:0,
           // alignment:Alignment.bottomCenter,
            child:  Container(
              decoration: BoxDecoration(
      //                  boxShadow: [
      // //            // if (widget.config.boxShadow != null)
      //               BoxShadow(
      //                 color: Colors.grey,//Color(0xffc8ddf7),
      //                 offset: Offset(
      //                    1.1,
      //                   -1.1,
      //                 ),
      //                 blurRadius:  5.0,
      //               ),
      //           ],
         // borderRadius: BorderRadius.circular(25),
           borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
           // bottomRight:const Radius.circular(30.0),
         //  bottomLeft:const Radius.circular(60.0),
  ),
            // color: Theme.of(context).backgroundColor,
             ),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).cardColor,
      //               borderRadius:
      //               BorderRadius.circular( 5),
      //                 border: Border.all(
      //    color: Colors.green,
      //   width:1,
      // ),
      //                 boxShadow: [
      //            // if (widget.config.boxShadow != null)
      //               BoxShadow(
      //                 color: Colors.green,
      //                 offset: Offset(
      //                    5.1,
      //                   5.1,
      //                 ),
      //                 blurRadius:  5.0,
      //               ),
      //           ]
      //           //   gradient: SweepGradient(
      //           //     colors: [
      //           //    // Colors.transparent,
      //           //     //  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      //           //      // Theme.of(context).cardColor,
      //           //      Colors.white,
      //           //       Theme.of(context).primaryColor.withOpacity(0.1),
      //           //         Colors.white,
      //           //        //Theme.of(context).primaryColor.withOpacity(0.3),
      //           //       //Colors.white,
      //           //       //Theme.of(context).backgroundColor,Colors.blue,
      //           //      // Colors.white,
      //           //      // Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      //           //     ],
      //           //   ),
      //            ),
            //color:Colors.blue,
             //height:146,
          // constraints: BoxConstraints(maxWidth: maxWidth ?? width!),
           //  margin: EdgeInsets.only(top:0,left:config.hMargin,right:config.hMargin ),
            // margin: EdgeInsets.symmetric(
            //   horizontal: config.hMargin,
            //   vertical: config.vMargin,
            // ),
          //  width: width!,
           // child:
            //  ClipRRect(
            //   borderRadius: BorderRadius.circular( 0),
              // child: Container(
              //   decoration: BoxDecoration(
              //     // gradient: SweepGradient(
              //     //   colors: [
              //     //  // Colors.transparent,
              //     //     Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              //     //    // Theme.of(context).cardColor,
              //     //    Colors.white,
              //     //     Theme.of(context).primaryColor.withOpacity(0.2),
              //     //     Colors.white,
              //     //     //Theme.of(context).backgroundColor,Colors.blue,
              //     //    // Colors.white,
              //     //     Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              //     //   ],
              //     // ),
              //   ),
                child:
                 Container(
                  //height:52,
                
                   width: MediaQuery.of(context).size.width/2,//width!,
                    decoration: BoxDecoration(
                      color:Color(0xff52260f),
                       boxShadow: [
      //            // if (widget.config.boxShadow != null)
                    BoxShadow(
                      color: Color(0xffeac85f),//.grey,//Color(0xffc8ddf7),
                      offset: Offset(
                         0.5,
                        -0.5,
                      ),
                      blurRadius:  2.0,
                    ),
                ],
         // borderRadius: BorderRadius.circular(25),
           borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
           // bottomRight:const Radius.circular(30.0),
         //  bottomLeft:const Radius.circular(60.0),
  ),
                      
                  // gradient: SweepGradient(
                  //   colors: [
                  //  // Colors.transparent,
                  //    // Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  //    // Theme.of(context).cardColor,
                  //    Theme.of(context).backgroundColor,
                  //     //Theme.of(context).primaryColor.withOpacity(0.2),
                  //     Theme.of(context).backgroundColor,
                  //     //Theme.of(context).backgroundColor,Colors.blue,
                  //    // Colors.white,
                  //    // Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                  //   ],
                  // ),
                ),
              
                // margin: EdgeInsets.only(top:15),
                 // color: Theme.of(context).cardColor.withOpacity(0.5),
                  //padding: const EdgeInsets.all(0.5),
                child:   SizedBox(
  width: MediaQuery.of(context).size.width/2,
   child: Column(
                    mainAxisSize: MainAxisSize.max,
                    
                    //mainAxisAlignment:MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   //  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //SizedBox(height:5),
        //                 ProductTitle(
        //   product: item,
        //   hide: config.hideTitle,
        //   maxLines: config.titleLine,
        // ),
                          productInfo,
                    // productImage,
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: (config.borderRadius ?? 6) * 0.25,
                      //   ),
                      //   child: 
                   
                      // ),
                    ],
                  ),
                 ),
                ),
             // ),
           // ),
          ),
          ),
        
          //productImage,
          
          if (config.showHeart && !item.isEmptyProduct())
            Positioned(
              top: 5,
              right: 5,
              child: HeartButton(product: item, size: 18),
            )
        ],
      ),
    );
  }
}
