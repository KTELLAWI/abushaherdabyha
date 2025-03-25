import 'dart:async';
import 'package:fstore/screens/users/user_point_screen.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:fstore/common/tools/adaptive_tools.dart';
import '../common/config.dart';
import '../common/constants.dart';
import '../generated/l10n.dart';
import '../main_layout/layout_left_menu.dart';
import '../models/index.dart';
import '../modules/dynamic_layout/config/tab_bar_config.dart';
import '../modules/dynamic_layout/helper/helper.dart';
import '../modules/dynamic_layout/index.dart';
import '../routes/flux_navigate.dart';
import '../routes/route.dart';
import '../screens/index.dart' show NotificationScreen;
import '../widgets/overlay/custom_overlay_state.dart';
import 'maintab_delegate.dart';
import 'side_menu.dart';
import 'sidebar.dart';
import 'package:fstore/screens/settings/language_screen.dart';
import 'dart:math' as math;
import 'package:fstore/main.dart';
import '../screens/chat/bottom_sheet_smart_chat.dart';
import 'dart:ui';
//import 'package:firebase_messaging/firebase_messaging.dart';

//import '../screens/order_history/views/list_order_history_screen.dart';

//import '../screens/order_history/models/list_order_history_model.dart'  ;

const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

/// Include the setting fore main TabBar menu and Side menu
class MainTabs extends StatefulWidget {
  const MainTabs({Key? key}) : super(key: key);

  @override
  MainTabsState createState() => MainTabsState();
}

class MainTabsState extends CustomOverlayState<MainTabs>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  /// check Desktop screen and app Setting variable
  bool isDragging = false;
   int count=10;

 

  bool get isDesktopDisplay => Layout.isDisplayDesktop(context);
  late AnimationController _animationController;
  AppSetting get appSetting =>
      Provider.of<AppModel>(context, listen: false).appConfig!.settings;
