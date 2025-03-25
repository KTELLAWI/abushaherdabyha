import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../common/tools/adaptive_tools.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/app_model.dart';
import '../../modules/dynamic_layout/index.dart';
import '../../services/index.dart';
import '../../widgets/home/index.dart';
import '../../widgets/home/wrap_status_bar.dart';
import 'package:fstore/modules/dynamic_layout/product/product_grid.dart';
import 'package:fstore/modules/dynamic_layout/product/product_list.dart';
import 'package:fstore/modules/dynamic_layout/product/product_list2.dart';
import '../../../models/index.dart' show AppModel, Product, RecentModel;
import '../../../models/user_model.dart';
import '../base_screen.dart';
//import '../../services/index.dart';
import 'package:fstore/modules/dynamic_layout/helper/helper.dart';
import '../../modules/dynamic_layout/logo/logo.dart';
import '../../modules/dynamic_layout/helper/header_view.dart';
import '../../modules/dynamic_layout/config/banner_config.dart';
import '../../modules/dynamic_layout/banner/banner_slider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() {
  //  List<Product>? products;
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseScreen<HomeScreen> {
  // @override
  // bool get wantKeepAlive => true;
  String? lang ;

  @override
  void dispose() {
    printLog('[Home] dispose');
    super.dispose();
  }

  @override
  void initState() {
    printLog('[Home] initState');
      //  setState(() {});
    super.initState();
  }

   

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
        setState(() {});
    /// init dynamic link
    if (!kIsWeb) {
      Services().firebase.initDynamicLinkService(context);
    }
  }

  @override
   

  Widget build(BuildContext context)  {
                final appModel = Provider.of<AppModel>(context, listen: false);
                final appModel2 = Provider.of<AppModel>(context, listen: true).appConfig;
                 final langCode  = Provider.of<AppModel>(context, listen: true).langCode;
                setState(() {
                  lang =langCode;
                });

    print("hommmmmmmmmmmmmmmmmmmmmmmmmmm");
    //print(products);
    //final pp =  getProductLayout(context);
  //  print(pp);
     var maxWidth = kMaxProductWidth;
    //Layout.isDisplayDesktop(context)
    //         ? kMaxProductWidth
    //         : constraint.maxWidth;
     final Map<String,dynamic> logoConfig =  {
  "layout":"logo",
  "showLogo":true,
  "showSearch":true,
  "showMenu":true
  };
  var configl = LogoConfig.fromJson(logoConfig);
  final Map<String,dynamic> config4banner ={
"layout":"bannerImage1",
"isSlider":true,
"marginTop":0.0,
"marginBottom":0.0,
"marginLeft":0.0,
"marginRight":0.0,
"height":0.3,
"fit":"fill",
"items":[
{
  // 
//"image":"https://i.imgur.com/qlr2tP6.png",
"image":"https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/meatSlider.jpg",
"padding":14.1,
"category":null
},
{
"padding":14.1,
"image":"https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/transporationcars.jpg",
"category":null
},


],
"autoPlay":true,
"design":"default",
"radius":7.6,
"intervalTime":5
};
    final Map<String,dynamic> config2 = {
   // "layout":"twoColumn",
   // "name":"Recent Collections",
    "isSnapping":true,
    "rows":3,
    "columns":0,
    "imageBoxfit":"fill",
    "imageRatio":1.0397843326430722,
    "hMargin":6,
    "vMargin":0,
    "hPadding":0,
    "vPadding":0,
    "pos":600,
    // "showStockStatus":true,
    // "enableRating":true,
    // "hideTitle":false,
    // "hideStore":false,
    // "hidePrice":false,
    // "featured":false,
    // "showHeart":false, 
    // "showCartButton":false,
    // "cartIconRadius":9,
    // "showQuantity":false,
    // "showCartIconColor":false,
    // "showCartIcon":true,
    // "enableBottomAddToCart":false,
    // "cardDesign":"glass",
    // "borderRadius":26,
    // "category":"27",
    "tag":null};
   // final Map<String ,dynamic> jsonData =

    printLog('[Home] build');
//     return 
//     Selector<AppModel, Tuple2<AppConfig?, String>>(
//       selector: (_, model) => Tuple2(model.appConfig, model.langCode),
//       builder: (_, value, child) {
//         var appConfig = value.item1;
//         var langCode = value.item2;
// //print(appConfig!.jsonData['HorizonLayout'][2]);
//         if (appConfig == null) {
//           return kLoadingWidget(context);
//         }

//         var isStickyHeader = appConfig.settings.stickyHeader;
//         final horizontalLayoutList =
//             List.from(appConfig.jsonData['HorizonLayout']);
//         final isShowAppbar = horizontalLayoutList.isNotEmpty &&
//             horizontalLayoutList.first['layout'] == 'logo';
//             print(langCode);
//             print('lang');
        return   Consumer<AppModel>(
                builder: (context, value, child) {
                  return 
        SafeArea(
      child:  Scaffold(
         backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
             
            children: <Widget>[
              !Provider.of<AppModel>(context, listen: true).darkTheme ? 
               Image.network(
            "https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ): SizedBox(),
  //         SizedBox(
  // width: MediaQuery.of(context).size.width/2,
              // child: 
               SingleChildScrollView(
                  child:
  // width: 100,
                  Column(
                    //mainAxisSize:MainAxisSize.min,
                   crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Container(
                        color:Theme.of(context).backgroundColor,
                        child:  Logo(
                  config: configl,
                  logo: appModel.themeConfig.logo,
                  // notificationCount:
                  //     Provider.of<NotificationModel>(context).unreadCount,
                  // totalCart: totalCart,
                  onSearch: () {
                   // FluxNavigate.pushNamed(RouteList.homeSearch);
                  },
                  onCheckout: () {
                   // FluxNavigate.pushNamed(RouteList.cart);
                  },
                  onTapNotifications: () {
                    //FluxNavigate.pushNamed(RouteList.notify);
                  },
                  onTapDrawerMenu: () {}
                  
                 
                 // FluxNavigate.pushNamed(RouteList.cart),
                   //  NavigateTools.onTapOpenDrawerMenu(context),
                ),
                      ),
                      
                    SizedBox(height:30),
                    BannerSlider(
                      config:BannerConfig.fromJson(appModel2!.jsonData['HorizonLayout'][1]),
                      onTap:()=>{},
                    ),

                   // HeaderView(headerText:'وش محتاج اليوم من عنا'),
                    SizedBox(height:30),
  //                       SizedBox(
  // width: MediaQuery.of(context).size.width * 0.4,
  // child:

                  langCode == "ar" ?
                  ProductList(
                config: ProductConfig.fromJson(appModel2!.jsonData['HorizonLayout'][2]),
                cleanCache: false)
                :  ProductList2(
                config: ProductConfig.fromJson(appModel2!.jsonData['HorizonLayout'][2]),
                cleanCache: false),
                //),
                 //SizedBox(height:5),
               langCode == "ar" ?
                   ProductList(
                config: ProductConfig.fromJson(appModel2!.jsonData['HorizonLayout'][3]),
                cleanCache: false) :
                ProductList2(
                config: ProductConfig.fromJson(appModel2!.jsonData['HorizonLayout'][3]),
                cleanCache: false),
                
                 SizedBox(height:10),

              //    ProductGrid(
              //   maxWidth: maxWidth,
              //   products: products,
              //  config: ProductConfig.fromJson(config2),//config..showCountDown = isShowCountDown(),
              // ),
                
                    ]
                  )

                )
        //  ),




              // if (appConfig.background != null)
              //   isStickyHeader
              //       ? SafeArea(
              //           child: HomeBackground(config: appConfig.background),
              //         )
              //       : HomeBackground(config: appConfig.background),
              // HomeLayout(
              //   isPinAppBar: isStickyHeader,
              //   isShowAppbar: isShowAppbar,
              //   showNewAppBar:
              //       appConfig.appBar?.shouldShowOn(RouteList.home) ?? false,
              //   configs: appConfig.jsonData,
              //   key: Key(langCode),
              // ),
              //if (Config().isBuilder) const WrapStatusBar(),
            ],
          ),
        ),
        );
      },
    );
  }
}
