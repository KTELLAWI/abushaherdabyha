import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show AutoHideKeyboard, printLog;
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../menu/index.dart' show MainTabControlDelegate;
import '../../models/index.dart' show AppModel, CartModel, Product, UserModel;
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import '../../widgets/product/cart_item.dart';
import '../../widgets/product/product_bottom_sheet.dart';
import '../checkout/checkout_screen.dart';
import 'widgets/empty_cart.dart';
import 'widgets/shopping_cart_sumary.dart';
import 'widgets/wishlist.dart';

// Move createShoppingCartRows is outside MyCart to reuse for POS
List<Widget> createShoppingCartRows(CartModel model, BuildContext context) {
  return model.productsInCart.keys.map(
    (key) {
      var productId = Product.cleanProductID(key);
      var product = model.getProductById(productId);

      if (product != null) {
      printLog(model.productsMetaDataInCart[key].toString());
      //  Provider.of<CartModel>(context, listen: false)
      //                   .setOrderNotes(model.productsMetaDataInCart[key].toString());
        return ShoppingCartRow(
          product: product,
          addonsOptions: model.productAddonsOptionsInCart[key],
          variation: model.getProductVariationById(key),
          quantity: model.productsInCart[key],
         options: model.productsMetaDataInCart[key],
          onRemove: () {
            model.removeItemFromCart(key);
          },
          onChangeQuantity: (val) {
            var message = model.updateQuantity(product, key, val);
            if (message.isNotEmpty) {
              final snackBar = SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 1),
              );
              Future.delayed(
                const Duration(milliseconds: 300),
                () => ScaffoldMessenger.of(context).showSnackBar(snackBar),
              );
            }
          },
        );
      }
      return const SizedBox();
    },
  ).toList();
}

class MyCart extends StatefulWidget {
  final bool? isModal;
  final bool? isBuyNow;

  const MyCart({
    this.isModal,
    this.isBuyNow = false,
  });

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String errMsg = '';

  CartModel get cartModel => Provider.of<CartModel>(context, listen: false);