String item = "post";
  final navigators = <int, GlobalKey<NavigatorState>>{};

  /// TabBar variable
  late TabController tabController;
  var isInitialized = false;

  final List<Widget> _tabView = [];
  Map saveIndexTab = {};
  Map<String, String?> childTabName = {};
  int currentTabIndex = 0;

  List<TabBarMenuConfig> get tabData =>
      Provider.of<AppModel>(context, listen: false).appConfig!.tabBar;

  @override
  bool get hasLabelInBottomBar =>
      tabData.any((tab) => tab.label?.isNotEmpty ?? false);

  /// Drawer variable
  bool isShowCustomDrawer = false;

  bool get shouldHideTabBar =>
      isDesktopDisplay ||
      (isShowCustomDrawer && Layout.isDisplayTablet(context));

  StreamSubscription? _subOpenCustomDrawer;
  StreamSubscription? _subCloseCustomDrawer;

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    _initListenEvent();
    _initTabDelegate();
    _initTabData(context);
   // toggleAnimation();

    // if (kAdvanceConfig.enableVersionCheck) {
    //   NewVersion().showAlertIfNecessary(context: context);
    // }
  }

  /// init the Event Bus listening
  void _initListenEvent() {
    _subOpenCustomDrawer = eventBus.on<EventOpenCustomDrawer>().listen((event) {
      setState(() {
        isShowCustomDrawer = true;
      });
    });
    _subCloseCustomDrawer =
        eventBus.on<EventCloseCustomDrawer>().listen((event) {
      setState(() {
        isShowCustomDrawer = false;
      });
    });
  }

  /// Check pop navigator on the Current tab, and show Confirm Exit App
  Future<bool> _handleWillPopScopeRoot() async {
    print(tabController.index);
    final currentNavigator = navigators[tabController.index]!;
    if (currentNavigator.currentState!.canPop()) {
      currentNavigator.currentState!.pop();
      return Future.value(false);
    }

    /// Check pop root navigator
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return Future.value(false);
    }

    if (tabController.index != 0) {
      tabController.animateTo(0);
      _emitChildTabName();
      return Future.value(false);
    } else {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(S.of(context).areYouSure),
          content: Text(S.of(context).doYouWantToExitApp),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).no),
            ),
            TextButton(
              onPressed: () {
                if (isIos) {
                  Navigator.of(context).pop(true);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Text(S.of(context).yes),
            ),
          ],
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    isShowCustomDrawer = isDesktopDisplay;
    super.didChangeDependencies();
  }
  //  _animationController;

  // @override
  // void initState() {
  //   super.initState();
  //  // toggleAnimation();
  //   _animationController = AnimationController(
  //       vsync: this, duration: const Duration(milliseconds: 300));
  // }

  @override
  void dispose() {
     _animationController!.dispose();
    if (isInitialized) {
      tabController.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    _subOpenCustomDrawer?.cancel();
    _subCloseCustomDrawer?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Handle the DeepLink notification
    if (state == AppLifecycleState.paused) {
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      final appModel = Provider.of<AppModel>(context, listen: false);
      if (appModel.deeplink?.isNotEmpty ?? false) {
        if (appModel.deeplink!['screen'] == 'NotificationScreen') {
          appModel.deeplink = null;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
        }
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  void toggleAnimation() {
    // if (animationState == false ){
    //  _animationController.reverse(); 
    //  setState((){});
    // }
    _animationController.isDismissed
   ? _animationController.forward()
   : _animationController.reverse();
    // setState((){});
   }
  // void toggleAnimation() {
    
  //    _animationController.forward();
   
 
  // }
  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging.instance.subscribeToTopic("general");
      count=  Provider.of<NotificationModel>(context).unreadCount;
      var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
            final rightSlide =  context.isRtl ? MediaQuery.of(context).size.width * -0.6 : MediaQuery.of(context).size.width * 0.6;

    //customTabBar();
    printLog('[TabBar] ============== tabbar.dart ==============');

    var appConfig = Provider.of<AppModel>(context, listen: false).appConfig;

    if (_tabView.isEmpty || appConfig == null) {
      return Container(
        color: Colors.white,
      );
    }

    final media = MediaQuery.of(context);
    final isTabBarEnabled = appSetting.tabBarConfig.enable;
    final showFloating = appSetting.tabBarConfig.showFloating;
    final isClip = appSetting.tabBarConfig.showFloatingClip;
    final floatingActionButtonLocation =
        appSetting.tabBarConfig.tabBarFloating.location ??
            FloatingActionButtonLocation.centerDocked;
print(tabController.index);
    printLog('[ScreenSize]: ${media.size.width} x ${media.size.height}');
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        // Related Scale and Translate values
         double slide = rightSlide*_animationController.value;
        double scale = 1 - (_animationController!.value * 0.3);

        return 
        // Container( 
        //         decoration: BoxDecoration(
        //    // color: Colors.black,
        //      borderRadius: BorderRadius.circular(0), //border corner radius
        //      boxShadow:[ 
        //        BoxShadow(
        //           color: Colors.white, //color of shadow
        //           spreadRadius: 5, //spread radius
        //           blurRadius: 4, // blur radius
        //           offset: Offset(10, 0), // changes position of shadow
        //           //first paramerter of offset is left-right
        //           //second parameter is top to down
        //        ),
        //        //you can set more BoxShadow() here
        //       ],
        //   ),
        //   child:
          Stack(
          children:[ 
             if (!Provider.of<AppModel>(context, listen: false).darkTheme)  
                  Image.network(
            "https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
            //Text('ddd'),
         Container(
            //Color: ! Provider.of<AppModel>(context, listen: true).darkTheme ? Color(0xffffdf90) : Color(0xff1B1D26),//  Theme.of(context).backgroundColor,// : Colors.red,//Color(0xffffdf90) ,
//const kDarkBgLight = Color(0xff282D39);//Theme.of(context).backgroundColor,// Colors.blue,
            child: SideBarMenu(toggleCoinCallback: toggleAnimation,),//Text('ddddddddddddddddddddddddddd'),
          ),
      Positioned(
        
        child:
         GestureDetector(
                  onTap: () {
                    toggleAnimation();},
                  onHorizontalDragStart: (details)=>isDragging = true,
                  onHorizontalDragUpdate:(details){
                    if (!isDragging) return;
                    const delta=1;
                    if(details.delta.dx > delta){
                       toggleAnimation();
                    }
                    else if (details.delta.dx < - delta){
                          toggleAnimation();
                    }
                    isDragging = false;
                  },

                  child:
         Transform(
               transform: Matrix4.identity()
                ..translate(slide)
                ..scale(scale),
              alignment: Alignment.center,
              child: ClipRRect(
          borderRadius: BorderRadius.circular( _animationController.isDismissed ? 0 : 30),
            child:   Container(
         
          decoration: BoxDecoration(
             boxShadow:[ 
               BoxShadow(
                  color:Theme.of(context).backgroundColor, //Colors.white, //color of shadow
                  spreadRadius: 0, //spread radius
                  blurRadius: 0, // blur radius
                  offset: Offset(-1.80, 0), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is twhiteop to down
               ),
               //you can set more BoxShadow() here
              ],
            color: Theme.of(context).backgroundColor,
             borderRadius: BorderRadius.circular(30)),

                child: Padding(
                  padding: EdgeInsets.all(!_animationController.isDismissed ? 15 : 0),
                  child:AbsorbPointer(
                    absorbing:!_animationController.isDismissed,
                  child:
                    //getScreen(item),
                
              //  )
                SideMenu(
                backgroundColor:Colors.transparent,
                  //  showFloating ? null : Theme.of(context).backgroundColor,
                bottomNavigationBar: isTabBarEnabled
                    ? (showFloating
                        ? BottomAppBar(
                            shape: isClip
                                ? const CircularNotchedRectangle()
                                : null,
                            child: tabBarMenu(),
                          )
                        : tabBarMenu())
                    : null,
                tabBarOnTop: appConfig.settings.tabBarConfig.enableOnTop,
                floatingActionButtonLocation: floatingActionButtonLocation,
                floatingActionButton:
                  showFloating ? 
                    getTabBarMenuAction()
                     : null,
                zoomConfig: appConfig.drawer?.zoomConfig,
                sideMenuBackground: appConfig.drawer?.backgroundColor,
                sideMenuBackgroundImage: appConfig.drawer?.backgroundImage,
                colorFilter: appConfig.drawer?.colorFilter,
                filter: appConfig.drawer?.filter,
//                  drawer:           IconButton(
//   onPressed: ()=>_toggleAnimation(),
//   icon: AnimatedIcon(
//     icon: AnimatedIcons.menu_close,
//     progress: _animationController,
//   ),
// ),
   
              //  drawer:const SideBarMenu(),
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    primaryColor: Theme.of(context).colorScheme.secondary,
                    barBackgroundColor: Theme.of(context).backgroundColor,
                    textTheme: CupertinoTextThemeData(
                      navActionTextStyle:
                          Theme.of(context).primaryTextTheme.button,
                      navTitleTextStyle: Theme.of(context).textTheme.headline5,
                      navLargeTitleTextStyle:
                          Theme.of(context).textTheme.headline4!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  child: WillPopScope(
                    onWillPop: _handleWillPopScopeRoot,
                    child: LayoutLeftMenu(
                      //menu: const SideBarMenu(),
                      content: MediaQuery(
                        data: isDesktopDisplay
                            ? media.copyWith(
                                size: Size(
                                media.size.width - kSizeLeftMenu,
                                media.size.height,
                              ))
                            : media,
                        child: ChangeNotifierProvider.value(
                          value: tabController,
                          child: Consumer<TabController>(
                              builder: (context, controller, child) {
                            /// use for responsive web/mobile
                            return Stack(
                              fit: StackFit.expand,
                              children: List.generate(
                                _tabView.length,
                                (index) {
                                  final active = controller.index == index;
                                  return//Text('dddd');
                                  Offstage(
                                    offstage: !active,
                                    child: TickerMode(
                                      enabled: active,
                                      child: _tabView[index],
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                  ),
               )
              ),
              ),
          
                 ),        ),
      
      ),
      //   Positioned(
      //   //  top:0,d
      //  child: _animationController.isDismissed ?
      //    Transform(
      //    transform: 
      //    Matrix4.identity()
      //           ..translate(- screenWidth + 5 ) ,
      //     child:Scaffold(
            
      //      backgroundColor: Colors.blue,
      //       body:   Container(),//Text('ddddddddddddddddddddddddddd'),
      //     ),
      //    ):  Transform(
      //    transform: 
      //    Matrix4.identity()
      //           ..translate(- screenWidth) ,
      //     child:Scaffold(
            
      //      backgroundColor: Colors.blue,
      //       body:   Container(),
      //     ),
      //    ),
      //     ),
         
  //                     Positioned(
  //         top:17,
  //                  child:  IconButton(
  //         //  margin:const EdgeInsets.only(left:0),
  // onPressed: ()=>toggleAnimation(),
  
  // color:Colors.red,
  
  // icon: AnimatedIcon(
  //   size:25,
  //   icon: AnimatedIcons.menu_close,
  //   progress: _animationController,
  // ),
  //           )  ),
             
//         Positioned(
//           top:27,
//           // left: context.isRtl ? 0 : -15 ,
//           // right: context.isRtl ? -15 : 0 ,
//           child:ClipPath(
//                     clipper: CustomMenuClipper(),
//        child:   Container(
//             width:40,
//            height:65,
//           //  padding:const EdgeInsets.only(left:0, right:13),
// //mainAxisAlignment:MainAxisAlignment.end,
//            decoration: BoxDecoration(
//            color:_animationController.isDismissed ? Colors.blue : Colors.orange,
//            borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(-20.0),
//                             bottomLeft: Radius.circular(20.0),
//                             topLeft: Radius.circular(50.0),topRight: Radius.circular(-50.0),

//                             ), //border corner radius
//              boxShadow:[ 
//                BoxShadow(
//                   color: Colors.grey, //color of shadow
//                   spreadRadius:1, //spread radius
//                   blurRadius: 1, // blur radius
//                   offset: Offset(0, 0.5), // changes position of shadow
//               //     //first paramerter of offset is left-right
//               //     //second parameter is top to down
//                 ),
//                //you can set more BoxShadow() here
//               ],
//           ),
//           child: Center(
//           //  alignment: Alignment.center,
//             child: 
//             IconButton(
//           //  margin:const EdgeInsets.only(left:0),
//   onPressed: ()=>toggleAnimation(),
  
//   color:Colors.white,
  
//   icon: AnimatedIcon(
//     size:25,
//     icon: AnimatedIcons.menu_close,
//     progress: _animationController,
//   ),
//             )    
//          )   //align

    
          
//           )
//           )
          
//           ),
          
          Container(
               // left:0, 
                child: tabController.index == 0 || tabController.index == 2 ? 
               // print(tabController.index)
                GestureDetector(
                  onTap: () {
                    //onIconPressed();
                  },
                  child: 
                  ClipPath(
                    clipper:!context.isRtl ? CustomMenuClipper() : CustomMenuClipperRight() ,
                    child: Transform.rotate(angle: 0 ,
    //alignment: Alignment.topRight,
    //transform: Matrix4.skewY(0.3)..rotateZ(-math.pi / 12.0),
                   child: Container(
                    color:  !Provider.of<AppModel>(context, listen: true).darkTheme? Color(0xff52260f) :Color(0xffeac85f),//Theme.of(context).primaryColorLight,// : Color(0xff52260f),
                      
                               //  color:Theme.of(context).backgroundColor,
                                 

                      width: 35,
                      height: 110,
                     // color: Colors.white,//Color(0xFF262AAA),
                      alignment: Alignment.center,
                      child:BackdropFilter(
            filter: ImageFilter.blur(sigmaX:0.0, sigmaY: 0.0),
            child:
                      InkWell(
                        onTap:()=>toggleAnimation(),
                        child: AnimatedIcon(
                        progress: _animationController,
                        icon: AnimatedIcons.menu_close,
                        color: !Provider.of<AppModel>(context, listen: true).darkTheme ? Color(0xffeac85f): Color(0xff52260f),
                        size: 25,
                      ), 
                      ) 
                      ),
                      
                      
  //                      IconButton(
  //         //  margin:const EdgeInsets.only(left:0),
  // onPressed: ()=>toggleAnimation(),
  
  // color:Colors.white,
  
  // icon: AnimatedIcon(
  //   size:25,
  //   icon: AnimatedIcons.menu_close,
  //   progress: _animationController,
  // ),
  //           ) 
                      
                      
                      
                      
                      
                    ),
                    ),
                  ),
                )
                :
                SizedBox(),
              ),
              _animationController.isDismissed ? 
              BottomSheetSmartChat(): SizedBox(),
          //      ChangeNotifierProvider<ListOrderHistoryModel>(
          //   create: (context) => 
          //   ListOrderHistoryModel(
          //   //   repository: ListOrderRepository(
          //   //       user: user == null ? User() : user as User),
          //   // ),
          //   child: 
          // ),
          //      )
              
            //    ListenableProvider.value(
            // value: Provider.of<ListOrderHistoryModel>(context, listen: false),
            // child: Consumer<ListOrderHistoryModel>(builder: (context, order, _) {
            //  // final loggedIn = userModel.loggedIn;
            //   return
            //   ListOrderHistoryScreen();
            // }
            // )
            //    )
          ///// p1
//            Positioned(
//           top:77,
//           // left: context.isRtl ? 0 : -15 ,
//           // right: context.isRtl ? -15 : 0 ,
//           child:
//           Container(
//             width:50,
//            // height:30,
//           //  padding:const EdgeInsets.only(left:0, right:13),
// //mainAxisAlignment:MainAxisAlignment.end,
//            decoration: BoxDecoration(
//            color:_animationController.isDismissed ? Colors.blue : Colors.orange,
//            borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(50.0),
//                             topLeft: Radius.circular(50.0),
//                             ), //border corner radius
//              boxShadow:[ 
//                BoxShadow(
//                   color: Colors.grey, //color of shadow
//                   spreadRadius:1, //spread radius
//                   blurRadius: 1, // blur radius
//                   offset: Offset(0, 0.5), // changes position of shadow
//               //     //first paramerter of offset is left-right
//               //     //second parameter is top to down
//                 ),
//                //you can set more BoxShadow() here
//               ],
//           ),
//           child: Center(
//           //  alignment: Alignment.center,
//             child: 
//             IconButton(
//           //  margin:const EdgeInsets.only(left:0),
//   onPressed: (){
//    // item ='nipost';
//     setState((){
//       if (item == 'post')
// {        item ='nipost';}
// else{
//   item ='post';
// }
//     });
//   },
  
//   color:Colors.white,
  
//   icon: AnimatedIcon(
//     size:25,
//     icon: AnimatedIcons.menu_close,
//     progress: _animationController,
//   ),
//             )    
//          )   //align

    
          
//           )
          
//           )
     
        ]
        );
        //);
      },
    );
  }
}
 
Widget getScreen(item) {
  switch (item){
    case 'post' :
    return  LanguageScreen();//Text('koutaiba');//language_screen();
  default:
  return UserPointScreen();
  
  }

  
  }

extension TabBarMenuExtention on MainTabsState {
  /// on change tabBar name
  void _onChangeTab(String? nameTab) {
    if (saveIndexTab[nameTab] != null) {
      tabController.animateTo(saveIndexTab[nameTab]);
      _emitChildTabName();
    } else {
      FluxNavigate.pushNamed(nameTab.toString(), forceRootNavigator: true);
    }
  }

  /// init Tab Delegate to use for SmartChat & Ads feature
  void _initTabDelegate() {
    var tabDelegate = MainTabControlDelegate.getInstance();
    tabDelegate.changeTab = _onChangeTab;
    tabDelegate.tabKey = () => navigators[tabController.index];
    tabDelegate.currentTabName = _getCurrentTabName;
    tabDelegate.tabAnimateTo = (int index) {
      if (index < tabController.length) {
        tabController.animateTo(index);
      }
    };
    WidgetsBinding.instance.addObserver(this);
  }

  Navigator tabViewItem({key, initialRoute, args}) {
    return Navigator(
      key: key,
      initialRoute: initialRoute,
      observers: [
        MyRouteObserver(
          action: (screenName) {
            childTabName[initialRoute!] = screenName;
            OverlayControlDelegate().emitTab?.call(screenName);
          },
        ),
      ],
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == initialRoute) {
          return Routes.getRouteGenerate(RouteSettings(
            name: initialRoute,
            arguments: args,
          ));
        }
        return Routes.getRouteGenerate(settings);
      },
    );
  }

  /// init the tabView data and tabController
  void _initTabData(context) async {
    var appModel = Provider.of<AppModel>(context, listen: false);

    /// Fix the empty loading appConfig on Web
    // if (appModel.appConfig == null && kIsWeb) {
    //   await appModel.loadAppConfig();
    // }

    var tabData = appModel.appConfig!.tabBar;
    var enableOnTop =
        appModel.appConfig?.settings.tabBarConfig.enableOnTop ?? false;
    for (var i = 0; i < tabData.length; i++) {
      var dataOfTab = tabData[i];
      saveIndexTab[dataOfTab.layout] = i;
      navigators[i] = GlobalKey<NavigatorState>();
      final initialRoute = dataOfTab.layout;
      if (enableOnTop) {
        _tabView.add(
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: EdgeInsets.zero,
              viewPadding: EdgeInsets.zero,
            ),
            child: tabViewItem(
              key: navigators[i],
              initialRoute: initialRoute,
              args: dataOfTab,
            ),
          ),
        );
      } else {
        _tabView.add(
          tabViewItem(
            key: navigators[i],
            initialRoute: initialRoute,
            args: dataOfTab,
          ),
        );
      }
    }
    // ignore: invalid_use_of_protected_member
    setState(() {
      tabController = TabController(length: _tabView.length, vsync: this);
    });
    if (MainTabControlDelegate.getInstance().index != null) {
      tabController.animateTo(MainTabControlDelegate.getInstance().index!);
    } else {
      MainTabControlDelegate.getInstance().index = 0;
    }
    isInitialized = true;

    /// Load the Design from FluxBuilder
    tabController.addListener(() {
      if (tabController.index == currentTabIndex) {
        eventBus.fire(EventNavigatorTabbar(tabController.index));
        MainTabControlDelegate.getInstance().index = tabController.index;
      }
    });
  }

  void _emitChildTabName() {
    final tabName = _getCurrentTabName();
    setState((){});
    OverlayControlDelegate().emitTab?.call(childTabName[tabName]);
  }

  String _getCurrentTabName() {
    if (saveIndexTab.isEmpty) {
      return '';
    }
    return saveIndexTab.entries
            .firstWhereOrNull((element) => element.value == tabController.index)
            ?.key ??
        '';
  }

  /// on tap on the TabBar icon
  void _onTapTabBar(index) {
    if (currentTabIndex == index) {
      navigators[tabController.index]!.currentState!.popUntil((r) => r.isFirst);
    }
    currentTabIndex = index;

    _emitChildTabName();

    // if (!kIsWeb && !isDesktop) {
    //   if ('cart' == tabData[index].layout) {
    //     FlutterWebviewPlugin().show();
    //   } else {
    //     FlutterWebviewPlugin().hide();
    //   }
    // }
  }

  /// return the tabBar widget
  Widget tabBarMenu() {
    return Selector<CartModel, int>(
      selector: (_, cartModel) => cartModel.totalCartQuantity,
     // selector: (_, NotificationModel) => NotificationModel.unreadCount,
      builder: (context, totalCart, child) {
        return TabBarCustom(
          onTap: _onTapTabBar,
          tabData: tabData,
          tabController: tabController,
          config: appSetting,
          shouldHideTabBar: shouldHideTabBar,
          totalCart: totalCart,
          notificationCount:count
        );
      },
    );
  }

  /// Return the Tabbar Floating
  Widget getTabBarMenuAction() {
    var position =appSetting.tabBarConfig.tabBarFloating.position;
    var itemIndex = (position != null && position < tabData.length)
        ? position
        : (tabData.length / 2).floor();

    return Selector<CartModel, int>(
      selector: (_, cartModel) => cartModel.totalCartQuantity,
      builder: (context, totalCart, child) {
        return IconFloatingAction(
          config: appSetting.tabBarConfig.tabBarFloating,
          item: tabData[itemIndex].jsonData,
          onTap: () {
            tabController.animateTo(itemIndex);
            _onTapTabBar(itemIndex);
          },
          totalCart: totalCart,
          notificationCount:count
        );
      },
    );
  }

  void customTabBar() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('FF672D')
      ..indicatorStyle = IndicatorStyle.none
      ..showFloating = true
      ..showFloatingClip = false
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('FF672D'),
        // width: 65,
        // height: 40,
      );
  }

  /// custom the TabBar Style
  void customTabBar3() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('FF672D')
      ..indicatorStyle = IndicatorStyle.none
      ..showFloating = true
      ..showFloatingClip = false
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('FF672D'),
        width: 70,
        height: 70,
        elevation: 10.0,
        floatingType: FloatingType.diamond,
        // width: 65,
        // height: 40,
      );
  }

  void customTabBar2() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorCart = HexColor('FE2060')
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('1D34C5')
      ..indicatorStyle = IndicatorStyle.material
      ..showFloating = true
      ..showFloatingClip = true
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('1D34C5'),
        elevation: 2.0,
      )
      ..tabBarIndicator = TabBarIndicatorConfig(
        color: HexColor('1D34C5'),
        verticalPadding: 10,
        tabPosition: TabPosition.top,
        topLeftRadius: 0,
        topRightRadius: 0,
        bottomLeftRadius: 10,
        bottomRightRadius: 10,
      );
  }

  void customTabBar1() {
    /// Design TabBar style 1
    appSetting.tabBarConfig
      ..color = HexColor('1C1D21')
      ..colorCart = HexColor('FE2060')
      ..isSafeArea = false
      ..marginBottom = 15.0
      ..marginLeft = 15.0
      ..marginRight = 15.0
      ..paddingTop = 12.0
      ..paddingBottom = 12.0
      ..radiusTopRight = 15.0
      ..radiusTopLeft = 15.0
      ..radiusBottomRight = 15.0
      ..radiusBottomLeft = 15.0
      ..paddingRight = 10.0
      ..indicatorStyle = IndicatorStyle.rectangular
      ..tabBarIndicator = TabBarIndicatorConfig(
        color: HexColor('22262C'),
        topRightRadius: 9.0,
        topLeftRadius: 9.0,
        bottomLeftRadius: 9.0,
        bottomRightRadius: 9.0,
        distanceFromCenter: 10.0,
        horizontalPadding: 10.0,
      );
  }
}
class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    //path.moveTo(0, 0);
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
class CustomMenuClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    //path.moveTo(0, 0);
    path.moveTo(width, 0);
    path.quadraticBezierTo(width, 8, width-10, 16);
    path.quadraticBezierTo(1, height / 2 - 20, 0, height / 2);
    path.quadraticBezierTo( 0, height / 2 + 20, width -10, height - 16);
    path.quadraticBezierTo(width, height - 8, width, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}