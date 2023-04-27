import 'dart:convert' as convert;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/booking/booking_model.dart';
import '../../../models/index.dart'
    show AppModel, CartModel, Order, PaymentMethodModel, TaxModel, UserModel;
import '../../../modules/native_payment/credit_card/index.dart';
import '../../../modules/native_payment/mercado_pago/index.dart';
import '../../../modules/native_payment/paypal/index.dart';
import '../../../modules/native_payment/paytm/services.dart';
import '../../../modules/native_payment/razorpay/services.dart';
import '../../../services/index.dart';
import '../../../widgets/common/common_safe_area.dart';
import '../../../modules/dynamic_layout/banner/banner_slider.dart';
import '../../../modules/dynamic_layout/config/banner_config.dart';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

import 'card_model.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethods extends StatefulWidget {
  final Function? onBack;
  final Function? onFinish;
  final Function(bool)? onLoading;

  const PaymentMethods({this.onBack, this.onFinish, this.onLoading});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> with RazorDelegate ,SingleTickerProviderStateMixin {
  String? selectedId;
  bool isPaying = false;
final ScrollController _scrollController = ScrollController();
bool _confirm = false;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animationController.forward();

    Future.delayed(Duration.zero, () {
      final cartModel = Provider.of<CartModel>(context, listen: false);
      final userModel = Provider.of<UserModel>(context, listen: false);
      final langCode = Provider.of<AppModel>(context, listen: false).langCode;
      Provider.of<PaymentMethodModel>(context, listen: false).getPaymentMethods(
          cartModel: cartModel,
          shippingMethod: cartModel.shippingMethod,
          token: userModel.user != null ? userModel.user!.cookie : null,
          langCode: langCode);

      if (kPaymentConfig.enableReview != true) {
        Provider.of<TaxModel>(context, listen: false)
            .getTaxes(Provider.of<CartModel>(context, listen: false),
                (taxesTotal, taxes) {
          Provider.of<CartModel>(context, listen: false).taxesTotal =
              taxesTotal;
          Provider.of<CartModel>(context, listen: false).taxes = taxes;
          setState(() {});
        });
      }
    });
  }
 int _selectedIndex = 0;

  List<String> _tabs = ["Home", "Finance", "Cards", "Crypto", "History"];
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);
    final taxModel = Provider.of<TaxModel>(context);
    final ScrollController _scrollController = ScrollController();

    return 
    Stack(
      children: [
      //  Expanded(
        //  child: 
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ListenableProvider.value(
              value: paymentMethodModel,
              child:
              //  Stack(
              //   children:[
                    SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(S.of(context).paymentMethods,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      S.of(context).chooseYourPaymentMethod,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                      ),
                    ),
                    Services().widget.renderPayByWallet(context),
                    const SizedBox(height: 20),
                    Consumer<PaymentMethodModel>(
                        builder: (context, model, child) {
                      if (model.isLoading) {
                        return SizedBox(
                            height: 100, child: kLoadingWidget(context));
                      }

                      if (model.message != null) {
                        return SizedBox(
                          height: 100,
                          child: Center(
                              child: Text(model.message!,
                                  style: const TextStyle(color: kErrorRed))),
                        );
                      }

                      if (selectedId == null &&
                          model.paymentMethods.isNotEmpty) {
                        selectedId = model.paymentMethods
                            .firstWhere((item) => item.enabled!)
                            .id;
                      }

                      return Column(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < model.paymentMethods.length; i++)
                            model.paymentMethods[i].enabled!
                                ? Services().widget.renderPaymentMethodItem(
                                    context, model.paymentMethods[i], (i) {
                                    setState(() {
                                      selectedId = i;
                                    });
                                  }, selectedId)
                                : const SizedBox()
                        ],
                      );
                    }),
                    const SizedBox(height: 20),
              
                    const SizedBox(height: 20),
                  ],
                ),


              ),//scrolll

              // Positioned(
              //   bottom:0,
              
             


              //   ],//stack
              // ),//stack
              
            
            ),
          ),///PADDING 1 WIDGET
          
            Align(

            alignment:Alignment.bottomCenter,
            child: Container(
              //   initialChildSize: 0.5,
              //  minChildSize: 0.2,
              //    maxChildSize: 0.9,
              //   builder:
              //       (BuildContext context, ScrollController scrollController) =>
                     child:   SingleChildScrollView(
                  //controller: scrollController,
                 // child: 
                  
                //   _getUpperLayer(
                //     width: constraints.maxWidth,
                //   ),
                // ),
            
                child:Material(
      color: Colors.transparent,
      child: Container(
       
        //width: widthVal,
        decoration:  BoxDecoration(
           borderRadius: const BorderRadius.only(
            bottomRight:const Radius.circular(50.0),
          bottomLeft:const Radius.circular(50.0),
            ),
       // color: Provider.of<AppModel>(context, listen: false).darkTheme ? Colors.black.withOpacity(0.7): Colors.transparent,//Colors.grey.withOpacity(0.6),

          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     offset: Offset(0, -2),
          //     blurRadius: 20,
          //   ),
          // ],
        ),
        child: ClipRRect(
         borderRadius: const BorderRadius.only(
           topRight:const Radius.circular(50.0),
          topLeft:const Radius.circular(50.0),
           ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(
            // padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                  color:Theme.of(context).backgroundColor.withOpacity(0.0),
                  borderRadius: BorderRadius.circular(0.0)),
              child: 


                Container(
                
                 decoration:  BoxDecoration(
                   // color:Provider.of<AppModel>(context, listen: false).darkTheme ? Colors.green.withOpacity(0.5):  Colors.transparent,
        borderRadius: const BorderRadius.only(
           topRight:const Radius.circular(50.0),
          topLeft:const Radius.circular(50.0),
           ),
            border: Border.all(
                    color: const Color(0xff52260f),
                    width: 1.0,
                  ),
          
          )
          ,
                  child:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    SizedBox(height:20),
                     Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).subtotal,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8),
                            ),
                          ),
                          Text(
                              PriceTools.getCurrencyFormatted(
                                  cartModel.getSubTotal(), currencyRate,
                                  currency: cartModel.currency)!,
                              style: const TextStyle(
                                  fontSize: 14, color: kGrey400))
                        ],
                      ),
                    ),
                    Services().widget.renderShippingMethodInfo(context),
                    if (cartModel.getCoupon() != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).discount,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.8),
                              ),
                            ),
                            Text(
                              cartModel.getCoupon(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.8),
                                  ),
                            )
                          ],
                        ),
                      ),
                    Services().widget.renderTaxes(taxModel, context),
                    Services().widget.renderRewardInfo(context),
                    Services().widget.renderCheckoutWalletInfo(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).total,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(
                            PriceTools.getCurrencyFormatted(
                                cartModel.getTotal(), currencyRate,
                                currency: cartModel.currency)!,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                   // SizedBox(height:0),
                   //  
                   SizedBox(height:45),
 _buildBottom(paymentMethodModel, cartModel),
                  ],///thirdcolum
                ),
                        )
                        ),
          ),
        ),
      ),
                ),
                        ),
              ),
            ),
   
       // ),///expandec
       ///oldbutton
      ],
    );
  }

  Widget _buildBottom(paymentMethodModel, cartModel) {
    return CommonSafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kPaymentConfig.enableShipping ||
              kPaymentConfig.enableAddress ||
              kPaymentConfig.enableReview) ...[
            SizedBox(
              width: 130,
              child: OutlinedButton(
                onPressed: () {
                  isPaying ? showSnackbar : widget.onBack!();
                },
                child: Text(
                  kPaymentConfig.enableReview
                      ? S.of(context).goBack.toUpperCase()
                      : kPaymentConfig.enableShipping
                          ? S.of(context).goBackToShipping
                          : S.of(context).goBackToAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ButtonTheme(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  onPrimary: Colors.white,
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () => isPaying || selectedId == null
                    ? showSnackbar
                    : placeOrder(paymentMethodModel, cartModel),
                icon: const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  size: 20,
                ),
                label: Text(S.of(context).placeMyOrder.toUpperCase()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackbar() {
    Tools.showSnackBar(
        ScaffoldMessenger.of(context), S.of(context).orderStatusProcessing);
  }

  void placeOrder(PaymentMethodModel paymentMethodModel, CartModel cartModel) {
    final Map <String , dynamic >config = 
{
"layout":"bannerImage",
"design":"swiper",
"fit":"fitWidth",
"marginLeft":0,
"items":[
{
"image":"https://i.imgur.com/t76x6mp.jpg"
},
{
"image":"https://i.imgur.com/j1bhlY7.jpg"
},

],
"marginBottom":0,
"height":0.45,
"marginRight":0,
"marginTop":10,
"radius":0,
"padding":0,
"title":{
"isSafeArea":false,
"showSearch":false,
"usePrimaryColor":true,
"borderInput":false,
"title":"",
"alignment":"centerLeft",
"fontWeight":400,
"fontSize":25,
"textOpacity":1,
"marginLeft":16,
"marginRight":0,
"marginBottom":0,
"marginTop":0,
"paddingLeft":5,
"paddingRight":15,
"paddingTop":0,
"paddingBottom":0,
"height":50,
"rotate":[]
},
"isSlider":true,
"autoPlay":false,
"intervalTime":3,
"showNumber":true,
"isBlur":false,
"showBackground":false,
"upHeight":0,
"key":"46rwu38h34"};

final config1 = BannerConfig.fromJson(config);
    final ScrollController _scrollController = ScrollController();
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;

    widget.onLoading!(true);
    isPaying = true;
    if (paymentMethodModel.paymentMethods.isNotEmpty) {
      final paymentMethod = paymentMethodModel.paymentMethods
          .firstWhere((item) => item.id == selectedId);
      var isSubscriptionProduct = cartModel.item.values.firstWhere(
              (element) =>
                  element?.type == 'variable-subscription' ||
                  element?.type == 'subscription',
              orElse: () => null) !=
          null;
      Provider.of<CartModel>(context, listen: false)
          .setPaymentMethod(paymentMethod);

      /// Use Credit card. For Shopify only.
      if (!isSubscriptionProduct &&
          kPaymentConfig.enableCreditCard &&
          serverConfig['type'] == 'shopify') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreditCardPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading!(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true).then((value) {
                    widget.onLoading!(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );

        return;
      }

      /// Use Native payment

      /// Direct bank transfer (BACS)

      if (!isSubscriptionProduct && paymentMethod.id!.contains('bacs')) {
        widget.onLoading!(false);
        isPaying = false;
      

      //   showModalBottomSheet(
      //      isScrollControlled: true,
         
      //        context: context,
      //            shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(0),
      //     topRight: Radius.circular(0),
      //   ),
      // ),
      // backgroundColor:Color(0xff52260f),

      //       builder: (Context) => 
      //       Container(
      // //         child: 
      // //         Column(
      // //   crossAxisAlignment: CrossAxisAlignment.start,
      // //   children: [
      // //     Container(
      // //       height: 300,
      // //       width: double.infinity,
      // //       padding: EdgeInsets.only(top: 60, right: 25, left: 20),
      // //       decoration: BoxDecoration(
      // //         color: Color(0xFF0B258A),
      // //         borderRadius:
      // //             BorderRadius.only(bottomRight: Radius.circular(100)),
      // //       ),
      // //       child: Column(children: [
      // //         Row(
      // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // //           children: [
      // //             // Container(
      // //             //   height: 45,
      // //             //   width: 45,
      // //             //   decoration: BoxDecoration(
      // //             //       shape: BoxShape.circle,
      // //             //       color: Colors.white.withOpacity(.4)),
      // //             //   child: Center(
      // //             //       child: Icon(
      // //             //     Icons.arrow_back_ios_new_sharp,
      // //             //     color: Colors.white,
      // //             //     size: 20,
      // //             //   )),
      // //             // ),
      // //             // Spacer(),
      // //             // Text(
      // //             //   "Select Card",
      // //             //   style: GoogleFonts.poppins(
      // //             //       fontSize: 25,
      // //             //       color: Colors.white,
      // //             //       fontWeight: FontWeight.w600),
      // //             // ),
      // //             // Container(
      // //             //   height: 50,
      // //             //   width: 50,
      // //             //   decoration: BoxDecoration(
      // //             //       // shape: BoxShape.circle,
      // //             //       borderRadius: BorderRadius.circular(10),
      // //             //       color: Colors.white.withOpacity(.4),
      // //             //       border: Border.all(
      // //             //         color: Colors.white.withOpacity(.5),
      // //             //       ),
      // //             //       image: DecorationImage(
      // //             //           image: AssetImage("assets/IMG_5706.JPG"))),
      // //             //   // child: Center(child: ),
      // //             // )
      // //           ],
      // //         ),
      // //         // SizedBox(
      // //         //   height: 20,
      // //         // ),
      // //         // Align(
      // //         //   alignment: Alignment.centerLeft,
      // //         //   child: Text(
      // //         //     "Hi, Abdulrehman",
      // //         //     style: GoogleFonts.aBeeZee(
      // //         //         fontSize: 25,
      // //         //         color: Colors.white,
      // //         //         fontWeight: FontWeight.w600),
      // //         //   ),
      // //         // ),
      // //         // SizedBox(
      // //         //   height: 10,
      // //         // ),
      // //         // Flash(
      // //         //   child: BlurryContainer(
      // //         //     child: Center(
      // //         //       child: Column(
      // //         //         crossAxisAlignment: CrossAxisAlignment.start,
      // //         //         mainAxisAlignment: MainAxisAlignment.center,
      // //         //         children: [
      // //         //           Text(
      // //         //             "Your Balance",
      // //         //             style: GoogleFonts.aBeeZee(
      // //         //                 fontSize: 14,
      // //         //                 color: Colors.white,
      // //         //                 fontWeight: FontWeight.w600),
      // //         //           ),
      // //         //           Padding(
      // //         //             padding: const EdgeInsets.only(),
      // //         //             child: Row(
      // //         //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // //         //                 children: [
      // //         //                   Text(
      // //         //                     "\$ 543,933.33",
      // //         //                     style: GoogleFonts.poppins(
      // //         //                         fontSize: 25,
      // //         //                         color: Colors.white,
      // //         //                         fontWeight: FontWeight.w600),
      // //         //                   ),
      // //         //                   Container(
      // //         //                       height: 35,
      // //         //                       width: 35,
      // //         //                       decoration: BoxDecoration(
      // //         //                         color: Colors.white,
      // //         //                         shape: BoxShape.circle,
      // //         //                       ),
      // //         //                       child: Icon(
      // //         //                         Icons.currency_bitcoin,
      // //         //                         color: Color(0xFF0B258A),
      // //         //                       ))
      // //         //                 ]),
      // //         //           ),
      // //         //         ],
      // //         //       ),
      // //         //     ),
      // //         //     blur: 50,
      // //         //     width: 300,
      // //         //     height: 100,
      // //         //     elevation: 0,
      // //         //     color: Colors.grey.withOpacity(.4),
      // //         //     padding: const EdgeInsets.only(left: 15, right: 15),
      // //         //     borderRadius: const BorderRadius.all(Radius.circular(20)),
      // //         //   ),
      // //         // ),
      // //       ]),
      // //     ),
      // //     Spacer(),
      // //     // Container(
      // //     //   height: 50,
      // //     //   child: ListView.builder(
      // //     //       itemCount: _tabs.length,
      // //     //       scrollDirection: Axis.horizontal,
      // //     //       itemBuilder: ((context, index) {
      // //     //         return SlideInLeft(
      // //     //           child: Padding(
      // //     //             padding: EdgeInsets.only(left: 20),
      // //     //             child: GestureDetector(
      // //     //               onTap: () {
      // //     //                 setState(() {
      // //     //                   _selectedIndex = index;
      // //     //                 });
      // //     //               },
      // //     //               child: Text(
      // //     //                 _tabs[index],
      // //     //                 style: GoogleFonts.poppins(
      // //     //                     fontSize: 25,
      // //     //                     color: index == _selectedIndex
      // //     //                         ? Color(0xFF0B258A)
      // //     //                         : Color(0xFF0B258A).withOpacity(.5),
      // //     //                     fontWeight: FontWeight.w600),
      // //     //               ),
      // //     //             ),
      // //     //           ),
      // //     //         );
      // //     //       })),
      // //     // ),
      // //     Spacer(),
      // //     // Align(
      // //     //   alignment: Alignment.bottomCenter,
      // //     //   child: Container(
      // //     //     height: MediaQuery.of(context).size.height * .55,
      // //     //     // color: Color.fromARGB(255, 230, 228, 232),
      // //     //     // color: Colors.amber,
      // //     //     child: SlideInUp(
      // //     //       child: CardSlider(
      // //     //         height: MediaQuery.of(context).size.height * .6,
      // //     //         confirm: (confirm) {
      // //     //          // _confirm = confirm;
      // //     //         },
      // //     //       ),
      // //     //     ),
      // //     //   ),
      // //     // ),
      // //   ],
      // // ),
      //         decoration: new BoxDecoration(
      //                                shape: BoxShape.circle,
      //                                border: new Border.all(color: Colors.black),
      //                                 image: new DecorationImage(
      //                                     fit: BoxFit.cover,
      //                                     image: new NetworkImage(
      //                                          "https://abushaherdabayh.tk/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg"))),
      //             padding: const EdgeInsets.symmetric(
      //                 horizontal: 2.0, vertical: 2.0),
      //             child: Stack(
      //               //crossAxisAlignment: CrossAxisAlignment.stretch,
      //              // mainAxisSize: MainAxisSize.max,
      //              //  mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Row(
      //                  // mainAxisAlignment: MainAxisAlignment.end,
      //                   children: [
      //                     GestureDetector(
      //                       onTap: () => Navigator.of(context).pop(),
      //                       child: Text(
      //                         S.of(context).cancel,
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .caption!
      //                             .copyWith(color: Theme.of(context).primaryColor),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 const SizedBox(height: 0),
                   
      //                BannerSlider(
      //               config:config1,
      //               onTap:(){}
      //             ),
      //                 const SizedBox(height: 0),
                      
                     
      //                Align(
      //                 alignment:Alignment.bottomCenter,
      //                 child: SizedBox(
      //                   width:double.infinity,
      //                   child: //const Expanded(child: SizedBox(height: 5)),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                     widget.onLoading!(true);
      //                     isPaying = true;
      //                     Services().widget.placeOrder(
      //                       context,
      //                       cartModel: cartModel,
      //                       onLoading: widget.onLoading,
      //                       paymentMethod: paymentMethod,
      //                       success: (Order order) async {
      //                         for (var item in order.lineItems) {
      //                           var product =
      //                               cartModel.getProductById(item.productId!);
      //                           if (product?.bookingInfo != null) {
      //                             product!.bookingInfo!.idOrder = order.id;
      //                             var booking =
      //                                 await createBooking(product.bookingInfo)!;

      //                             Tools.showSnackBar(
      //                                 ScaffoldMessenger.of(context),
      //                                 booking
      //                                     ? 'Booking success!'
      //                                     : 'Booking error!');
      //                           }
      //                         }
      //                         widget.onFinish!(order);
      //                         widget.onLoading!(false);
      //                         isPaying = false;
      //                       },
      //                       error: (message) {
      //                         widget.onLoading!(false);
      //                         if (message != null) {
      //                           Tools.showSnackBar(
      //                               ScaffoldMessenger.of(context), message);
      //                         }
      //                         isPaying = false;
      //                       },
      //                     );
      //                   },
      //                   style: ElevatedButton.styleFrom(
      //                           shape:RoundedRectangleBorder(
      //             borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(40.0),
      //         )),
      //                     onPrimary: Theme.of(context).primaryColorLight,
      //                     primary: Theme.of(context).primaryColor,
      //                   ),
      //                   child: Text(
      //                   ' شكراً - إكمال الطلب ',
      //                   //S.of(context).ok,
      //                   ),
      //                 ),
      //                 ),
                     
      //                ),
      //                 const SizedBox(height: 0),
      //               ],
      //             ),
      //           )
      //           );
       showModalBottomSheet(
          // isScrollControlled: true,
         
             context: context,
                 shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
     // backgroundColor:Color(0xff52260f),

            builder: (sContext) => 
            Container(
              // decoration: new BoxDecoration(
              //                        // shape: BoxShape.circle,
              //                        // border: new Border.all(color: Colors.black),
              //                         image: new DecorationImage(
              //                             fit: BoxFit.cover,
              //                             image: new NetworkImage(
              //                                  "https://abushaherdabayh.tk/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg"))),
                   padding: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 2.0),
                  child: Stack(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                   // mainAxisSize: MainAxisSize.max,
                   //  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                       // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              S.of(context).cancel,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 0),
                            Container(
              height: MediaQuery.of(context).size.height * .55,
              // color: Color.fromARGB(255, 230, 228, 232),
              // color: Colors.amber,
              child:
               SlideInUp(
                child: CardSlider(
                  height: MediaQuery.of(context).size.height * .6,
                  confirm: (confirm) {
                   // _confirm = confirm;
                  },
                ),
              ),
            ),
                   
                  //    BannerSlider(
                  //   config:config1,
                  //   onTap:(){}
                  // ),
                      const SizedBox(height: 0),
                      
                     
                     Align(
                      alignment:Alignment.bottomCenter,
                      child: SizedBox(
                        width:double.infinity,
                        child: //const Expanded(child: SizedBox(height: 5)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onLoading!(true);
                          isPaying = true;
                          Services().widget.placeOrder(
                            context,
                            cartModel: cartModel,
                            onLoading: widget.onLoading,
                            paymentMethod: paymentMethod,
                            success: (Order order) async {
                              for (var item in order.lineItems) {
                                var product =
                                    cartModel.getProductById(item.productId!);
                                if (product?.bookingInfo != null) {
                                  product!.bookingInfo!.idOrder = order.id;
                                  var booking =
                                      await createBooking(product.bookingInfo)!;

                                  Tools.showSnackBar(
                                      ScaffoldMessenger.of(context),
                                      booking
                                          ? 'Booking success!'
                                          : 'Booking error!');
                                }
                              }
                              widget.onFinish!(order);
                              widget.onLoading!(false);
                              isPaying = false;
                            },
                            error: (message) {
                              widget.onLoading!(false);
                              if (message != null) {
                                Tools.showSnackBar(
                                    ScaffoldMessenger.of(context), message);
                              }
                              isPaying = false;
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.0),
              )),
                          onPrimary: Theme.of(context).primaryColorLight,
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: Text( context.isRtl ?
                        ' شكراً - إكمال الطلب ' : S.of(context).placeMyOrder,
                        //S.of(context).ok,
                        ),
                      ),
                      ),
                     
                     ),
                      const SizedBox(height: 0),
                    ],
                  ),
                )
                );

        return;
      }

      /// PayPal Payment
      if (!isSubscriptionProduct &&
          isNotBlank(kPaypalConfig['paymentMethodId']) &&
          paymentMethod.id!.contains(kPaypalConfig['paymentMethodId']) &&
          kPaypalConfig['enabled'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading!(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true, transactionId: number).then((value) {
                    widget.onLoading!(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );
        return;
      }

      /// MercadoPago payment
      if (!isSubscriptionProduct &&
          isNotBlank(kMercadoPagoConfig['paymentMethodId']) &&
          paymentMethod.id!.contains(kMercadoPagoConfig['paymentMethodId']) &&
          kMercadoPagoConfig['enabled'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MercadoPagoPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading!(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true).then((value) {
                    widget.onLoading!(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );
        return;
      }

      /// RazorPay payment
      /// Check below link for parameters:
      /// https://razorpay.com/docs/payment-gateway/web-integration/standard/#step-2-pass-order-id-and-other-options
      if (!isSubscriptionProduct &&
          paymentMethod.id!.contains(kRazorpayConfig['paymentMethodId']) &&
          kRazorpayConfig['enabled'] == true) {
        Services().api.createRazorpayOrder({
          'amount': (PriceTools.getPriceValueByCurrency(cartModel.getTotal()!,
                      cartModel.currency!, currencyRate) *
                  100)
              .toInt()
              .toString(),
          'currency': cartModel.currency,
        }).then((value) {
          final razorServices = RazorServices(
            amount: (PriceTools.getPriceValueByCurrency(cartModel.getTotal()!,
                        cartModel.currency!, currencyRate) *
                    100)
                .toInt()
                .toString(),
            keyId: kRazorpayConfig['keyId'],
            delegate: this,
            orderId: value,
            userInfo: RazorUserInfo(
              email: cartModel.address?.email,
              phone: cartModel.address?.phoneNumber,
              fullName:
                  '${cartModel.address?.firstName ?? ''} ${cartModel.address?.lastName ?? ''}'
                      .trim(),
            ),
          );
          razorServices.openPayment(cartModel.currency!);
        }).catchError((e) {
          widget.onLoading!(false);
          Tools.showSnackBar(ScaffoldMessenger.of(context), e);
          isPaying = false;
        });
        return;
      }

      /// PayTm payment.
      /// Check below link for parameters:
      /// https://developer.paytm.com/docs/all-in-one-sdk/hybrid-apps/flutter/
      final availablePayTm = kPayTmConfig['paymentMethodId'] != null &&
          (kPayTmConfig['enabled'] ?? false) &&
          paymentMethod.id!.contains(kPayTmConfig['paymentMethodId']);
      if (!isSubscriptionProduct && availablePayTm) {
        createOrderOnWebsite(
            paid: false,
            onFinish: (Order? order) async {
              if (order != null) {
                final paytmServices = PayTmServices(
                  amount: cartModel.getTotal()!.toString(),
                  orderId: order.id!,
                  email: cartModel.address?.email,
                );
                try {
                  await paytmServices.openPayment();
                  widget.onFinish!(order);
                } catch (e) {
                  Tools.showSnackBar(
                      ScaffoldMessenger.of(context), e.toString());
                  isPaying = false;
                }
              }
            });
        return;
      }

      /// Use WebView Payment per frameworks
      Services().widget.placeOrder(
        context,
        cartModel: cartModel,
        onLoading: widget.onLoading,
        paymentMethod: paymentMethod,
        success: (Order? order) async {
          if (order != null) {
            for (var item in order.lineItems) {
              var product = cartModel.getProductById(item.productId!);
              if (product?.bookingInfo != null) {
                product!.bookingInfo!.idOrder = order.id;
                var booking = await createBooking(product.bookingInfo)!;

                Tools.showSnackBar(ScaffoldMessenger.of(context),
                    booking ? 'Booking success!' : 'Booking error!');
              }
            }
            widget.onFinish!(order);
          }
          widget.onLoading!(false);
          isPaying = false;
        },
        error: (message) {
          widget.onLoading!(false);
          if (message != null) {
            Tools.showSnackBar(ScaffoldMessenger.of(context), message);
          }

          isPaying = false;
        },
      );
    }
  }

  Future<bool>? createBooking(BookingModel? bookingInfo) async {
    return Services().api.createBooking(bookingInfo)!;
  }

  Future<void> createOrder(
      {paid = false, bacs = false, cod = false, transactionId = ''}) async {
    await createOrderOnWebsite(
        paid: paid,
        bacs: bacs,
        cod: cod,
        transactionId: transactionId,
        onFinish: (Order? order) async {
          if (!transactionId.toString().isEmptyOrNull && order != null) {
            await Services()
                .api
                .updateOrderIdForRazorpay(transactionId, order.number);
          }
          widget.onFinish!(order);
        });
  }

  Future<void> createOrderOnWebsite(
      {paid = false,
      bacs = false,
      cod = false,
      transactionId = '',
      required Function(Order?) onFinish}) async {
    widget.onLoading!(true);
    await Services().widget.createOrder(
      context,
      paid: paid,
      cod: cod,
      bacs: bacs,
      transactionId: transactionId,
      onLoading: widget.onLoading,
      success: onFinish,
      error: (message) {
        Tools.showSnackBar(ScaffoldMessenger.of(context), message);
      },
    );
    widget.onLoading!(false);
  }

  @override
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    createOrder(paid: true, transactionId: response.paymentId).then((value) {
      widget.onLoading!(false);
      isPaying = false;
    });
  }

  @override
  void handlePaymentFailure(PaymentFailureResponse response) {
    widget.onLoading!(false);
    isPaying = false;
    final body = convert.jsonDecode(response.message!);
    if (body['error'] != null &&
        body['error']['reason'] != 'payment_cancelled') {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), body['error']['description']);
    }
    printLog(response.message);
  }
}
class CardSlider extends StatefulWidget {
  final double height;
  final Function(bool) confirm;
  const CardSlider({
    Key? key,
    required this.height,
    required this.confirm,
  }) : super(key: key);

  @override
  State<CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  late double positionY_line1;
  late double positionY_line2;
  late List<CardInfo> _cardInfoList;
  late double _middleAreaHeight;
  late double _outsiteCardInterval;
  late double scrollOffsetY;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    positionY_line1 = widget.height * 0.1;
    positionY_line2 = positionY_line1 + 200;
    widget.confirm(false);

    _middleAreaHeight = positionY_line2 - positionY_line1;
    _outsiteCardInterval = 30.0;
    scrollOffsetY = 0.0;

    _cardInfoList = [
      CardInfo(
        userName: "Nasser Alqahtani",
        iban:"333333333333333333333333",
        accountNumber:"2222222222222222",
        bankLogo:"https://i.imgur.com/t76x6mp.jpg",
        bankName:"",
        leftColor: Color.fromARGB(255, 10, 10, 10),
        rightColor: Color.fromARGB(255, 10, 10, 10),
        // leftColor: Color.fromARGB(255, 255, 255, 255),
        // rightColor: Color.fromARGB(255, 255, 255, 255),
      ),
      CardInfo(
        userName: "Nasser Alqahtani",
        iban:"333333333333333333333333",
        accountNumber:"2222222222222222",
        bankLogo:"https://i.imgur.com/j1bhlY7.jpg",
        bankName:"",
        leftColor: Color.fromARGB(255, 10, 10, 10),
        rightColor: Color.fromARGB(255, 10, 10, 10),
      ),
      // CardInfo(
      //   userName: "ABDUL REHMAN",
      //   leftColor: Colors.pinkAccent,
      //   rightColor: Colors.pinkAccent,
      // ),
      // CardInfo(
      //     userName: "ABDUL REHMAN",
      //     leftColor: Color(0xFF0B258A),
      //     rightColor: Color.fromARGB(255, 49, 69, 147)),
      // CardInfo(
      //   userName: "ABDUL REHMAN",
      //   leftColor: Colors.red,
      //   rightColor: Colors.redAccent,
      // ),
      // CardInfo(
      //   userName: "ABDUL REHMAN",
      //   leftColor: Color.fromARGB(255, 229, 190, 35),
      //   rightColor: Colors.redAccent,
      // ),
      // CardInfo(
      //   userName: "ABDUL REHMAN",
      //   leftColor: Color.fromARGB(255, 85, 137, 234),
      //   rightColor: Color.fromARGB(255, 10, 10, 10),
      // ),
      // CardInfo(
      //   userName: "ABDUL REHMAN",
      //   leftColor: Color.fromARGB(255, 171, 51, 75),
      //   rightColor: Color.fromARGB(255, 224, 63, 92),
      // ),
    ];

    for (int i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[i];
      if (i == 0) {
        cardInfo.positionY = positionY_line1;
        cardInfo.opacity = 1.0;
        cardInfo.rotate = 1.0;
        cardInfo.scale = 1.0;
      } else {
        cardInfo.positionY = positionY_line2 + (i - 1) * 30;
        cardInfo.opacity = 0.7 - (i - 1) * 0.1;
        cardInfo.rotate = -60;
        cardInfo.scale = 0.9;
      }
    }

    _cardInfoList = _cardInfoList.reversed.toList();
  }

  _cardBuild() {
    List widgetList = [];

    for (CardInfo cardInfo in _cardInfoList) {
      widgetList.add(Positioned(
        top: cardInfo.positionY,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(pi / 180 * cardInfo.rotate)
            ..scale(cardInfo.scale),
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: cardInfo.opacity,
            child: Container(
            //  padding:EdgeInsets.only(left:5,right:5),
              width:MediaQuery.of(context).size.width-8, //300,
               height: 190,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 10,
                        offset: Offset(5, 10))
                  ],
                 // color: Colors.red,
                  gradient: LinearGradient(
                      colors: [cardInfo.leftColor, cardInfo.rightColor])),
              child: ClipRRect(
                 borderRadius: BorderRadius.circular(15.0),
      child:  Image.network(
                        cardInfo.bankLogo!,
                        fit: BoxFit.fill
                        // color: Colors.go,
                      ),
              
              )
            
              // Stack(
              //   children: [
              //   // * Number
              //   Positioned(
              //     top: 130,
              //     left: 10,
              //     right:5,
              //     child: Text("رقم الايبان " + ":"  +
              //       cardInfo.iban!,
              //       style: TextStyle(
              //           color: Colors.white,
              //           letterSpacing: 0.5,
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700),
              //     ),
              //   ),

              //   // * Card Name
              //   Positioned(
              //     top: 150,
              //     left: 10,
              //     right:5,
              //     child: Text("اسم العميل " + ":"  +
              //       cardInfo.userName,
              //       style: TextStyle(
              //           color: Colors.white,
              //           letterSpacing: 0.5,
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700),
              //     ),
              //   ),
              //        // * Card Name2
              //   Positioned(
              //     top: 170,
              //     left: 10,
              //     right:5,
              //     child: Text("رقم الحساب " + ":"  +
              //       cardInfo.accountNumber!,
              //       style: TextStyle(
              //           color: Colors.white,
              //           letterSpacing: 0.5,
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700),
              //     ),
                  
              //   ),
              //   // * network
              //   Positioned(
              //     top: 8,
              //     right: 50,
              //     child: SizedBox(
              //         height: 110,
              //         width: 110,
              //         child: Image.asset(
              //           cardInfo.bankLogo!,
              //           // color: Colors.go,
              //         )),
              //   ),
              //   // * sim card

              //   Positioned(
              //     left: 5,
              //     top: 50,
              //     child: Row(
              //       children: [
              //         Container(
              //           height: 40,
              //           width: 80,
              //           // color: Colors.deepOrange,
              //           child: Image.asset(
              //             "assets/images/sim.png",
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //         Container(
              //           height: 20,
              //           width: 25,
              //           child: Image.asset(
              //             "assets/images/signal.png",
              //             fit: BoxFit.contain,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),

              //   // * Card Logo
              //   Positioned(
              //     left: 5,
              //     top: 5,
              //     child: Container(
              //       height: 50,
              //       width: 50,
              //       child: Image.asset("assets/images/mastercardLogo.png"),
              //     ),
              //   ),
              // ]
              // ),
            ),
          ),
        ),
      ));
    }

    return widgetList;
  }

  // * position update function

  void _updateCardPosition(double offsetY) {
    scrollOffsetY += offsetY;

    void updatePosition(CardInfo cardInfo, double firstCardAreaIdx, int index) {
      // cardInfo.positionY += offsetY;
      double currentCardAreaIdx = firstCardAreaIdx + index;
      if (currentCardAreaIdx < 0) {
        cardInfo.positionY = positionY_line1 + currentCardAreaIdx * 5;

        cardInfo.scale =
            1.0 - 0.2 / 10 * (positionY_line1 - cardInfo.positionY);

        if (cardInfo.scale < 0.8) cardInfo.scale = 0.8;
        if (cardInfo.scale > 1) cardInfo.scale = 1.0;

        // * rotate card
        cardInfo.rotate = -90.0 / 5 * (positionY_line1 - cardInfo.positionY);

        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -90.0) cardInfo.rotate = -90.0;

        // Opacity 1.0 --> 0.7
        cardInfo.opacity =
            1.0 - 0.7 / 5 * (positionY_line1 - cardInfo.positionY);

        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1) cardInfo.opacity = 1.0;
      } else if (currentCardAreaIdx >= 0 && currentCardAreaIdx < 1) {
        cardInfo.scale = 1.0 -
            0.1 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.scale < 0.9) cardInfo.scale = 0.9;
        if (cardInfo.scale > 1) cardInfo.scale = 1.0;
        // move 1:1
        cardInfo.positionY =
            positionY_line1 + currentCardAreaIdx * _middleAreaHeight;
        // * rotate card
        cardInfo.rotate = -60.0 /
            (positionY_line2 - positionY_line1) *
            (cardInfo.positionY - positionY_line1);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;

        // Opacity
        cardInfo.opacity = 1.0 -
            0.3 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1) cardInfo.opacity = 1.0;
      } else if (currentCardAreaIdx >= 1) {
        cardInfo.positionY =
            positionY_line2 + (currentCardAreaIdx - 1) * _outsiteCardInterval;
        cardInfo.rotate = -60.0;
        cardInfo.scale = 0.9;
        cardInfo.opacity = 0.7;
      }
    }

    double firstCardAreaIdx = scrollOffsetY / _middleAreaHeight;
    print(firstCardAreaIdx);
    setState(() {
      // CardInfo cardInfo = _cardInfoList.last;
      // updatePosition(cardInfo, firstCardAreaIdx, 0);
    });

    for (int i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[_cardInfoList.length - 1 - i];
      updatePosition(cardInfo, firstCardAreaIdx, i);
      setState(() {
        // cardInfo.positionY += offsetY;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails d) {
        // print(d.delta.dy);

        _updateCardPosition(d.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails d) {
        scrollOffsetY =
            (scrollOffsetY / _middleAreaHeight).round() * _middleAreaHeight;
        _updateCardPosition(0);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // color: Color.fromARGB(255, 230, 228, 232),
        decoration: BoxDecoration(
          //  color: Color(0xFF0B258A).withOpacity(.1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
        // color: Colors.amber,
        child: Stack(alignment: Alignment.topCenter, children: [
          // * top title
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "",
                style: TextStyle(
                    color: Color.fromARGB(255, 18, 71, 162),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
          // * line 1
          ,
          // Positioned(
          //   top: positionY_line1,
          //   child: Container(
          //     height: 1,
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.red,
          //   ),
          // ),

          ..._cardBuild(),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: 240,
          //     decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //             colors: [
          //           Color.fromARGB(0, 255, 255, 255),
          //           Color.fromARGB(255, 255, 255, 255),
          //         ])),
          //   ),
          // ),
          // * line 2
          // Positioned(
          //   top: positionY_line2,
          //   child: Container(
          //     height: 1,
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.red,
          //   ),
          // ),

          // * bottom row
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         FloatingActionButton(
          //           onPressed: () {},
          //           child: Icon(
          //             Icons.keyboard,
          //             color: Colors.grey,
          //             size: 35,
          //           ),
          //           backgroundColor: Colors.white,
          //         ),
          //         TextButton(
          //             onPressed: () {
          //               widget.confirm(true);
          //               print("tab");
          //             },
          //             child: Container(
          //               height: 60,
          //               width: 200,
          //               decoration: ShapeDecoration(
          //                 shadows: [
          //                   BoxShadow(
          //                       color: Color(0xFF0B258A).withOpacity(.5),
          //                       blurRadius: 10,
          //                       offset: Offset(0, 10))
          //                 ],
          //                 shape: StadiumBorder(),
          //                 color: Color(0xFF0B258A),
          //               ),
          //               child: Center(
          //                 child: Text(
          //                   "Confirm \$5400",
          //                   style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w700),
          //                 ),
          //               ),
          //             )),
          //         FloatingActionButton(
          //           onPressed: () {},
          //           child: Icon(
          //             Icons.mic,
          //             color: Colors.grey,
          //             size: 35,
          //           ),
          //           backgroundColor: Colors.white,
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ]),
      ),
    );
  }
}