  void _loginWithResult(BuildContext context) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(
    //       fromCart: true,
    //     ),
    //     fullscreenDialog: kIsWeb,
    //   ),
    // );
    await FluxNavigate.pushNamed(
      RouteList.login,
    );
    // .then((value) {
    //   final user = Provider.of<UserModel>(context, listen: false).user;
    //   if (user != null && user.name != null) {
    //     Tools.showSnackBar(ScaffoldMessenger.of(context),
    //         '${S.of(context).welcome} ${user.name} !');
    //     setState(() {});
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    printLog('[Cart] build');
   //printLog(.productsMetaDataInCart[key]);

    final localTheme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    var layoutType = Provider.of<AppModel>(context).productDetailLayout;
    final parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;

    return Stack (
      children:[

         if (!Provider.of<AppModel>(context, listen: false).darkTheme)  
                  Image.network(
            'https://abushaherdabayh.site/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
    //   ]
    // );
    Scaffold(
backgroundColor: Provider.of<AppModel>(context, listen: false).darkTheme ? Theme.of(context).backgroundColor :
      Colors.transparent,     
       floatingActionButton: Selector<CartModel, bool>(
        selector: (_, cartModel) => cartModel.calculatingDiscount,
        builder: (context, calculatingDiscount, child) {
          return
           FloatingActionButton.extended(
            heroTag: null,
            onPressed: calculatingDiscount
                ? null
                : () {
                    if (kAdvanceConfig.alwaysShowTabBar) {
                      MainTabControlDelegate.getInstance()
                          .changeTab(RouteList.cart);
                      // return;
                    }
                    onCheckout(cartModel);
                  },
            elevation: 10,
            isExtended: true,
            // extendedTextStyle: const TextStyle(
            //   letterSpacing: 0.8,
            //   fontSize: 11,
            //   fontWeight: FontWeight.w600,
            // ),
            extendedPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            backgroundColor:Color(0xff52260f),//Provider.of<AppModel>(context, listen: false).darkTheme ? Color(0xffffdf90): Colors.black,//Colors.white.withOpacity(), //Theme.of(context).primaryColor,
            foregroundColor:Color(0xff52260f),//!Provider.of<AppModel>(context, listen: false).darkTheme ? Color(0xffffdf90): Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //icon: const Icon(Icons.money, size: 20),
            label: child!,
          );
        },
        child: Selector<CartModel, int>(
          selector: (_, carModel) => cartModel.totalCartQuantity,
          builder: (context, totalCartQuantity, child) {
            // if (totalCartQuantity == 0) {
            //   return const SizedBox();
            // }
            return Row(
              children: [
                totalCartQuantity > 0
                        ? (isLoading
                        ? Text(S.of(context).loading.toUpperCase(),style:TextStyle(color:Colors.white))
                        : Text(S.of(context).checkout.toUpperCase(),style:TextStyle(color:Colors.white)))//Theme.of(context).colorScheme.secondary)))
                    : Text(S.of(context).startShopping.toUpperCase(),style:TextStyle(color:Colors.white)),
              //  const SizedBox(width: 3),
               // const Icon(CupertinoIcons.right_chevron, size: 12),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: false,
            leading: widget.isModal == true
                ? CloseButton(
                    onPressed: () {
                      if (widget.isBuyNow!) {
                        Navigator.of(context).pop();
                        return;
                      }

                      if (Navigator.of(context).canPop() &&
                          layoutType != 'simpleType') {
                        Navigator.of(context).pop();
                      } else {
                        ExpandingBottomSheet.of(context, isNullOk: true)
                            ?.close();
                      }
                    },
                  )
                : canPop
                    ? const BackButton()
                    : null,
            backgroundColor: !Provider.of<AppModel>(context).darkTheme? Colors.white: Theme.of(context).backgroundColor,
            title: Text(
              S.of(context).myCart,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<CartModel, int>(
              selector: (_, cartModel) => cartModel.totalCartQuantity,
              builder: (context, totalCartQuantity, child) {
                return AutoHideKeyboard(
                  child: Container(
                    decoration:
                        BoxDecoration(
                        //  color: Provider.of<AppModel>(context, listen: true).darkTheme ?  Colors.transparent : Colors.white.withOpacity(0.5),//Colors.grey.withOpacity(0.6),

                        ),
                    child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX:0.0, sigmaY: 0.0),
            child:
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Column(
                          children: [
                            if (totalCartQuantity > 0)
                              Container(
                                // decoration: BoxDecoration(
                                //     color: Theme.of(context).primaryColorLight),
                                padding: const EdgeInsets.only(
                                  right: 15.0,
                                  top: 4.0,
                                ),
                                child: SizedBox(
                                  width: screenSize.width,
                                  child: SizedBox(
                                    width: screenSize.width /
                                        (2 /
                                            (screenSize.height /
                                                screenSize.width)),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 25.0),
                                        Text(
                                          S.of(context).total.toUpperCase(),
                                          style: localTheme.textTheme.subtitle1!
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color:    Provider.of<AppModel>(context, listen: false).darkTheme ?  Colors.white :Colors.black,
                                               // Theme.of(context).backgroundColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '$totalCartQuantity ${S.of(context).items}',
                                          style: TextStyle(
                                              color: Provider.of<AppModel>(context, listen: false).darkTheme ?  Colors.white :Colors.black),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Tools.isRTL(context)
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                if (totalCartQuantity > 0) {
                                                  showDialog(
                                                    context: context,
                                                    useRootNavigator: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Text(S
                                                            .of(context)
                                                            .confirmClearTheCart),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(S
                                                                .of(context)
                                                                .keep),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              cartModel
                                                                  .clearCart();
                                                            },
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .clear,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Text(
                                                S
                                                    .of(context)
                                                    .clearCart
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    /////firdt Row
                                  ),
                                ),
                              ),
                            if (totalCartQuantity > 0)
                              const Divider(
                                height: 1,
                                // indent: 25,
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 16.0),
                                if (totalCartQuantity > 0)
                                Container(
                                   padding:const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
                //color:Colors.blue, //Theme.of(context).backgroundColor,
              //  color: Colors.white.withOpacity(0.5),
                    border: Border.all(
                    color: const Color(0xff52260f),
                    width: 1,
                  ),
                // boxShadow: [
                //   BoxShadow(
                //     color:Colors.white,// const Color(0xff52260f),//Colors.black,
                //     offset: Offset(2.0, 2.0), 
                //     //offset: Offset(1.0, 1.8), //(x,y)
                //     blurRadius: 4.0,
                //   ),
                // ],
                // boxShadow: [
                //   if (widget.config.boxShadow != null)
                //     BoxShadow(
                //       color: Colors.green,
                //       offset: Offset(
                //         widget.config.boxShadow?.x ?? 0.0,
                //         widget.config.boxShadow?.y ?? 0.0,
                //       ),
                //       blurRadius: widget.config.boxShadow?.blurRadius ?? 0.0,
                //     ),
                // ],
              ),
                                   margin: const EdgeInsets.all(15.0),
                                   //color:Colors.green,
                                   child:
                                  Column(
                                    children: createShoppingCartRows(
                                        cartModel, context),
                                  ),
                            ),
                      //           Container(
                      //           decoration: new BoxDecoration(
                      //  // color: Colors.white,
                      //   borderRadius: BorderRadius.all(Radius.circular(30),),),
                      //            // margin: const EdgeInsets.all(20.0),
                      //               //color:Colors.white,
                      //               child:Center(
                      //                 child: ShoppingCartSummary(),
                      //               ),
                      //             ),
                               const ShoppingCartSummary(),
                                if (totalCartQuantity == 0) EmptyCart(),
                                if (errMsg.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      errMsg,
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                const SizedBox(height: 4.0),
                               // WishList()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ),
    ],
    );
  }

  void onCheckout(CartModel model) {
    var isLoggedIn = Provider.of<UserModel>(context, listen: false).loggedIn;
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    final currency = Provider.of<AppModel>(context, listen: false).currency;
    var message;

    if (isLoading) return;

    if (kCartDetail['minAllowTotalCartValue'] != null) {
      if (kCartDetail['minAllowTotalCartValue'].toString().isNotEmpty) {
        var totalValue = model.getSubTotal() ?? 0;
        var minValue = PriceTools.getCurrencyFormatted(
            kCartDetail['minAllowTotalCartValue'], currencyRate,
            currency: currency);
        if (totalValue < kCartDetail['minAllowTotalCartValue'] &&
            model.totalCartQuantity > 0) {
          message = '${S.of(context).totalCartValue} $minValue';
        }
      }
    }

    if ((kVendorConfig['DisableMultiVendorCheckout'] ?? false) &&
        Config().isVendorType()) {
      if (!model.isDisableMultiVendorCheckoutValid(
          model.productsInCart, model.getProductById)) {
        message = S.of(context).youCanOnlyOrderSingleStore;
      }
    }

    if (message != null) {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        persistent: !Config().isBuilder,
        builder: (context, controller) {
          return SafeArea(
            child: Flash(
              borderRadius: BorderRadius.circular(3.0),
              backgroundColor: Theme.of(context).errorColor,
              controller: controller,
              behavior: FlashBehavior.fixed,
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
            ),
          );
        },
      );

      return;
    }

    if (model.totalCartQuantity == 0) {
      if (widget.isModal == true) {
        try {
          ExpandingBottomSheet.of(context)!.close();
        } catch (e) {
          Navigator.of(context).pushNamed(RouteList.dashboard);
        }
      } else {
        final modalRoute = ModalRoute.of(context);
        if (modalRoute?.canPop ?? false) {
          Navigator.of(context).pop();
        }
        MainTabControlDelegate.getInstance().changeTab(RouteList.home);
      }
    } else if (isLoggedIn || kPaymentConfig.guestCheckout) {
      doCheckout();
    } else {
      _loginWithResult(context);
    }
  }

  Future<void> doCheckout() async {
    showLoading();

    await Services().widget.doCheckout(
      context,
      success: () async {
        hideLoading('');
        await FluxNavigate.pushNamed(
          RouteList.checkout,
          arguments: CheckoutArgument(isModal: widget.isModal),
          forceRootNavigator: true,
        );
      },
      error: (message) async {
        if (message ==
            Exception('Token expired. Please logout then login again')
                .toString()) {
          setState(() {
            isLoading = false;
          });
          //logout
          final userModel = Provider.of<UserModel>(context, listen: false);
          await userModel.logout();
          Services().firebase.signOut();

          _loginWithResult(context);
        } else {
          hideLoading(message);
          Future.delayed(const Duration(seconds: 3), () {
            setState(() => errMsg = '');
          });
        }
      },
      loading: (isLoading) {
        setState(() {
          this.isLoading = isLoading;
        });
      },
    );
  }

  void showLoading() {
    setState(() {
      isLoading = true;
      errMsg = '';
    });
  }

  void hideLoading(error) {
    setState(() {
      isLoading = false;
      errMsg = error;
    });
  }
}
