// import 'dart:collection';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// import '../../../models/index.dart' show CartModel, Product, ProductModel;
// import '../../../services/services.dart';
// import '../../cart/cart_screen.dart';
// import '../product_detail_screen.dart';
// import '../widgets/index.dart';

// class HalfSizeLayout extends StatefulWidget {
//   final Product? product;
//   final bool isLoading;

//   const HalfSizeLayout({this.product, this.isLoading = false});

//   @override
//   State<HalfSizeLayout> createState() => _HalfSizeLayoutState();
// }

// class _HalfSizeLayoutState extends State<HalfSizeLayout>
//     with SingleTickerProviderStateMixin {
//   Map<String, String> mapAttribute = HashMap();
//   late final PageController _pageController = PageController();
//   final ScrollController _scrollController = ScrollController();

//   var top = 0.0;

//   Widget _getLowerLayer({width, height}) {
//     final heightVal = height ?? MediaQuery.of(context).size.height;
//     final widthVal = width ?? MediaQuery.of(context).size.width;
//     var totalCart = Provider.of<CartModel>(context).totalCartQuantity;

//     return Material(
//       child: Stack(
//         children: <Widget>[
//           if (widget.product?.imageFeature != null)
//             Positioned(
//               top: 0,
//               child: SizedBox(
//                 width: widthVal,
//                 height: heightVal,
//                 child: PageView(
//                   allowImplicitScrolling: true,
//                   controller: _pageController,
//                   children: [
//                     Image.network(
//                       widget.product?.imageFeature ?? '',
//                       fit: BoxFit.fitHeight,
//                     ),
//                     for (var i = 1;
//                         i < (widget.product?.images.length ?? 0);
//                         i++)
//                       Image.network(
//                         widget.product?.images[i] ?? '',
//                         fit: BoxFit.fitHeight,
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           if (widget.product?.imageFeature != null)
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.black45,
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: SmoothPageIndicator(
//                     controller: _pageController,
//                     count: widget.product?.images.length ?? 0,
//                     effect: const ScrollingDotsEffect(
//                       dotWidth: 5.0,
//                       dotHeight: 5.0,
//                       spacing: 15.0,
//                       fixedCenter: true,
//                       dotColor: Colors.black45,
//                       activeDotColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 40,
//             left: 20,
//             child: CircleAvatar(
//               backgroundColor: Colors.black.withOpacity(0.2),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.close,
//                   size: 18,
//                 ),
//                 onPressed: () {
//                   context.read<ProductModel>().clearProductVariations();
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ),
//           Positioned(
//             top: 30,
//             right: 4,
//             child: IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () => ProductDetailScreen.showMenu(
//                   context, widget.product,
//                   isLoading: widget.isLoading),
//             ),
//           ),
//           Positioned(
//             top: 30,
//             right: 40,
//             child: IconButton(
//                 icon: const Icon(
//                   Icons.shopping_cart,
//                   size: 22,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute<void>(
//                       builder: (BuildContext context) => Scaffold(
//                         backgroundColor: Theme.of(context).backgroundColor,
//                         body: const CartScreen(isModal: true),
//                       ),
//                       fullscreenDialog: true,
//                     ),
//                   );
//                 }),
//           ),
//           Positioned(
//             top: 36,
//             right: 44,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               constraints: const BoxConstraints(
//                 minWidth: 18,
//                 minHeight: 18,
//               ),
//               child: Text(
//                 totalCart.toString(),
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _getUpperLayer({width}) {
//     final widthVal = width ?? MediaQuery.of(context).size.width;

//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         width: widthVal,
//         decoration: const BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               offset: Offset(0, -2),
//               blurRadius: 20,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(Radius.circular(24)),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).backgroundColor.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(10.0)),
//               child: 
//               ChangeNotifierProvider(
//                 create: (_) => ProductModel(),
//                 child: SingleChildScrollView(
//                   controller: _scrollController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       ProductTitle(widget.product),
//                       ProductVariant(widget.product),
//                       ProductDescription(widget.product),
//                       Services()
//                           .widget
//                           .productReviewWidget(widget.product!.id!),
//                       RelatedProduct(widget.product),
//                       const SizedBox(
//                         height: 100,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Stack(
//           children: [
//             _getLowerLayer(
//               width: constraints.maxWidth,
//               height: constraints.maxHeight,
//             ),
//             SizedBox.expand(
//               child: DraggableScrollableSheet(
//                 initialChildSize: 0.5,
//                 minChildSize: 0.2,
//                 maxChildSize: 0.9,
//                 builder:
//                     (BuildContext context, ScrollController scrollController) =>
//                         SingleChildScrollView(
//                   controller: scrollController,
//                   child: _getUpperLayer(
//                     width: constraints.maxWidth,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//  ChangeNotifierProvider(
//                 create: (_) => ProductModel(),
//                 child: SingleChildScrollView(

                  ////
                  ////////////////////////////////////OLDSCREEN????????????????????????????????????

import 'dart:collection';
import 'dart:ui';
import 'dart:collection';
import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/index.dart' show Product,AppModel, ProductModel, UserModel;
import '../../../services/index.dart';
import '../../../widgets/product/product_bottom_sheet.dart';
//import '../../../widgets/product/widgets/heart_button2.dart';
import '../../../widgets/product/widgets/heart_button.dart';
import '../../chat/vendor_chat.dart';
import '../product_detail_screen.dart';
import '../widgets/index.dart';
import '../widgets/product_image_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/index.dart' show CartModel, Product, ProductModel;
import '../../cart/cart_screen.dart';
import '../product_detail_screen.dart';
//import '../widgets/index.dart';
import 'package:fstore/screens/detail/themes/custom_container_shape_border.dart';

class HalfSizeLayout extends StatefulWidget {
  final Product? product;
  final bool isLoading;

  const HalfSizeLayout({this.product, this.isLoading = false});

  @override
  _HalfSizeLayoutState createState() => _HalfSizeLayoutState();
}

class _HalfSizeLayoutState extends State<HalfSizeLayout>
    with SingleTickerProviderStateMixin {
  Map<String, String> mapAttribute = HashMap();
  late final PageController _pageController = PageController();
  late final RubberAnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  var top = 0.0;
  var opacityValue = 0.9;
  late Product product;
  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        initialValue: 0.5,
        lowerBoundValue: AnimationControllerValue(percentage: 0.15),
        halfBoundValue: AnimationControllerValue(percentage: 0.5),
        upperBoundValue: AnimationControllerValue(percentage: 0.9),
        duration: const Duration(milliseconds: 200));
    _controller.animationState.addListener(_stateListener);
    super.initState();
  }

  void _stateListener() {
    setState(() {
      opacityValue =
          _controller.animationState.value == AnimationState.collapsed
              ? 0.3
              : 0.9;
    });
  }
  



  Widget _getLowerLayer({width, height,product}) {
    final height0 = height ?? MediaQuery.of(context).size.height;
    final width0 = width ?? MediaQuery.of(context).size.width;
    var totalCart = Provider.of<CartModel>(context).totalCartQuantity;
    var heartproduct = product.price ?? '';
    print(heartproduct);
    ///
   
    ////
    return Scaffold(
      // backgroundColor:const Color(0xffd0d2dd),
                   // appBar: //PreferredSize(
         // preferredSize: Size.fromHeight(200.0), // here the desired height
        //  child: 
           appBar:  AppBar(
              backgroundColor:const Color(0xffff7a0a),
                       title: Container(
                               decoration: BoxDecoration(

 
                
                 
               // color:Colors.blue, //Theme.of(context).backgroundColor,
                color: Colors.white,
                    border: Border.all(
                    color:const Color(0xff52260f), //const Color(0xfffeae29),
                    width: 2,
                  ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff52260f),//Colors.black,
                    offset: Offset(1.0,0.0), 
                    //offset: Offset(1.0, 1.8), //(x,y)
                    blurRadius: 8.0,
                  ),
                ],
               

       // color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft:Radius.circular(15) ,
            topRight: Radius.circular(15),
             bottomRight:Radius.circular(15) ,
            bottomLeft: Radius.circular(15),
        ),
      ),

                        // color:Colors.white,
                        // padding:const EdgeInsets.only(bottom:5),
                         child:Image.network(
                                 'https://i.imgur.com/i3ZcLYi.png',
                                 width:85,
                                 height:85,
                                ),
                       ),
                    
           

                             
                      
             //centerTitle: true,
              leading:IconButton(
              icon: Icon(isIos ? Icons.arrow_back_ios : Icons.arrow_back, size: 25,color:Colors.white),
              onPressed:() {context.read<ProductModel>().clearProductVariations();
                  Navigator.pop(context);},  ),
              //backgroundColor:Colors.red,
              centerTitle: true,
              actions: <Widget>[
               
                  //  Positioned(
           // top: 36,
           // right: 80,
           // child:
           Padding(
             padding: const EdgeInsets.only(top:8),
                       child:
                         Stack(

                          children: <Widget>[
                             IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 25,
                  color:Colors.white,
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
                            Positioned(
                                right: 0,
                                top: 0,
                                child:
             Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                totalCart.toString(),
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
                            ),
                          ],
                        ),
                        ),
         // ),
                        if (widget.isLoading != true)
                          // HeartButton(
                          //   product: heartproduct,
                          //   size: 18.0,
                          //   color: Colors.white,//kGrey400,
                          // ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          //child: CircleAvatar(
                            //backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert, size: 25),
                              color: Colors.white,
                              onPressed: () => ProductDetailScreen.showMenu(
                                  context, widget.product,
                                  isLoading: widget.isLoading),
                            ),
                          //),
                        ),
                      ],
     
                      ),///appbar
                      
              
           
      
      
      body: Container(
                  width: 450.0,
                  height: 600.0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // This will hold the Image in the back ground:
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xffd0d2dd),),
                      ),
                      // This is the Custom Shape Container
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: Container(
                         // color: Colors.yellow,
                          child: CustomPaint(
                            painter: CustomContainerShapeBorder(
                              height: 300.0,
                              width: 409.0,
                              radius: 50.0,
                            ),
                          ),
                        ),
                      ),
                      // This Holds the Widgets Inside the the custom Container;
                      Positioned(
                        top: 10.0,
                        child: Container(
                          height: 260.0,
                          width: 260.0,
                          //color: Colors.grey.withOpacity(0.6),
                          child:  ClipOval(
  child: SizedBox.fromSize(
    size: Size.fromRadius(125), // Image radius
    child: PageView(
                  allowImplicitScrolling: true,
                  controller: _pageController,
                  children: [
                    Image.network(
                      widget.product?.imageFeature ?? '',
                      fit: BoxFit.cover
                    ),
                    for (var i = 1;
                        i < (widget.product?.images.length ?? 0);
                        i++)
                      Image.network(
                        widget.product?.images[i] ?? '',
                        fit: BoxFit.cover
                      ),
                  ],
                ),
    // Image.network( widget.product?.imageFeature ?? '', fit: BoxFit.cover),
  ),
),
                        ),
                      ),
                    ],
                  ),
                ),

    //Holds the Widgets Inside the the custom Container;
                    
                   

    );
  }

  Widget _getUpperLayer({width}) {
    final width0 = width ?? MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width0,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -2), blurRadius: 20),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .backgroundColor
                      .withOpacity(opacityValue),
                  borderRadius: BorderRadius.circular(10.0)),
              child: ChangeNotifierProvider(
                create: (_) => ProductModel(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ProductTitle(widget.product),
                      ProductVariant(widget.product),
                      ProductDescription(widget.product),
                      RelatedProduct(widget.product),
                      const SizedBox(
                        height: 100,
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

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var totalCart = Provider.of<CartModel>(context).totalCartQuantity;
    var heartproduct = widget.product ?? '';
        var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;

    // var heartproduct2 = widget.product.price ?? "";
   return Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/appbackground.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
     Text('ddddddddddddddddddddd'),
        Scaffold(
 backgroundColor: Colors.transparent,//heme.of(context).backgroundColor, //Colors.green,//const Color(0xffEAF1FF), //const Color(0xff52260f),
      // backgroundColor:const Color(0xffe7e9f5),
                   // appBar: //PreferredSize(
         // preferredSize: Size.fromHeight(200.0), // here the desired height
        //  child: 
           appBar:  AppBar(
              backgroundColor:isDarkTheme? Theme.of(context).backgroundColor : Colors.white,//Colors.white,//const Color(0xffff7a0a),
      //                  title: Container(
      //                          decoration: BoxDecoration(

 
                
                 
      //          // color:Colors.blue, //Theme.of(context).backgroundColor,
      //           color: Colors.white,
      //               border: Border.all(
      //               color:const Color(0xff52260f), //const Color(0xfffeae29),
      //               width: 2,
      //             ),
      //           boxShadow: [
      //             BoxShadow(
      //               color: const Color(0xff52260f),//Colors.black,
      //               offset: Offset(1.0,0.0), 
      //               //offset: Offset(1.0, 1.8), //(x,y)
      //               blurRadius: 8.0,
      //             ),
      //           ],
               

      //  // color: Colors.white,
      //   borderRadius: BorderRadius.only(
      //       topLeft:Radius.circular(15) ,
      //       topRight: Radius.circular(15),
      //        bottomRight:Radius.circular(15) ,
      //       bottomLeft: Radius.circular(15),
      //   ),
      // ),

      //                   // color:Colors.white,
      //                   // padding:const EdgeInsets.only(bottom:5),
      //                    child:Image.network(
      //                            'https://i.imgur.com/i3ZcLYi.png',
      //                            width:85,
      //                            height:85,
      //                           ),
      //                  ),
                    
           

                             
                      
             //centerTitle: true,
          //      flexibleSpace:Container(
          //   decoration: const  BoxDecoration(
          //    gradient: LinearGradient(
                
          //       begin: FractionalOffset(0.0,0.0),
          //       end : FractionalOffset(0.0,1.0),
          //       stops:[0.0,1.0],
          //       tileMode:TileMode.clamp,
          //       colors:[
          //         const Color(0xffff7a0a),
          //          const Color(0xfffeae29),
          //          //const //Color(0xff52260f),
          //         // backgroundColor: const Color(0xff52260f),
                    

          //     ],
          //     ),
          //   ),
          // ), 
           shape: Border(
    bottom: BorderSide(
      color:const Color(0xffff7a0a), //Colors.orange,const Color(0xff52260f)
      width: 1
    ),
  ),
  elevation: 4,
              leading: !isDarkTheme ? IconButton(
              icon: Icon(isIos ? Icons.arrow_back_ios : Icons.arrow_back, size: 25,color:Colors.black),
              onPressed:() {context.read<ProductModel>().clearProductVariations();
                  Navigator.pop(context);},  ): IconButton(
              icon: Icon(isIos ? Icons.arrow_back_ios : Icons.arrow_back, size: 25,color:Colors.white),
              onPressed:() {context.read<ProductModel>().clearProductVariations();
                  Navigator.pop(context);},  ),
             // backgroundColor:Colors.red,
              centerTitle: true,
              actions: <Widget>[
                if (widget.isLoading != true)
                // !isDarkTheme ?
                //        HeartButton(
                //             product: widget.product!,
                //             size: 25.0,
                //            //color: Colors.white,//kGrey400,
                //           ):HeartButton(
                //             product: widget.product!,
                //             size: 25.0,
                //            //color: Colors.white,//kGrey400,
                //           ),
                       
               
                  //  Positioned(
           // top: 36,
           // right: 80,
           // child:
           Padding(
           padding: const EdgeInsets.all(8),
                       child:
                         Stack(

                          children: <Widget>[
                           ! isDarkTheme ?
                             IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 25,
                  color:Colors.black,//Color(0xff52260f),
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
                }):      IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 25,
                  color:Colors.white,//Color(0xff52260f),
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
                if(totalCart > 0)
                            Positioned(
                                right: 0,
                                top: 0,
                                child:
             Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color:const Color(0xffff7a0a),// Colors.black,
                borderRadius: BorderRadius.circular(9),
              ),
              constraints: const BoxConstraints(
                minWidth: 10,
                minHeight: 10,
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
                          ],
                        ),
                        ),
         // ),
                        
                        Padding(
                          padding: const EdgeInsets.all(0),
                          //child: CircleAvatar(
                            //backgroundColor: Colors.white,
                            child: !isDarkTheme ? IconButton(
                              icon: const Icon(Icons.more_vert, size: 25),
                              color:Colors.black,//Color(0xff52260f),
                              onPressed: () => ProductDetailScreen.showMenu(
                                  context, widget.product,
                                  isLoading: widget.isLoading),
                            ):IconButton(
                              icon: const Icon(Icons.more_vert, size: 25),
                              color:Colors.white,//Color(0xff52260f),
                              onPressed: () => ProductDetailScreen.showMenu(
                                  context, widget.product,
                                  isLoading: widget.isLoading),
                            ),
                          //),
                        ),
                      ],
     
                      ),///appbar
                      
              
           
      //body:
      
      body: ChangeNotifierProvider(
                create: (_) => ProductModel(),
                child:
                Container( child: 
       SingleChildScrollView(
        child: Container(
         // width:MediaQuery.of(context).size.width,
         // width: double.infinity,
          margin: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
      ///Container half  containg Circle 
      Container(
        width:MediaQuery.of(context).size.width,
                // width:420.0,////length600
                //  height: 420.0,
                //color: Colors.red,
              child:Text('ddd'),
 
//////////////////////////////////////////////////////////
                      ),
                      
                      ///////////////////////////////////

    //child: 
                 
                  // Stack(
                  //   alignment: Alignment.bottomCenter,
                  //   children: [
                      
                  //     // This Holds the Widgets Inside the the custom Container;
                  //     Positioned(
                        // top: 0.0,
                        // child: 
                        // Column(
                        //   children:[
                               SizedBox(height:8),
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
                                    color: Colors.white,
                                  // border: Border.all(color: Colors.red,  width: 5,),
                                    shape: BoxShape.circle,
                                ),
                          height: MediaQuery.of(context).size.width * 0.8,//300.0,
                          width: MediaQuery.of(context).size.width* 0.8,
                         // color: Colors.black,//Colors.grey.withOpacity(0.6),
                          child:  ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(125), // Image radius
                            child: PageView(
                            allowImplicitScrolling: true,
                            controller: _pageController,
                            children: [
                              Image.network(
                                widget.product?.imageFeature ?? '',
                                                    fit: BoxFit.contain
                                        ),
                                        for (var i = 1;
                                            i < (widget.product?.images.length ?? 0);
                                            i++)
                                          Image.network(
                                            widget.product?.images[i] ?? '',
                                            fit: BoxFit.contain
                                          ),
                                      ],
                                    ),
                        // Image.network( widget.product?.imageFeature ?? '', fit: BoxFit.cover),
  ),
),
                        
                        ),
                        SizedBox(height:5),
              //             Positioned(
              // top: 0,
              // left: 0,
              // right: 0,
              // child: SafeArea(
              //     child: SmoothPageIndicator(
              //       controller: _pageController,
              //       count: widget.product?.images.length ?? 0,
              //       effect: const ScrollingDotsEffect(
              //         dotWidth: 10.0,
              //         dotHeight: 10.0,
              //         spacing: 10.0,
              //         fixedCenter: true,
              //         dotColor: Colors.black,
              //         activeDotColor: Colors.white,
              //       ),
              //     ),
              //   ),
            
              //   ),///main white container
                SizedBox(height:20),
                Padding(
                  padding: const EdgeInsets.only(right:15),
                  child:
                        ProductTitle(widget.product),
                ),
                      //   Flexible(
                      //  // alignment:Alignment.bottomLeft,
                      //   child: 
                      // ),
                            SizedBox(height:10),
                               
                 Container(
                 // height:90,
                  color:Colors.white.withOpacity(0.6),
                  margin:EdgeInsets.only(top:20),
                  child:Center(child:   ProductDescription(widget.product),)
                  
                ),

                        //   ]
                        // ) 


                      ////////////////////////////////////
                      
                      ///main red Container
                      //button of transilation
                       SizedBox(height:20),
                
                Container(
                  //margin:const EdgeInsets.only(right:5,left:5),
                  padding:const EdgeInsets.only(top:15,left:5,right:5),
                 // height:90,
                  color:Colors.white.withOpacity(0.6),
                 // margin:EdgeInsets.all(5),
                 // child:Center(
                    child: ProductVariant(widget.product),
                   // ,)
                  
                ),
               // SizedBox(height:20),
              
                SizedBox(height:40),
               //  ProductDetailCategories(product),

               //  ProductDescription(widget.product),
              //  ProductVariant(widget.product),
                
                    // RelatedProduct(widget.product),
                   
            ]
          ),
        ),
      ),
      ),
      ),

  
   )

        ],
    );
    
    
    
    
    //return LayoutBuilder
    
    
    
    // (
    //   builder: (context, constraints) {
    //     return RubberBottomSheet(
    //       lowerLayer: _getLowerLayer(
    //           width: constraints.maxWidth, height: constraints.maxHeight,product:widget.product),
    //       upperLayer: _getUpperLayer(width: constraints.maxWidth),
    //       animationController: _controller,
    //       scrollController: _scrollController,
    //     );
    //   },
    // );
  }
}











