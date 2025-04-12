import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fstore/screens/common/app_bar_mixin.dart';
import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/constants.dart';
import '../generated/l10n.dart';
import '../models/index.dart'
    show AppModel, BackDropArguments, Category, CategoryModel, UserModel;
import '../modules/dynamic_layout/config/app_config.dart';
import '../modules/dynamic_layout/helper/helper.dart';
import '../routes/flux_navigate.dart';
import '../services/index.dart';
import '../widgets/common/index.dart' show FluxImage, WebView;
import '../widgets/general/index.dart';
import 'maintab_delegate.dart';
import 'package:fstore/common/tools/adaptive_tools.dart';
import 'package:fstore/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fstore/screens/posts/post_screen.dart';
import 'package:fstore/screens/posts/chatus.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:async';
import 'dart:io';
import '../../widgets/common/login_animation.dart';
import '../../modules/sms_login/sms_login.dart';
import '../../app.dart';
import 'package:place_picker/place_picker.dart';
import 'package:location/location.dart';



//import 'package:share_plus/share_plus.dart';


class SideBarMenu extends StatefulWidget {
  //SideBarMenu();
   final  _callback;
  SideBarMenu({ required Function() toggleCoinCallback}) :
       _callback = toggleCoinCallback;
  MenuBarState createState() => MenuBarState();
}

class MenuBarState extends State<SideBarMenu> with AppBarMixin {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool get isEcommercePlatform =>
      !Config().isListingType || !Config().isWordPress;

  DrawerMenuConfig get drawer =>
      Provider.of<AppModel>(context, listen: false).appConfig?.drawer ??
      kDefaultDrawer;

  void pushNavigation(String name) {
    eventBus.fire(const EventCloseNativeDrawer());
    MainTabControlDelegate.getInstance().changeTab(name.replaceFirst('/', ''));
  }

void _showLoading(String language) {
    final snackBar = SnackBar(
      content: Text(
        S.of(context).languageSuccess,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).primaryColor,
      action: SnackBarAction(
        label: language,
        onPressed: () {},
      ),
    );
      _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
_launchURL(String url) async {
 // const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://kooora.com/',
        chooserTitle: 'Example Chooser Title');
  }


  Future _welcomeMessage(user) async {
    final canPop = ModalRoute.of(context)!.canPop;
    if (canPop) {
      // When not required login
      Navigator.of(context).pop();
    } else {
      // When required login
      await Navigator.of(App.fluxStoreNavigatorKey.currentContext!)
          .pushReplacementNamed(RouteList.dashboard);
    }
  }

  // void showPlacePicker() async {
  //   LocationResult? result = await Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => PlacePicker(kGoogleApiKey.android,)));

  //   // Handle the result in your way
  //   print(result);
  // }
//}
Location location = Location();

//bool _serviceEnabled;
PermissionStatus? _permissionGranted;

  @override
  Widget build(BuildContext context) {
     final iconsColor = Provider.of<AppModel>(context, listen: true).darkTheme?  Color(0xffeac85f) :Theme.of(context).primaryColor;//Theme.of(context).colorScheme.secondary;
     final style = context.isRtl ? 
     //TextStyle(fontSize: 18 ,color:Theme.of(context).colorScheme.secondary);
      Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Provider.of<AppModel>(context, listen: true).darkTheme?  Color(0xffeac85f) :Theme.of(context).primaryColor,//Theme.of(context).colorScheme.secondary,
                ) :TextStyle(fontSize: 18 ,color:Theme.of(context).colorScheme.secondary);
                //TextStyle(fontSize: 18 ,color:Theme.of(context).colorScheme.secondary);

