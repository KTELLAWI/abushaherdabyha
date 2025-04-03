


import 'dart:collection';
import 'dart:ui';
import 'package:quiver/strings.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../models/index.dart' show CartModel, Product, ProductModel,AppModel,ProductVariation,ProductAttribute;
import '../../../services/services.dart';
import '../../cart/cart_screen.dart';
import '../product_detail_screen.dart';
import '../widgets/index.dart';
import 'package:flash/flash.dart';
import '../../../common/config.dart';
import '../../../routes/flux_navigate.dart';
import '../../../generated/l10n.dart';
import '../../../common/tools/tools.dart';
import '../../../screens/cart/cart_screen.dart';
import '../../../services/service_config.dart';
import '../../../common/constants.dart';
import '../../../services/index.dart';
import 'dart:math' as math;
import '../../../common/tools/flash.dart';
import '../../../common/tools.dart';
import '../../../common/constants.dart';
import '../../../widgets/common/loading_widget.dart';





//import '../widgets/product_variant_button.dart';




class HalfSizeLayout extends StatefulWidget {
  final Product? product;
  final bool isLoading;
  

  const HalfSizeLayout({this.product, this.isLoading = false});

  @override
  State<HalfSizeLayout> createState() => _HalfSizeLayoutState();
}

class _HalfSizeLayoutState extends State<HalfSizeLayout>
    with SingleTickerProviderStateMixin {
  //Map<String, String> mapAttribute = HashMap();
  late final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
   // ProductVariation? productVariation;
  var top = 0.0;
 TextEditingController note = TextEditingController();
 final services = Services();
late Product product;
 //Map<String?, String?>? mapAttribute;
  ProductVariation? productVariation;
  String? price;
    var regularPrice;
bool loadingState = true;

  List<ProductVariation>? get variations =>
      context.select((ProductModel _) => _.variations);
  Map<String?, String?>? mapAttribute;

  int quantity = 1;
// final variantKey = GlobalKey <_StateProductVariant>();
 @override
  void initState() {
    super.initState();
   
           Future.delayed(Duration(seconds:2), () {
                  

                   setState((){
                    
                  
                    loadingState = false;
              
             
                   });
              
              });

    product = widget.product as Product;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          //quantity = widget.defaultQuantity;
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
  int getMaxQuantity() {
    var limitSelectQuantity = 50;
        return limitSelectQuantity;
  }
void addToCart([bool buyNow = false, bool inStock = false]) {
    services.widget.addToCart(context, product, quantity, productVariation,
        mapAttribute ?? {}, buyNow, inStock);
  }

 List<Widget> getBuyButtonWidget() {
    if (product!.id=='29' || product!.id=='27' ){
      quantity=5;
    }
    var fullNote = product!.name! + ":" + note!.text!;
    return services.widget.getBuyButtonWidget(context, productVariation,
        widget!.product!, mapAttribute, getMaxQuantity(), quantity, addToCart, (val) {
      quantity = val;
    }, variations, fullNote);
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
       // getProductPrice();

        /// Show selected product variation image in gallery.
        final attrType = kProductVariantLayout[attr.cleanSlug ?? attr.name] ??
            kProductVariantLayout[attr.name!.toLowerCase()] ??
          'box';
        // if (widget.onSelectVariantImage != null && attrType == 'image') {
        //   for (var option in attr.options!) {
        //     if (option['name'] == val &&
        //         option['description'].toString().contains('http')) {
        //       final selectedImageUrl = option['description'];
        //     //  widget.onSelectVariantImage!(selectedImageUrl);
        //     }
        //   }
        // }
      },
    );
  }

  List<Widget> getProductAttributeWidget() {
    final lang = Provider.of<AppModel>(context, listen: false).langCode;
    if (mapAttribute == null && Config().type != ConfigType.opencart) {
      return [];
    }
    return 
    services.widget.getProductAttributeWidget(
        lang, product, mapAttribute, onSelectProductVariantButton, variations!);
       
  }

  getProductPrice() {
    try {
      regularPrice = productVariation != null
          ? productVariation!.regularPrice
          : widget.product!.regularPrice;
      // onSale = productVariation != null
      //     ? productVariation!.onSale ?? false
      //     : widget.product!.onSale ?? false;
      price = productVariation != null &&
              (productVariation?.price?.isNotEmpty ?? false)
          ? productVariation!.price
          : 
         isNotBlank(widget.product!.price)
              ? widget.product!.price
              : widget.product!.regularPrice;

      /// update the Sale price
      // if (onSale) {
      //   price = productVariation != null
      //       ? productVariation!.salePrice
      //       : isNotBlank(widget.product!.salePrice)
      //           ? widget.product!.salePrice
      //           : widget.product!.price;
      //   dateOnSaleTo = productVariation != null
      //       ? productVariation!.dateOnSaleTo
      //       : widget.product!.dateOnSaleTo;
      // }

      // if (onSale && regularPrice.isNotEmpty && double.parse(regularPrice) > 0) {
      //   sale = (100 - (double.parse(price!) / double.parse(regularPrice)) * 100)
      //       .toInt();
      // }
    } catch (e, trace) {
      printLog(trace);
      printLog(e);
    }
  }
  // @override
  // void afterFirstLayout(BuildContext context) async {
  //   getProductPrice();
  // }

  Widget _getLowerLayer({width, height}) {
    final heightVal = height ?? MediaQuery.of(context).size.height;
    final widthVal = width ?? MediaQuery.of(context).size.width;
   
    //var totalCart = Provider.of<CartModel>(context).totalCartQuantity;

    return Material(
      color:Colors.transparent,
      child: Stack(
        children: <Widget>[
          Provider.of<AppModel>(context, listen: true).darkTheme ? Container():
            Image.network(
            "https://abushaherdabayh.site/wp-content/uploads/2022/10/appBackground.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ) ,
          
          
          if (widget.product?.imageFeature != null)
            Positioned(
              top: 0,
              child: SizedBox(
                width: widthVal ,
                height: heightVal * 0.7,
               // child:

                //////////////////////////////////////////////////////////////
                child: 
                                                    Container(
                            decoration: BoxDecoration(
                                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xffffff),//const Color(0xff52260f),//Colors.black,
                                              offset: Offset(1.0,1.0), 
                                              //offset: Offset(1.0, 1.8), //(x,y)
                                              blurRadius: 1.5,
                                            ),
                                          ],
                                    color:  Provider.of<AppModel>(context, listen: false).darkTheme ? Colors.white.withOpacity(0.7) : Colors.transparent,
                                  // border: Border.all(color: Colors.red,  width: 5,),
                                    shape: BoxShape.circle,
                                ),
                          height: MediaQuery.of(context).size.width * 0.5,//300.0,
                         width: MediaQuery.of(context).size.width* 0.5,
                         // color: Colors.black,//Colors.grey.withOpacity(0.6),
                          // child:  ClipOval(
                          // child: SizedBox.fromSize(
                          //   size: Size.fromRadius(0), 
                            // Image radius
                            child:  PageView(
                  allowImplicitScrolling: true,
                  controller: _pageController,
                  children: [
                    Image.network(
                      widget.product?.imageFeature ?? '',
                      fit: BoxFit.fill,
                    ),
                    for (var i = 1;
                        i < (widget.product?.images.length ?? 0);
                        i++)
                      Image.network(
                        widget.product?.images[i] ?? '',
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
                            
                            // PageView(
                            // allowImplicitScrolling: true,
                            // controller: _pageController,
                            // children: [
                            //   Image.network(
                            //     widget.product?.imageFeature ?? '',
                            //                         fit: BoxFit.contain
                            //             ),
                            //             for (var i = 1;
                            //                 i < (widget.product?.images.length ?? 0);
                            //                 i++)
                            //               Image.network(
                            //                 widget.product?.images[i] ?? '',
                            //                 fit: BoxFit.contain
                            //               ),
                            //           ],
                            //         ),
                        // Image.network( widget.product?.imageFeature ?? '', fit: BoxFit.cover),
 // ),
//),
                        
                        ), 

                // PageView(
                //   allowImplicitScrolling: true,
                //   controller: _pageController,
                //   children: [
                //     Image.network(
                //       widget.product?.imageFeature ?? '',
                //       fit: BoxFit.contain,
                //     ),
                //     for (var i = 1;
                //         i < (widget.product?.images.length ?? 0);
                //         i++)
                //       Image.network(
                //         widget.product?.images[i] ?? '',
                //         fit: BoxFit.contain,
                //       ),
                //   ],
                // ),
              ),
            ),
          if (widget.product?.imageFeature != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black45,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.product?.images.length ?? 0,
                    effect: const ScrollingDotsEffect(
                      dotWidth: 5.0,
                      dotHeight: 5.0,
                      spacing: 15.0,
                      fixedCenter: true,
                      dotColor: Colors.black45,
                      activeDotColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                ),
                onPressed: () {
                  context.read<ProductModel>().clearProductVariations();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => ProductDetailScreen.showMenu(
                  context, widget.product,
                  isLoading: widget.isLoading),
            ),
          ),
          Positioned(
            top: 30,
            right: 40,
            child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 22,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Scaffold(
                        backgroundColor: Theme.of(context).backgroundColor,
                        body: const CartScreen(isModal: true),
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                }),
          ),
          Positioned(
            top: 36,
            right: 44,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                "totalCart.toString()",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getUpperLayer({width}) {
    final widthVal = width ?? MediaQuery.of(context).size.width;
    final darkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;
     //FlashHelper.init(context);
           //   productVariation = Provider.of<ProductModel>(context, listen:false).selectedVariation;
               getProductPrice();

    
    // final isVariationLoading = productVariation == null &&
    //     (variations?.isEmpty ?? true) &&
    //     Config().type != ConfigType.opencart &&
    //     Config().type != ConfigType.notion;
 // TextEditingController note = TextEditingController();

    return Material(
      color: Colors.transparent,
      child: Container(
       
        width: widthVal,
        decoration:  BoxDecoration(
             border: Border.all(
                    color: const Color(0xff52260f),
                    width: 1,
                  ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
      //  color: Provider.of<AppModel>(context, listen: false).darkTheme ? Colors.black.withOpacity(0.7): Colors.transparent,//Colors.grey.withOpacity(0.6),

          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     offset: Offset(0, -2),
          //     blurRadius: 20,
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
              decoration: BoxDecoration(
                 border: Border.all(
                    color: const Color(0xff52260f),
                    width: 1,
                  ),
                 color:Provider.of<AppModel>(context, listen: false).darkTheme ? Colors.white.withOpacity(0.5): Theme.of(context).backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0)),
              child: 
              ChangeNotifierProvider(
                create: (_) => ProductModel(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                 // physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                   // crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      
              //            Flexible(
              // child:
             SizedBox(height:  (MediaQuery.of(context).size.width * 0.25)/2,),
               Text(
                widget.product?.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .apply(fontSizeFactor: 0.9),
              ),
          //  ),
                     // ProductTitle(widget.product),
                      SizedBox(height:15),
                      if (widget!.product!.id == '2440' ||widget!.product!.id ==   '2441' || widget!.product!.id == "3486" || widget!.product!.id == "3484")
                      Text( context.isRtl ?'أقل كمية هي 5 كليو غرام' : 'Minimum is 5 KG',textAlign:TextAlign.start),
                    // ProductVariantButton(widget.product,false),
                    
                      SizedBox(height:30),
                   //  if (!isVariationLoading) 
                    ...getProductAttributeWidget(),
                       const SizedBox(height: 10),
                      
        Services().widget.renderDetailPrice(context, widget.product!, price) ,
         // ProductTitle1(widget.product),
        const SizedBox(height: 20),
                      ProductDescription(widget.product),
                       SizedBox(height:30),
            //                TextField(
            //                 maxLines: 4,
            //                 controller: note,
            //                 style: const TextStyle(fontSize: 13),
            //                 decoration: InputDecoration(
            //                    focusedBorder: OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
            // ),
            //                     hintText: S.of(context).writeYourNote,
            //                     hintStyle: const TextStyle(fontSize: 12),
            //                     border: InputBorder.none
            //                     ),
            //               ),
                          //
                          TextField(
                             maxLines: 4,
                              controller: note,
            decoration: InputDecoration(
                labelText: S.of(context).writeYourNote,//'Enter something',
                labelStyle: const TextStyle(fontSize: 13),
           
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(width: 1, color:darkTheme ? Theme.of(context).backgroundColor :Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(width: 2, color: Color(0xffeac85f),),
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
      
                       // ),
                      // Services()
                      //     .widget
                      //     .productReviewWidget(widget.product!.id!),
                      // RelatedProduct(widget.product),
                      const SizedBox(
                        height: 150,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // ignore: always_declare_return_types
  // getProductPrice() {
  //   try {
  //     regularPrice = productVariation != null
  //         ? productVariation!.regularPrice
  //         : widget.product!.regularPrice;
   
  //     // price = productVariation != null &&
  //     //         (productVariation?.price?.isNotEmpty ?? false)
  //     //     ? productVariation!.price
  //     //     : isNotBlank(widget.product!.price)
  //     //         ? widget.product!.price
  //     //         : widget.product!.regularPrice;

  //     /// update the Sale price
   

   
  //   } catch (e, trace) {
  //   //   printLog(trace);
  //   //   printLog(e);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
        var totalCart = Provider.of<CartModel>(context).totalCartQuantity;
         if (product!.id =='2440' ||product!.id =='2441' )
    {
       setState((){
                    
                  
                    loadingState = false;
              
             
                   });

    }
        
        // Future.delayed(Duration(seconds:2), () {
                  
        //            setState((){
                    
                  
        //             loadingState = false;
              
             
        //            });
              
        //       });
    
    // FlashHelper.init(context);

    //  productVariation = Provider.of<ProductModel>(context,listen: true).selectedVariation;
      // getProductPrice();
        //gprint(variantKey.currentState);
    // return
    //  LayoutBuilder(
    //   builder: (context, constraints) {
        return SafeArea(
          child:
          // ChangeNotifierProvider(
          //       create: (_) => ProductModel(),
          //       child:
        Stack(
          children: [
         Provider.of<AppModel>(context, listen: true).darkTheme ? Container(color:Colors.transparent):
            Image.network(
            "https://abushaherdabayh.site/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ) ,
            Positioned(
            top: 12,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
              totalCart.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
   Positioned(
            top: 6,
            right: 10,
            child: IconButton(
                icon:  Icon(
                  Icons.shopping_cart,
                  size: 22,
                  color:Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Scaffold(
                        backgroundColor: Theme.of(context).backgroundColor,
                        body: const CartScreen(isModal: true),
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                }),
          ),
          Positioned(
            top: 6,
            left: 10,
            child: IconButton(
              icon:  Icon(Icons.share,color:Theme.of(context).primaryColor,),
              onPressed: () => ProductDetailScreen.showMenu(
                  context, widget.product,
                  isLoading: widget.isLoading),
            ),
          ),
        
            // _getLowerLayer(
            //   width: constraints.maxWidth,
            //   height: constraints.maxHeight,
            // ),
            // SizedBox.expand(
            //   child: 
              // DraggableScrollableSheet(
              //   initialChildSize: 0.5,
              //  minChildSize: 0.2,
              //    maxChildSize: 0.9,
              //   builder:
              //       (BuildContext context, ScrollController scrollController) =>
                    
                         Padding(
                padding:  EdgeInsets.only(top:  (MediaQuery.of(context).size.width * 0.28)/2,bottom:6 ,left:8,right:6,),
// MediaQuery.of(context).size.width * 0.25,
                // left: 0,
                // right: 0,
                // bottom: 0,
                //         child: ChangeNotifierProvider(
                // create: (_) => ProductModel(),
                child:
                        _getUpperLayer(
                        // Column(
                        //   children:[        
                //              SingleChildScrollView(
                //              scrollDirection: Axis.vertical,
                //  // controller: scrollController,
                //   child: 
                //     width: constraints.maxWidth,
                //   ),
                ),
                      //  )
                // ]
                //  )       ),
                     ),
                //        SingleChildScrollView(
                //  // controller: scrollController,
                //   child: _getUpperLayer(
                //     width: constraints.maxWidth,
                //   ),
                // ),
                  
                  Padding(
                    padding: EdgeInsets.only(top:5),

                    child:   Align(
              alignment:Alignment.topCenter,
              child:  ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(35)), 
             child: Container(
                            decoration: BoxDecoration(
                                          //                 boxShadow: [
                                          //   BoxShadow(
                                          //     color: Color(0xffffff),//const Color(0xff52260f),//Colors.black,
                                          //     offset: Offset(1.0,1.0), 
                                          //     //offset: Offset(1.0, 1.8), //(x,y)
                                          //     blurRadius: 1.5,
                                          //   ),
                                          // ],
                                 //   color:  Provider.of<AppModel>(context, listen: false).darkTheme ? Colors.white.withOpacity(0.7) : Colors.transparent,
                                  // border: Border.all(color: Colors.red,  width: 5,),
                                  //   shape: BoxShape.circle,
                                ),
                          height: MediaQuery.of(context).size.width * 0.3,//300.0,
                         width: MediaQuery.of(context).size.width* 0.3,
                         // color: Colors.black,//Colors.grey.withOpacity(0.6),
                          // child:  ClipOval(2
                          // child: SizedBox.fromSize(
                          //   size: Size.fromRadius(0), 
                            // Image radius
                            child:
              Image.network(
                      widget.product?.imageFeature ?? '',
                      fit: BoxFit.fill,
                    ),
            ),
              ),
        ),
                  ),
      //  Align(
      //   alignment:Alignment.bottomCenter,
      //   child: ProductVariantButton(widget.product),
      //  ),
      //  Padding(
      //   padding:EdgeInsets.only(bottom:50,left:8,right:6,),
      //   child: Align(
      //         alignment:Alignment.bottomCenter,
      //         child:
      //          Row(
      //     children:[
      //       Expanded(
      //         child:SizedBox( 
      //        // height:42, //height of button
      //         width:double.infinity, //width of button
      //         child:ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //             primary: Colors.green, //background color of button
                
      //             shape:RoundedRectangleBorder(
      //             borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(00.0),
      //         )),
      //             padding: EdgeInsets.all(20) //content padding inside button
      //           ),
      //           onPressed: (){ 
      //             //addToCart(true,true,);
      //               //code to execute when this button is pressed.
      //           }, 
      //           child: Text("Elevated Button") 
      //         )
      //       ),
      //       ),
      //       Expanded(
      //         child:SizedBox( 
      //        // height:42, //height of button
      //         width:double.infinity, //width of button
      //         child:ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //             primary: Colors.green, //background color of button
                
      //             shape:RoundedRectangleBorder(
      //             borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(00.0),
      //         )),
      //             padding: EdgeInsets.all(20) //content padding inside button
      //           ),
      //           onPressed: (){ 
      //            // variantKey.currentState.addToCart();
      //               //code to execute when this button is pressed.
      //           }, 
      //           child: Text("Elevated Button") 
      //         )
      //       ),
      //       )

      //     ]
      //   ),
      //         ),
       
      
      //  ),
       //ProductVariantButton(widget.product),
       Padding(
        padding:EdgeInsets.only(bottom:6,left:8,right:6,),
        child:
         Align(
              alignment:Alignment.bottomCenter,
         
          child:ChangeNotifierProvider(
                create: (_) => ProductModel(),
                child: 
                //ProductVariantButton(widget.product,true,),
              Container(
              //  color:Colors.white,
                child:  Column(
                          mainAxisAlignment:MainAxisAlignment.end,

                  children:
 getBuyButtonWidget(),
                  
                )
              ),
               
          //Text('ddd'),
        // ProductVariantButton(widget.product,true,),
          )
          // SizedBox( 
          //     height:42, //height of button
          //     width:double.infinity, //width of button
          //     child:
          //     ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         primary: Colors.black, //background color of button
                
          //         shape:RoundedRectangleBorder(
          //         borderRadius: BorderRadius.vertical(
          //       bottom: Radius.circular(40.0),
          //     )),
          //         padding: EdgeInsets.all(20) //content padding inside button
          //       ),
          //       onPressed: (){ 
          //           //code to execute when this button is pressed.
          //       }, 
          //       child: Text("Elevated Button") 
          //     )
          //   )
          // ElevatedButton (
          //     onPressed: () {},
          //     // shape: RoundedRectangleBorder(
          //     //     borderRadius: BorderRadius.only(
          //     //         topLeft: Radius.circular(15.0),
          //     //         topRight: Radius.circular(15.0))),
          //     child: Text('Click Me!'),
          //     // color: Colors.blueAccent,
          //     // textColor: Colors.white,
          //   )
        //)
      // )
       
             ),
            ),

          if(loadingState)
            LoadingWidget(),
          //  LoadingOverlay(
          //    isLoading:loadingState,
          //    color:Colors.white,
          //    // child: SingleChildScrollView(
          //       child: Container(
          //         child:Center(
          //           child:SpinKitCubeGrid(
          //   color: Theme.of(context).primaryColor,
          //   size: 50.0,
          // ),
          //         )
          //       )
          //   ),  
          ],
        ),
        //),
        );//safe
    //  },
   // );
  }
}

//  ChangeNotifierProvider(
//                 create: (_) => ProductModel(),
//                 child: SingleChildScrollView(

                  //
                  //////////////////////////////////OLDSCREEN????????????????????????????????????