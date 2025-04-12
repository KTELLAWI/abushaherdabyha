import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/entities/index.dart' show AddonsOption;
import '../../models/index.dart' show AppModel, Product, ProductVariation;
import '../../services/index.dart';
import 'widgets/quantity_selection.dart';
import 'widgets/quantity_selection1.dart';

class ShoppingCartRow extends StatelessWidget {
  final Product? product;
  final List<AddonsOption>? addonsOptions;
  final ProductVariation? variation;
  final Map<String, dynamic>? options;
  final int? quantity;
  final Function? onChangeQuantity;
  final VoidCallback? onRemove;

  const ShoppingCartRow({
    required this.product,
    required this.quantity,
    this.onRemove,
    this.onChangeQuantity,
    this.variation,
    this.options,
    this.addonsOptions,
  });

  

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<AppModel>(context).currency;
    final isDarkTheme = Provider.of<AppModel>(context).darkTheme;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final id = product!.id;
    print(currency);
  //   bool idState;
  //   if ( product!.id == "29" || product ){
  //     idState=true;
  //   }
  //   else{
  //     idState=false;
  //   }
  //  print(idState);

    final price = Services().widget.getPriceItemInCart(
        product!, variation, currencyRate, currency,
        selectedOptions: addonsOptions);
    final imageFeature = (variation?.imageFeature?.isNotEmpty ?? false)
        ? variation!.imageFeature
        : product!.imageFeature;
    var maxQuantity = kCartDetail['maxAllowQuantity'] ?? 100;
    var totalQuantity = variation != null
        ? (variation!.stockQuantity ?? maxQuantity)
        : (product!.stockQuantity ?? maxQuantity);
    var limitQuantity =
        totalQuantity > maxQuantity ? maxQuantity : totalQuantity;

    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return 
        Stack(
          children:[
            Padding(
              padding:EdgeInsets.only(top:30),
              child: Column(
          children: [
           
            Row(
              key: ValueKey(product!.id),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               // if (onRemove != null)
                 // IconButton(
                  //   icon: const Icon(Icons.remove_circle_outline),
                  //   onPressed: onRemove,
                  // ),
                  
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///Image Container
                //       Container(
                //        // color:
                //         decoration:BoxDecoration(
                //           color:Colors.white,// Color(0xff52260f),
                //         borderRadius:BorderRadius.circular(20),
                //           border: Border.all(
                //             color: const Color(0xff52260f),
                //             width: 0,
                //           ),
                //           boxShadow: [
                //   BoxShadow(
                //     color:const Color(0xff52260f),//Colors.black,
                //     offset: Offset(2.0, 2.0), 
                //     //offset: Offset(1.0, 1.8), //(x,y)
                //     blurRadius: 4.0,
                //   ),
                // ],
                //         ),

                //         child:  SizedBox(
                //         width: constraints.maxWidth * 0.25,
                //         height: constraints.maxWidth * 0.3,
                //         child: Image.network(imageFeature!,fit:BoxFit.fill),
                //        // ImageTools.image(urlfill: imageFeature),
                //       ),
                //       ),
                    
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: context.isRtl ? CrossAxisAlignment.start :CrossAxisAlignment.end ,
                            children: [
                              SizedBox(height:7),
                              Text(
                                product!.name!,
                                style: TextStyle(
                                  color: isDarkTheme ? theme.colorScheme.secondary : theme.primaryColor  ,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 7),
                              Text( 
                                //!context.isRtl?
                                price! ,
                                //+ currency!:price! + 'ر.س',
                                style: TextStyle(
                                    color: isDarkTheme ? theme.colorScheme.secondary : theme.primaryColor  ,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              // if (product!.options != null && options != null)
                              //   Services()
                              //       .widget
                              //       .renderOptionsCartItem(product!, options),
                              if (variation != null && context.isRtl )
                                Services().widget.renderVariantCartItem(
                                    context, variation!, options),
                                     if (variation != null && !context.isRtl )
                                Services().widget.renderVariantCartItem(
                                    context, variation!, options),
                              if (addonsOptions?.isNotEmpty ?? false)
                                Services().widget.renderAddonsOptionsCartItem(
                                    context, addonsOptions),
                                    //Counting
                              
                             // if (idState )
                              
  	                            
                                        if ( id == '2440' || id == '2441' || id == '3486' || id == '3484') 
                                         QuantitySelection1(
                                  enabled: onChangeQuantity != null,
                                  width: 60,
                                  height: 32,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  limitSelectQuantity: limitQuantity,
                                  value: 5,
                                  onChanged: onChangeQuantity,
                                  useNewDesign: true,
                                ),
                                
                               // if (kProductDetail.showStockQuantity)
                            //  if (widget.product!.id != 29 || widget.product!.id != 27 )
                                 //   if (product!.options != null && options != null)
                                   if ( id != '2440' && id != '2441' && id != '3486' && id != '3484') 
                                   QuantitySelection(
                                  enabled: onChangeQuantity != null,
                                  width: 60,
                                  height: 32,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  limitSelectQuantity: limitQuantity,
                                  value: quantity,
                                  onChanged: onChangeQuantity,
                                  useNewDesign: true,
                                ),
                              

                              ////finishin counting
                              if (product?.store != null &&
                                  (product?.store?.name != null &&
                                      product!.store!.name!.trim().isNotEmpty))
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    product!.store!.name!,
                                    style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(color: Color(0xff52260f), thickness: 0.15),
            const SizedBox(height: 10.0),
          ],
        ),
            ),
         Align(
          //top:-45,
         // right:-25,
                    alignment:Alignment.topLeft,
                 child:  ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft:Radius.circular(20),
            ),
child:

                    Image.network(imageFeature!,fit:BoxFit.fill,height:60,width:60),
                  ),
         ),
                 Align(
          //top:-45,
         // right:-25,
                    alignment:Alignment.topRight,
                 child:  ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft:Radius.circular(20),
            ),
child:     IconButton(
                    icon: const Icon(Icons.remove_circle,color:Colors.red),
                    onPressed: onRemove,
                  ),

                    //Image.network(imageFeature!,fit:BoxFit.fill,height:60,width:60),
                  ),
         )
          ]
        );
       
      },
    );
  }
}