////////////
//   Container(
                      //      height: 500,
                      //   alignment: Alignment.bottomCenter,
                      // // width: MediaQuery.of(context).size.width,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(5.0),
                      //     color: Colors.white,
                      //       ),
                      // ),
                      // This will hold the Image in the back ground:
            //           Container(
            //             height:650,
            //             margin: EdgeInsets.only(right:8),
            //             alignment: Alignment.bottomCenter,
            //           // width: MediaQuery.of(context).size.width,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.only(
            // topRight: Radius.circular(120.0),
            // bottomRight: Radius.circular(80.0),
            // topLeft: Radius.circular( 0.0),
            // bottomLeft: Radius.circular(80.0)),
            //               //  borderRadius: BorderRadius.circular(80),
            //               color: Colors.white,//const Color(0xffff7a0a),//const Color(0xff52260f),
            //                 ),
            //           ),

      
                      // This is the Custom Shape Container
                      // Positioned(
                      //   bottom: 0.0,
                      //   left: 0.0,
                      //   child: Container(
                      //     padding: const EdgeInsets.only(right:10),
                      //    // alignment: Alignment.bottomCenter,
                      //     width:MediaQuery.of(context).size.width,
                      //    color: Colors.transparent,
                      //     child: CustomPaint(
                      //       painter: CustomContainerShapeBorder(
                      //        height: 270.0,
                      //        width: MediaQuery.of(context).size.width,
                      //         radius: 80.0,
                      //       ),
                      //     ),
                      //   ),
                      // ),///////to remove
          //             Image.asset(
          //   "assets/images/background.png",
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),