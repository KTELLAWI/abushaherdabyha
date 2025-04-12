import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools/flash.dart';
import '../../../generated/l10n.dart' show S;
import '../../../models/index.dart'
    show
        AddonsOption,
        AppModel,
        Product,
        ProductAttribute,
        ProductModel,
        ProductVariation;
import '../../../services/index.dart';
import '../../../widgets/common/webview.dart';

class ProductVariantButton extends StatefulWidget {
  final Product? product;
  final Function? onSelectVariantImage;
  final int defaultQuantity;
  final bool? status ;


   ProductVariantButton(this.product, this.status,
     {this.onSelectVariantImage, this.defaultQuantity = 1, Key? key}): super(key:key);

  @override
  // ignore: no_logic_in_create_state
  State<ProductVariantButton> createState() => _StateProductVariantButton(product!);
}

class _StateProductVariantButton extends State<ProductVariantButton> {
  Product product;

  ProductVariation? productVariation;

//   Map<String, Map<String, AddonsOption>> selectedOptions = {};
//   List<AddonsOption> addonsOptions = [];

  _StateProductVariantButton(this.product);

  final services = Services();
  Map<String?, String?>? mapAttribute;

  List<ProductVariation>? get variations =>
      context.select((ProductModel _) => _.variations);

  int quantity = 1;

//   void updateSelectedOptions(
//       Map<String, Map<String, AddonsOption>> selectedOptions) {
//     this.selectedOptions = selectedOptions;
//     final options = <AddonsOption>[];
//     for (var addOns in selectedOptions.values) {
//       options.addAll(addOns.values);
//     }
//     product.selectedOptions = options;
//   }

  /// Get product variants
  Future<void> getProductVariations() async {
    await services.widget.getProductVariations(
        context: context,
        product: product,
        onLoad: ({
          Product? productInfo,
          List<ProductVariation>? variations,
          Map<String?, String?>? mapAttribute,
          ProductVariation? variation,
        }) {
          if (productInfo != null) {
            product = productInfo;
          }
          this.mapAttribute = mapAttribute ?? {};
          if (variations != null) {
            context.read<ProductModel>().changeProductVariations(
                  variations,
                  notify: false,
                );
            productVariation = variation;
            context
                .read<ProductModel>()
                .changeSelectedVariation(productVariation);
          }
          if (!mounted) {
            return;
          }
          setState(() {});
        });
  }

//   Future<void> getProductAddons() async {
//     await services.widget.getProductAddons(
//       context: context,
//       product: product,
//       selectedOptions: selectedOptions,
//       onLoad: (
//           {Product? productInfo,
//           required Map<String, Map<String, AddonsOption>> selectedOptions}) {
//         if (productInfo != null) {
//           product = productInfo;
//         }
//        // updateSelectedOptions(selectedOptions);
//         if (mounted) {
//           setState(() {});
//         }
//       },
//     );
//   }

  @override
  void initState() {
    super.initState();
    product = widget.product as Product;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          quantity = widget.defaultQuantity;
        });
       getProductVariations();
       // getProductAddons();
      },
    );
  }

  @override
  void dispose() {
    FlashHelper.dispose();
    super.dispose();
  }

  /// Support Affiliate product