     final userData =  Provider.of<UserModel>(context, listen: true);
       final loggedIn = userData.loggedIn;
       final user = userData.user;
      // word.substring(0,1);
   // final modal =Provider.of<AppModel>(context, listen: false);
    //final firstletter= user!.username!.substring(0,1);
     final screenWidth = MediaQuery.of(context).size.width;
   // printLog('[AppState] Load Menu');
     final langState = Provider.of<AppModel>(context, listen: true);
    return SafeArea(
      top: drawer.safeArea,
      right: false,
      bottom: false,
      left: false,
      child: Container(
                 height:MediaQuery.of(context).size.height,

        key: drawer.key != null ? Key(drawer.key as String) : UniqueKey(),
        padding:context.isRtl?  EdgeInsets.only(
            bottom:10,top:30,right:8) :EdgeInsets.only(bottom:10,top:30,left:8),
               // injector<AudioManager>().isStickyAudioWidgetActive ? 46 : 0),
        child:
        Container(
          // width: -screenWidth,
          child:
          Padding(
            padding: const EdgeInsets.all(5),
          child:
          Column(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
            children:[
                 Container(
                  margin:const EdgeInsets.only(bottom:10),
                  child: loggedIn ?   
                  //Flexible(
                  //  child:
                  
                   Row(

              children:[
                SizedBox(width:35,),
                CircleAvatar(
            backgroundColor: !Provider.of<AppModel>(context, listen: true).darkTheme? Theme.of(context).primaryColor  : Color(0xffeac85f),//Colors.greenAccent[400],
            radius: 20,
            child: Text(
              '${user!.fullName![0]}',
              style: style.copyWith(fontWeight: FontWeight.w600,fontSize:20,
              color:!Provider.of<AppModel>(context, listen: true).darkTheme?  Color(0xffeac85f) :Theme.of(context).primaryColor,//Color(0xff1B1D26) 
              ),//TextStyle(fontSize: 25, color: iconsColor),
            ), //Text
          ), //CircleAvatar
                // CircleAvatar(
                //   child:Text"(`${user!.username![0]}`"),
                // ),
              SizedBox(width:5,),
              Column(
               // crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  Text(user!.username!,style:style),
                  Text(user!.fullName!,style:style),
                  SizedBox(height:10,),
                ]
              )
              ]
              
            )
            
           // )
            :Container(
              height:20,
            ),
                 ),
            SizedBox(height:10,),
           Flexible(
             // flex:10,
                 //height:MediaQuery.of(context).size.height,
             child: 
              SingleChildScrollView(
          
          // mainAxisAlignment:MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
         // children:[
         
         // Container(
 // scrollDirection: Axis.virtic,
  
           // width: MediaQuery.of(context).size.width  * 0.6,
              child:  Column(
               //  mainAxisAlignment:MainAxisAlignment.spaceBetween,
             // crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                SizedBox(height:10,),
          
          ListTile(
                     // contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),

            leading: Icon(
             // isEcommercePlatform ?
               FontAwesomeIcons.home, 
               //: Icons.shopping_basket,
              size: 20,
              color: iconsColor,
            ),
            title: 
            Padding(
              padding:const EdgeInsets.only(left:0),
              child: Text(
              isEcommercePlatform ? S.of(context).home : S.of(context).shop,
             style: style, 
            //  Theme.of(context).textTheme.bodyText1!.copyWith(
            //       fontWeight: FontWeight.bold,
            //       color: Theme.of(context).colorScheme.secondary,
            //     ),
            //  GoogleFonts.tajawal(
            //      textStyle: style
            //    ),
             //textStyle,
            ),
            ),
           
            onTap: () {
              pushNavigation(RouteList.home);
                 widget?._callback();
              // setState((){
              //   // animationState=true;
              // });
              // print(animationState);
             // widget.animationController = false;
            },
          ),
          //  loggedIn ?
          // ListTile(
          //   leading: Icon(
          //  FontAwesomeIcons.heart,
          //     size: 20,
          //     color: iconsColor,
          //   ),
          //   title: Text(S.of(context).favorite,
          //     // "المفضلة",
          //   style:style
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(RouteList.wishlist);
          //     //pushNavigation(RouteList.language);
          //   },
          //    ) : Container(),
        // ElevatedButton( 
         
        //   child: Text("Pick Delivery location"),
        //   onPressed: () async{
        //     _permissionGranted = await location.requestPermission();
        //     showPlacePicker();
        //   },
        // ),
             loggedIn ?
                ListTile(
            leading: Icon(
           FontAwesomeIcons.cube,
              size: 20,
              color: iconsColor,
            ),
            title: Text(S.of(context).orderHistory,
              // "orders",
            style:style
            ),
            onTap: () async {
            final user = Provider.of<UserModel>(context, listen: false).user;
            FluxNavigate.pushNamed(
              RouteList.orders,
              arguments: user,
            );
          },
             ) : Container(),
             //buildListCategory(),
             ListTile(
            leading: Icon(
             Icons.info,
              size: 20,
             color:
           // !isDarkTheme ?Color(0xff062885) : 
             iconsColor,
            ),
            title: Text(S.of(context).aboutUs,
              // "عن التطبيق",
              style:style,
              //  GoogleFonts.almarai(
              //     textStyle: style
              //   ),
            ),
            onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(
                        pageId: context.isRtl ? 84 : 3491,
                        pageTitle: S.of(context).aboutUs),
                  ));
               //Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen3(), ),);
            },
             ),
          
            //                   ListTile(
            // leading: Icon(
            //  FontAwesomeIcons.question,
            //   size: 20,
            //  color:
            //  //!isDarkTheme ? Color(0xff062885) : 
            //  iconsColor,
            // ),
            // title: Text(S.of(context).faq,
            //  style:style,
            // ),
            // onTap: () {
            //   //  Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(
            //   //       builder: (context) => PostScreen(
            //   //           pageId:6480,//context.isRtl ? 1790 1788 : ,
            //   //           pageTitle: S.of(context).privacyPolicy),
            //   //     ));
            //   // Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen4(), ),);
            // },
            //  ), 
             Divider(
            thickness: 1,
            color:iconsColor,
            indent: 20,
            endIndent: 120,
          ),
             ListTile(
                  leading: Icon(

                    Provider.of<AppModel>(context , listen:false).darkTheme
                        ? CupertinoIcons.sun_min
                        : CupertinoIcons.moon,
                    color: iconsColor,//Theme.of(context).colorScheme.secondary,
                    size: 24,
                  ),
                  //value: Provider.of<AppModel>(context).darkTheme,
                //  activeColor: const Color(0xFF0066B4),
                  onTap: () {
                  // if (Provider.of<AppModel>(context).darkTheme) {
                     // Provider.of<AppModel>(context, listen: false)
                       //   .updateTheme(true);
                  ///  } else {
                     Provider.of<AppModel>(context, listen: false)
                          .updateTheme( ! Provider.of<AppModel>(context , listen:false).darkTheme);
                          //setState((){});
                  //  }
                  },
                  title: Text(Provider.of<AppModel>(context , listen:false).darkTheme ?
                    S.of(context).lightTheme: S.of(context).darkTheme,
                    style: style,
                    //const TextStyle(fontSize: 16),
                  ),
                ), 

          
           ListTile(
            leading: Icon(
               Icons.translate ,
              size: 20,
              color: iconsColor,
            ),
            title: Text(context.isRtl ?
             S.of(context).english : S.of(context).arabic,
             style: style,
            ),
                onTap: () {
                if (context.isRtl){ 
                langState.changeLanguage('en', context)
                .then((value) {
             setState(() {});
              _showLoading('en'
              );
              widget?._callback();
            });
          
                } else{
                  langState.changeLanguage('ar', context)
                .then((value) {
             setState(() {});
              _showLoading('ar'
              );
              widget?._callback();
            });
            // widget?._callback();
                }
          },
          ),
             ListTile(
            leading: Icon(
               Icons.share ,
              size: 20,
              color: iconsColor,
            ),
            title: Text(
             S.of(context).shareapp ,
             style: style,
            ),
                onTap: () async{
                 // Share.share('Visit FlutterCampus at https://www.fluttercampus.com');
            
    await FlutterShare.share(
        title: 'تطبيق ابو شاهر للذبائح',
        text: 'تطبيق ابو شاهر للذبائح',
        linkUrl: 'https://googleplay.com/',
        //chooserTitle: 
        );
 
                },
          ),
          ListTile(
            leading: Icon(
               Icons.call ,
              size: 20,
              color: iconsColor,
            ),
            title: Text(
             S.of(context).contactus ,
             style: style,
            ),
                     onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatUs( ),
                  ));
               //Navigator.push( context,MaterialPageRoute( builder: (context) => PrivacyScreen3(), ),);
            },
          ),
         
                  
          
              ]
            ),
            ),

            ),
            
           SizedBox(height:10,),
          Row(
                 mainAxisAlignment:MainAxisAlignment.start,
                 children:<Widget>[
                  SizedBox(width:30,),
                  // Expanded( 
                  //   child:  
                    IconButton(
                      onPressed:  () =>_launchURL('https://www.instagram.com/abushaher.ksa'),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.instagramSquare, color:iconsColor, size: 25.0)
                    ),
                    IconButton(
                      onPressed:  () =>_launchURL('https://www.snapchat.com/add/abushaher.ksa?share_id=UQofC3YX7c0&locale=ar-AE'),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.snapchatSquare, color:iconsColor, size: 25.0)
                    ),
                 // ),
                  // Expanded( 
                  //   child: 
                     IconButton(
                      onPressed:  () =>_launchURL('https://www.twitter.com/abushaher_ksa'),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.twitterSquare, color:iconsColor, size: 25.0)
                    ),
                 // ),
