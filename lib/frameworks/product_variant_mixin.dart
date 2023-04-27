import 'package:collection/collection.dart' show IterableExtension;
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools/tools.dart';
import '../generated/l10n.dart';
import '../models/index.dart'
    show CartModel, Product, ProductModel, ProductVariation,AppModel;
import '../routes/flux_navigate.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/detail/widgets/index.dart' show ProductShortDescription;
import '../services/service_config.dart';
import '../services/services.dart';
import '../widgets/common/webview.dart';
import '../widgets/product/widgets/quantity_selection.dart';
import '../widgets/product/widgets/quantity_selection1.dart';
mixin ProductVariantMixin {
  ProductVariation? updateVariation(
    List<ProductVariation> variations,
    Map<String?, String?> mapAttribute,
  ) {
    final templateVariation =
        variations.isNotEmpty ? variations.first.attributes : null;
    final listAttributes = variations.map((e) => e.attributes);

    ProductVariation productVariation;
    var attributeString = '';

    /// Flat attribute
    /// Example attribute = { "color": "RED", "SIZE" : "S", "Height": "Short" }
    /// => "colorRedsizeSHeightShort"
    templateVariation?.forEach((element) {
      final key = element.name;
      final value = mapAttribute[key];
      attributeString += value != null ? '$key$value' : '';
    });

    /// Find attributeS contain attribute selected
    final validAttribute = listAttributes.lastWhereOrNull(
      (attributes) =>
          attributes.map((e) => e.toString()).join().contains(attributeString),
    );

    if (validAttribute == null) return null;

    /// Find ProductVariation contain attribute selected
    /// Compare address because use reference
    productVariation =
        variations.lastWhere((element) => element.attributes == validAttribute);

    for (var element in productVariation.attributes) {
      if (!mapAttribute.containsKey(element.name)) {
        mapAttribute[element.name!] = element.option!;
      }
    }
    return productVariation;
  }

  bool isPurchased(
    ProductVariation? productVariation,
    Product product,
    Map<String?, String?> mapAttribute,
    bool isAvailable,
  ) {
    var inStock;
    // ignore: unnecessary_null_comparison
    if (productVariation != null) {
      inStock = productVariation.inStock!;
    } else {
      inStock = product.inStock!;
    }

    var allowBackorder = productVariation != null
        ? (productVariation.backordersAllowed ?? false)
        : product.backordersAllowed;

    var isValidAttribute = false;
    try {
      if (product.type == 'simple') {
        isValidAttribute = true;
      }
      if (product.attributes!.length == mapAttribute.length &&
          (product.attributes!.length == mapAttribute.length ||
              product.type != 'variable')) {
        isValidAttribute = true;
      }
    } catch (_) {}

    return (inStock || allowBackorder) && isValidAttribute && isAvailable;
  }

  List<Widget> makeProductTitleWidget(BuildContext context,
      ProductVariation? productVariation, Product product, bool isAvailable) {
    var listWidget = <Widget>[];

    // ignore: unnecessary_null_comparison
    var inStock = (productVariation != null
            ? productVariation.inStock
            : product.inStock) ??
        false;

    var stockQuantity =
        (kProductDetail.showStockQuantity) && product.stockQuantity != null
            ? '  (${product.stockQuantity}) '
            : '';
    if (Provider.of<ProductModel>(context, listen: false).selectedVariation !=
        null) {
      stockQuantity = (kProductDetail.showStockQuantity) &&
              Provider.of<ProductModel>(context, listen: false)
                      .selectedVariation!
                      .stockQuantity !=
                  null
          ? '  (${Provider.of<ProductModel>(context, listen: false).selectedVariation!.stockQuantity}) '
          : '';
    }

    if (isAvailable) {
      listWidget.add(
        const SizedBox(height: 5.0),
      );

      final sku = productVariation != null ? productVariation.sku : product.sku;

      listWidget.add(
        Row(
          children: <Widget>[
            if ((kProductDetail.showSku) && (sku?.isNotEmpty ?? false)) ...[
              Text(
                '${S.of(context).sku}: ',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(
                sku ?? '',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: inStock
                          ? Theme.of(context).primaryColor
                          : const Color(0xFFe74c3c),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
      );

      listWidget.add(
        const SizedBox(height: 5.0),
      );

      listWidget.add(
        Row(
          children: <Widget>[
            if (kAdvanceConfig.showStockStatus) ...[
              Text(
                '${S.of(context).availability}: ',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              (productVariation != null
                      ? (productVariation.backordersAllowed ?? false)
                      : product.backordersAllowed)
                  ? Text(
                      S.of(context).backOrder,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: kColorBackOrder,
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  : Text(
                      inStock
                          ? '${S.of(context).inStock}$stockQuantity'
                          : S.of(context).outOfStock,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: inStock
                                ? Theme.of(context).primaryColor
                                : kColorOutOfStock,
                            fontWeight: FontWeight.w600,
                          ),
                    )
            ],
          ],
        ),
      );
      if (productVariation?.description?.isNotEmpty ?? false) {
        listWidget.add(Services()
            .widget
            .renderProductDescription(context, productVariation!.description!));
      }
      if (product.shortDescription != null &&
          product.shortDescription!.isNotEmpty) {
        listWidget.add(
          ProductShortDescription(product),
        );
      }

      listWidget.add(
        const SizedBox(height: 15.0),
      );
    }

    return listWidget;
  }

  List<Widget> makeBuyButtonWidget(
      BuildContext context,
      ProductVariation? productVariation,
      Product product,
      Map<String?, String?>? mapAttribute,
      int maxQuantity,
      int quantity,
      Function addToCart,
      Function onChangeQuantity,
      bool isAvailable,
      String? note,
      // Widget pprice,
      // Widget? ptext,

      {bool ignoreBuyOrOutOfStockButton = false}) {
    final theme = Theme.of(context);

    // ignore: unnecessary_null_comparison
    var inStock = (productVariation != null
            ? productVariation.inStock
            : product.inStock) ??
        false;
    var allowBackorder = productVariation != null
        ? (productVariation.backordersAllowed ?? false)
        : product.backordersAllowed;

    final isExternal = product.type == 'external' ? true : false;
    final isVariationLoading =
        // ignore: unnecessary_null_comparison
        (product.isVariableProduct || product.type == 'configurable') &&
            productVariation == null &&
            mapAttribute == null;

    final buyOrOutOfStockButton = Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: isExternal
            ? ((inStock || allowBackorder) &&
                    mapAttribute != null &&
                    (product.attributes!.length == mapAttribute.length) &&
                    isAvailable)
                ? theme.primaryColor
                : theme.disabledColor
            : theme.primaryColor,
      ),
      child: Center(
        child: Text(
          ((((inStock || allowBackorder) && isAvailable) || isExternal) &&
                  !isVariationLoading
              ? S.of(context).buyNow
              : (isAvailable && !isVariationLoading
                      ? S.of(context).outOfStock
                      : isVariationLoading
                          ? S.of(context).loading
                          : S.of(context).unavailable)
                  .toUpperCase()),
          style: Theme.of(context).textTheme.button!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );

    if (!inStock && !isExternal && !allowBackorder) {
      return [
        ignoreBuyOrOutOfStockButton ? const SizedBox() : buyOrOutOfStockButton,
      ];
    }

    if ((product.isPurchased) && (product.isDownloadable ?? false)) {
      return [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async => await Tools.launchURL(product.files![0]!),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: Text(
                    S.of(context).download,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                        ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ];
    }

    return [
      if (!isExternal && kProductDetail.showStockQuantity) ...[
        const SizedBox(height: 10),
        Container(
           decoration: BoxDecoration(
                  border: Border(
                  right: BorderSide(
			color: const Color(0xff52260f),
			width: 2,
		  ),
      left: BorderSide(
			color: const Color(0xff52260f),
			width: 2,
		  ),
      bottom: BorderSide(
			color: const Color(0xff52260f),
			width: 2,
		  ),
		 
                 
                  ),
          color:Theme.of(context).primaryColorLight,),//Provider.of<AppModel>(context).darkTheme ?Theme.of(context).backgroundColor :Colors.white,
          child:Row(
          children: [
            Expanded(
              child: Text(
                '  ${S.of(context).selectTheQuantity}:',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),//Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Expanded(
              child: Container(
                height: 32.0,
               
                alignment: Alignment.center,
                decoration: BoxDecoration(
      //             border: Border(
      //             left: BorderSide(
			// color: const Color(0xff52260f),
			// width: 2,
		  // ),
		 
                 
      //             ),
                  // border: Border(
                  // left: BorderSide(
                  // color: const Color(0xff52260f),
                  // width: 1,
                  // ),
                  // right: BorderSide(
                  // color: const Color(0xff52260f),
                  // width: 1,
                  // ),
                  
                  // ),
		  
                  color:Theme.of(context).primaryColorLight,//Provider.of<AppModel>(context).darkTheme ?Theme.of(context).backgroundColor :Colors.white,

                  //borderRadius: BorderRadius.circular(3),
                ),
                child: product!.id =='2441' ||product!.id =='2440' || product!.id == "3486" || product!.id == "3484" ?
                 QuantitySelection1(
                  height: 32.0,
                  expanded: true,
                  value: 5,
                  color: theme.colorScheme.secondary,
                  limitSelectQuantity: maxQuantity,
                  onChanged: onChangeQuantity,
                  useNewDesign:true,
                ):
                 QuantitySelection(
                  height: 32.0,
                  expanded: true,
                  value: quantity,
                  color: theme.colorScheme.secondary,
                  limitSelectQuantity: maxQuantity,
                  onChanged: onChangeQuantity,
                  useNewDesign:true,
                ),
              ),
            ),
          ],
        ),
        )
      ],
      const SizedBox(height: 0),

      /// Action Buttons: Buy Now, Add To Cart
               
              Container(
             //   color:Colors.red,
                child:  Column(
        mainAxisAlignment:MainAxisAlignment.end,
      children: <Widget>[
        Container(
                decoration: BoxDecoration(
                  border: Border(
                  left: BorderSide(
			color: const Color(0xff52260f),
			width: 2,
		  ),
		  right: BorderSide(
			color: const Color(0xff52260f),
			width: 2,
		  ),
                 
                  ),
                  ),
        child:
              
                                Row(
          children:[
            Expanded(
              child:SizedBox( 

             // height:42, //height of button
             // width:double.infinity, //width of button
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 0.5, color: Theme.of(context).primaryColor,),
                  primary: Theme.of(context).primaryColorLight,//Colors.green, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(0.0),
              )),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                    Navigator.of(context).pop();
                 // addToCart(true,true,);
                    //code to execute when this button is pressed.
                }, 
                child: Text( S.of(context).home.toUpperCase(),) 
              )
            ),
            ),
            //  Container(
            //     height:44,
            //     width:2,
            //     color:Colors.blue,
            //   ),
            Expanded(
              child:SizedBox( 
            // height:42, //height of button
            // width:double.infinity, //width of button
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 0.5, color: Theme.of(context).primaryColor,),
                  primary: Theme.of(context).primaryColorLight,//Colors.green, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(0.0),
              )),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                  print('note is ');
                   Provider.of<CartModel>(context, listen: false)
                        .setOrderNotes(note!);
                 addToCart(false, inStock || allowBackorder);
                      //addToCart(false,true,);
                 // variantKey.currentState.addToCart();
                    //code to execute when this button is pressed.
                }, 
                child: Text( S.of(context).addToCart.toUpperCase(),) 
              )
            ),
            )

          ]
        ),
        ),//
        
        SizedBox( 
             // height:42, //height of button
              width:double.infinity, //width of button
              child:
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,//Colors.black, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40.0),
              )),
                //  border: Border.all(
                //     color: const Color(0xff52260f),
                //     width: 1,
                //   ),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                 
                  if (note!.isNotEmpty) {
                  //  print('note is $note');
                    Provider.of<CartModel>(context, listen: false)
                        .setOrderNotes(note!);
                  }
                   printLog('note is ');
                  addToCart(true, inStock || allowBackorder);
                    // addToCart(true,true,);
                    //code to execute when this button is pressed.
                }, 
                child: Text(S.of(context).buyNow,style:TextStyle(color:Colors.white,)), //Theme.of(context).primaryColorLight)) 
              )
            ),
         
      
      
      ],
    // ),
  ),
              ),
      // Row(
      //   children: <Widget>[
      //     if (!ignoreBuyOrOutOfStockButton)
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: isAvailable
      //               ? () => addToCart(true, inStock || allowBackorder)
      //               : null,
      //           child: buyOrOutOfStockButton,
      //         ),
      //       ),
      //     if (!ignoreBuyOrOutOfStockButton) const SizedBox(width: 10),
      //     if (isAvailable &&
      //         (inStock || allowBackorder) &&
      //         !isExternal &&
      //         !isVariationLoading)
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () => addToCart(false, inStock || allowBackorder),
      //           child: Container(
      //             height: 44,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(3),
      //               color: Theme.of(context).primaryColorLight,
      //             ),
      //             child: Center(
      //               child: Text(
      //                 S.of(context).addToCart.toUpperCase(),
      //                 style: TextStyle(
      //                   color: Theme.of(context).colorScheme.secondary,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // )
    ];
  }

  /// Add to Cart & Buy Now function
  void addToCart(BuildContext context, Product product, int quantity,
      ProductVariation? productVariation, Map<String?, String?> mapAttribute,
      [bool buyNow = false, bool inStock = false]) {
    /// Out of stock || Variable product but not select any variant.
    if (!inStock || (product.isVariableProduct && mapAttribute.isEmpty)) {
      return;
    }

    final cartModel = Provider.of<CartModel>(context, listen: false);
    if (product.type == 'external') {
      openWebView(context, product);
      return;
    }

    final mapAttr = <String, String>{};
    for (var entry in mapAttribute.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key != null && value != null) {
        mapAttr[key] = value;
      }
    }

    productVariation =
        Provider.of<ProductModel>(context, listen: false).selectedVariation;
    var message = cartModel.addProductToCart(
        context: context,
        product: product,
        quantity: quantity,
        variation: productVariation,
        options: mapAttr);

    if (message.isNotEmpty) {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        persistent: !Config().isBuilder,
        builder: (context, controller) {
          return Flash(
            borderRadius: BorderRadius.circular(3.0),
            backgroundColor: Theme.of(context).errorColor,
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              content: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      );
    } else {
      if (buyNow) {
        FluxNavigate.pushNamed(
          RouteList.cart,
          arguments: CartScreenArgument(isModal: true, isBuyNow: true),
        );
      }
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        persistent: !Config().isBuilder,
        builder: (context, controller) {
          return Flash(
            borderRadius: BorderRadius.circular(3.0),
            backgroundColor: Theme.of(context).primaryColor,
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              title: Text(
                product.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
              content: Text(
                S.of(context).addToCartSucessfully,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  /// Support Affiliate product
  void openWebView(BuildContext context, Product product) {
    if (product.affiliateUrl == null || product.affiliateUrl!.isEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Center(
            child: Text(S.of(context).notFound),
          ),
        );
      }));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebView(
          url: product.affiliateUrl,
          title: product.name,
        ),
      ),
    );
  }
}