//   void openWebView() {
//     if (product.affiliateUrl == null || product.affiliateUrl!.isEmpty) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).backgroundColor,
//             systemOverlayStyle: SystemUiOverlayStyle.light,
//             leading: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Icon(Icons.arrow_back_ios),
//             ),
//           ),
//           body: Center(
//             child: Text(S.of(context).notFound),
//           ),
//         );
//       }));
//       return;
//     }

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => WebView(
//                   url: product.affiliateUrl,
//                   title: product.name,
//                 )));
//   }

  /// Add to Cart & Buy Now function
  void addToCart([bool buyNow = false, bool inStock = false]) {
    services.widget.addToCart(context, product, quantity, productVariation,
        mapAttribute ?? {}, buyNow, inStock);
  }

  /// check limit select quality by maximum available stock
  int getMaxQuantity() {
    var limitSelectQuantity = 50;
    //  kCartDetail['maxAllowQuantity'] ?? 100;

    // /// Skip check stock quantity for backorder products.
    // if (product.backordersAllowed) {
    //   return limitSelectQuantity;
    // }

    // if (productVariation != null) {
    //   if (productVariation!.stockQuantity != null) {
    //     limitSelectQuantity = math.min<int>(
    //         productVariation!.stockQuantity!, kCartDetail['maxAllowQuantity']);
    //   }
    // } else if (product.stockQuantity != null) {
    //   limitSelectQuantity = math.min<int>(
    //       product.stockQuantity!, kCartDetail['maxAllowQuantity']);
    // }
    return limitSelectQuantity;
  }

  void onSelectProductVariantButton({
    ProductAttribute? attr,
    String? val,
    List<ProductVariation>? variations,
    Map<String?, String?>? mapAttribute,
    Function? onFinish,
  }) {
    services.widget.onSelectProductVariant(
      attr: attr!,
      val: val,
      variations: variations!,
      mapAttribute: mapAttribute!,
      onFinish:
          (Map<String?, String?> mapAttribute, ProductVariation? variation) {
        setState(() {
          this.mapAttribute = mapAttribute;
        });
        productVariation = variation;
        context.read<ProductModel>().changeSelectedVariation(variation);

        /// Show selected product variation image in gallery.
        final attrType = kProductVariantLayout[attr.cleanSlug ?? attr.name] ??
            kProductVariantLayout[attr.name!.toLowerCase()] ??
            'box';
        if (widget.onSelectVariantImage != null && attrType == 'image') {
          for (var option in attr.options!) {
            if (option['name'] == val &&
                option['description'].toString().contains('http')) {
              final selectedImageUrl = option['description'];
              widget.onSelectVariantImage!(selectedImageUrl);
            }
          }
        }
      },
    );
  }

//   void onSelectProductAddons({
//     required Map<String, Map<String, AddonsOption>> selectedOptions,
//   }) {
//     setState(() {
//       //updateSelectedOptions(selectedOptions);
//     });
//   }

  List<Widget> getProductAttributeWidget() {
    final lang = Provider.of<AppModel>(context, listen: false).langCode;
    if (mapAttribute == null && Config().type != ConfigType.opencart) {
      return [];
    }
    return services.widget.getProductAttributeWidget(
        lang, product, mapAttribute, onSelectProductVariantButton, variations!);
  }

//   List<Widget> getProductAddonsWidget() {
//     final lang = Provider.of<AppModel>(context, listen: false).langCode;
//     return services.widget.getProductAddonsWidget(
//       context: context,
//       selectedOptions: selectedOptions,
//       lang: lang,
//       product: product,
//       onSelectProductAddons: onSelectProductAddons,
//       quantity: quantity,
//     );
//   }

  List<Widget> getBuyButtonWidget() {
    var note = '';
    if (product.id=='29' || product.id=='27' ){
      quantity=5;
    }
    return services.widget.getBuyButtonWidget(context, productVariation,
        product, mapAttribute, getMaxQuantity(), quantity, addToCart, (val) {
      quantity = val;
    }, variations,note);
  }

//   List<Widget> getProductTitleWidget() {
//     return services.widget
//         .getProductTitleWidget(context, productVariation, product);
//   }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    final isVariationLoading = productVariation == null &&
        (variations?.isEmpty ?? true) &&
        Config().type != ConfigType.opencart &&
        Config().type != ConfigType.notion;

    if(widget!.status!){
        return    Container(
            //  alignment:Alignment.bottomCenter,
         
          child:
    Column(
        mainAxisAlignment:MainAxisAlignment.end,
      children: <Widget>[
              
                                Row(
          children:[
            Expanded(
              child:SizedBox( 
             // height:42, //height of button
             // width:double.infinity, //width of button
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(00.0),
              )),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                    Navigator.of(context).pop();
                 // addToCart(true,true,);
                    //code to execute when this button is pressed.
                }, 
                child: Text('Elevated Button') 
              )
            ),
            ),

            Expanded(
              child:SizedBox( 
            // height:42, //height of button
            // width:double.infinity, //width of button
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(00.0),
              )),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                      addToCart(false,true,);
                 // variantKey.currentState.addToCart();
                    //code to execute when this button is pressed.
                }, 
                child: Text('Elevated Button') 
              )
            ),
            )

          ]
        ),//
         if(widget!.status!)
        SizedBox( 
             // height:42, //height of button
              width:double.infinity, //width of button
              child:
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.black, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40.0),
              )),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                     addToCart(true,true,);
                    //code to execute when this button is pressed.
                }, 
                child: Text('Elevated Button') 
              )
            ),
         
      
      
      ],
    // ),
  ),
    );

    }
    
    
    //     switch (widget!.status) {
    //   case 'logo':
    //     final themeConfig = appModel.themeConfig;
    //     return Logo( 

   if (!widget!.status!){

return 
   Container(
            //  alignment:Alignment.bottomCenter,
         
          child:
    Column(
        mainAxisAlignment:MainAxisAlignment.end,
      children: <Widget>[
              
                              
         
         //...getProductTitleWidget(),
       if (!isVariationLoading) ...getProductAttributeWidget(),
       // ...getProductAddonsWidget(),
        ...getBuyButtonWidget(),
      
      ],
    // ),
  ),
    );

   }
    
    
    return 
    Container();
      
      
//       ],
//     // ),
//   ),
//     );

  }
}