Expanded(
  child:Container()
),

                ]
                 ),

          
         
            SizedBox(height:20,),

        //  ]
       // ),
       Padding(
        //flex:5,
        padding:const EdgeInsets.only(bottom:0),
        child:  Row(
              children:[
                  SizedBox(width:10,),
               loggedIn ?
                InkWell(
                  onTap:(){ pushNavigation(RouteList.profile);
                 widget?._callback();},
                  child: Row(
                    children:[
                      Icon(Icons.person,color:iconsColor),
                SizedBox(width:10,),
                Text(S.of(context).account,style:style),

                    ]
                  )
                ) :
                SizedBox(),
              
                
                SizedBox(width:10,),
                 loggedIn ?
                Container(width:2,height:20,color:iconsColor) : SizedBox() ,
                SizedBox(width:10,),
                 Expanded(
                  child:
                  ListenableProvider.value(
            value: Provider.of<UserModel>(context, listen: false),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              final loggedIn = userModel.loggedIn;
              return
              InkWell(
                onTap: () {
                  if (loggedIn) {
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (Services().widget.isRequiredLogin) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    }
                    // else {
                    //   pushNavigation(RouteList.dashboard);
                    // }
                  } else {
                    
        //                 final model = Provider.of<UserModel>(context, listen: false);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (_) => SMSLoginScreen(
        //       onSuccess: (user) async {
        //         await model.setUser(user);
        //         Navigator.of(context).pop();
        //         await _welcomeMessage(user);
        //       },
        //     ),
        //   ),
        // );

                    pushNavigation(RouteList.login);
                  }
                },
                child:  Row(
              children:[
                Icon(Icons.exit_to_app, size: 20,color:iconsColor),
                SizedBox(width:10,),
                Text( loggedIn
                    ? S.of(context).logout
                    : S.of(context).login,
                 style:style,//TextStyle(color:iconsColor,fontWeight:FontWeight.bold)
                 ),
                SizedBox(width:10,),

              ])
              ) ;
             
            
            }),
          ),
                      // width:55,
                      // color:Colors.yellow,
               ),
               
              
            
        
              ]
            ),
       )
          




            ]//new column
          )
        //)
       
          ),
      ),
       
      ),
    );
  }

  Widget drawerItem(
    DrawerItemsConfig drawerItemConfig,
    Map<String, GeneralSettingItem> subDrawerItem, {
    Color? iconColor,
    Color? textColor,
  }) {
    // final isTablet = Tools.isTablet(MediaQuery.of(context));

    if (drawerItemConfig.show == false) return const SizedBox();
    var value = drawerItemConfig.type;
    var textStyle = TextStyle(
      color: textColor ?? Theme.of(context).textTheme.bodyText1?.color,
    );

    switch (value) {
      case 'home':
        {
          return ListTile(
            leading: Icon(
              isEcommercePlatform ? Icons.home : Icons.shopping_basket,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              isEcommercePlatform ? S.of(context).home : S.of(context).shop,
              style: textStyle,
            ),
            onTap: () {
              pushNavigation(RouteList.home);
            },
          );
        }
      case 'categories':
        {
          return ListTile(
            leading: Icon(
              Icons.category,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).categories,
              style: textStyle,
            ),
            onTap: () => pushNavigation(
              Provider.of<AppModel>(context, listen: false).vendorType ==
                      VendorType.single
                  ? RouteList.category
                  : RouteList.vendorCategory,
            ),
          );
        }
      case 'cart':
        {
          if ((!Services().widget.enableShoppingCart(null)) ||
              Config().isListingType) {
            return const SizedBox();
          }
          return ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).cart,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.cart),
          );
        }
      case 'profile':
        {
          return ListTile(
            leading: Icon(
              Icons.person,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).settings,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.profile),
          );
        }
      case 'web':
        {
          return ListTile(
            leading: Icon(
              Icons.web,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).webView,
              style: textStyle,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: '',
                    title: S.of(context).webView,
                  ),
                ),
              );
            },
          );
        }
      case 'blog':
        {
          return ListTile(
            leading: Icon(
              CupertinoIcons.news_solid,
              size: 20,
              color: iconColor,
            ),
            title: Text(
              S.of(context).blog,
              style: textStyle,
            ),
            onTap: () => pushNavigation(RouteList.listBlog),
          );
        }
      // case 'login':
      //   {
      //     return
      //      ListenableProvider.value(
      //       value: Provider.of<UserModel>(context, listen: false),
      //       child: 
      //       Consumer<UserModel>(builder: (context, userModel, _) {
      //         final loggedIn = userModel.loggedIn;
      //         return ListTile(
      //           leading: Icon(Icons.exit_to_app, size: 20, color: iconColor),
      //           title: loggedIn
      //               ? Text(S.of(context).logout, style: textStyle)
      //               : Text(S.of(context).login, style: textStyle),
      //           onTap: () {
      //             if (loggedIn) {
      //               Provider.of<UserModel>(context, listen: false).logout();
      //               if (Services().widget.isRequiredLogin) {
      //                 Navigator.of(context).pushNamedAndRemoveUntil(
      //                   RouteList.login,
      //                   (route) => false,
      //                 );
      //               }
      //               // else {
      //               //   pushNavigation(RouteList.dashboard);
      //               // }
      //             } else {
      //               pushNavigation(RouteList.login);
      //             }
      //           },
      //         );
      //       }),
      //     );
      //   }
      case 'category':
        {
          return buildListCategory(textStyle: textStyle);
        }
      default:
        {
          var item = subDrawerItem[value];
          if (value?.contains('web') ?? false) {
            return GeneralWebWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('post') ?? false) {
            return GeneralPostWidget(
              item: item,
              useTile: true,
              iconColor: iconColor,
              textStyle: textStyle,
            );
          }
          if (value?.contains('title') ?? false) {
            return GeneralTitleWidget(item: item);
          }
          if (value?.contains('button') ?? false) {
            return GeneralButtonWidget(item: item);
          }
        }

        return const SizedBox();
    }
  }

  Widget buildListCategory({TextStyle? textStyle}) {
    final categories = Provider.of<CategoryModel>(context).categories;
    var widgets = <Widget>[];

    if (categories != null) {
      var list = categories.where((item) => item.parent == '0').toList();
      print('list');
      print(list);
      for (var i = 0; i < list.length; i++) {
        final currentCategory = list[i];
        var childCategories =
            categories.where((o) => o.parent == currentCategory.id).toList();
        widgets.add(Container(
          color: i.isOdd
              ? null
              : Theme.of(context).colorScheme.secondary.withOpacity(0.1),

          /// Check to add only parent link category
          child: childCategories.isEmpty
              ? InkWell(
                  onTap: () => navigateToBackDrop(currentCategory),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 12,
                      left: 16,
                      top: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          currentCategory.name!.toUpperCase(),
                          style: textStyle,
                        )),
                        const SizedBox(width: 24),
                        currentCategory.totalProduct == null
                            ? const Icon(Icons.chevron_right)
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  S
                                      .of(context)
                                      .nItems(currentCategory.totalProduct!),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              : ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0),
                    child: Text(
                      currentCategory.name!.toUpperCase(),
                      style: textStyle?.copyWith(fontSize: 14) ??
                          const TextStyle(fontSize: 14),
                    ),
                  ),
                  textColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  children:
                      getChildren(categories, currentCategory, childCategories)
                          as List<Widget>,
                ),
        ));
      }
    }

    return ExpansionTile(
      initiallyExpanded: true,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: const EdgeInsets.only(left: 16, right: 8),
      title: Text(
        S.of(context).byCategory.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textStyle?.color ??
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
      ),
      children: widgets,
    );
  }

  List getChildren(
    List<Category> categories,
    Category currentCategory,
    List<Category> childCategories, {
    double paddingOffset = 0.0,
  }) {
    var list = <Widget>[];
    final totalProduct = currentCategory.totalProduct;
    list.add(
      ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 20 + paddingOffset),
          child: Text(S.of(context).seeAll),
        ),
        trailing: ((totalProduct != null && totalProduct > 0))
            ? Text(
                S.of(context).nItems(totalProduct),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              )
            : null,
        onTap: () => navigateToBackDrop(currentCategory),
      ),
    );
    for (var i in childCategories) {
      var newChildren = categories.where((cat) => cat.parent == i.id).toList();
      if (newChildren.isNotEmpty) {
        list.add(
          ExpansionTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20.0 + paddingOffset),
              child: Text(
                i.name!.toUpperCase(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            children: getChildren(
              categories,
              i,
              newChildren,
              paddingOffset: paddingOffset + 10,
            ) as List<Widget>,
          ),
        );
      } else {
        final totalProduct = i.totalProduct;
        list.add(
          ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20 + paddingOffset),
              child: Text(i.name!),
            ),
            trailing: (totalProduct != null && totalProduct > 0)
                ? Text(
                    S.of(context).nItems(i.totalProduct!),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  )
                : null,
            onTap: () => navigateToBackDrop(i),
          ),
        );
      }
    }
    return list;
  }

  void navigateToBackDrop(Category category) {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }
}
