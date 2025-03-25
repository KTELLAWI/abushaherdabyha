import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import '../../common/config.dart' as config;
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../services/index.dart';
// import 'chat_mixin.dart';
// import 'chat_screen.dart';
// import 'scale_animation_mixin.dart';
import 'package:flutter/cupertino.dart';
import '../../common/tools.dart';
import '../../models/index.dart'
    show AppModel, CartModel, ProductWishListModel, User, UserModel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../modules/dynamic_layout/banner/banner_slider.dart';
import '../../modules/dynamic_layout/config/banner_config.dart';


class ChatUs extends StatefulWidget {
  final EdgeInsets? margin;
  final List<Map>? options;

  const ChatUs({this.margin, this.options});

  @override
  _ChatUsState createState() => _ChatUsState();
}

class _ChatUsState extends State<ChatUs>{ 
  bool isShow = true;
   // with ChatMixin, ScaleAnimationMixin, SingleTickerProviderStateMixin {
  List<Map> get optionData => widget.options ?? config.smartChat;
  final bool? runchat = true;
  //       AnimationController? _controller;
  // Animation<double>? animation;
 // TickerProvider get vsync;
  @override
  void initState()  {
  
    super.initState();
  // _runAction1();
   //_runAction();
   // showActionSheet(context: context);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     // options = getSmartChatOptions();
    

    });
  }

  _runAction1() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    if (userModel.user == null) {
             await Navigator.of(context).pushNamed(RouteList.login);
            
          }
    // if (userModel.user!.email == "ktellawi@gmail.com") {
    //       await Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const ChatScreen(),
    //         ),
    //       ); 
    // }
  }
  
// _runAction() async {
//      if (Services().firebase.isEnabled || Config().isBuilder) {
//           final userModel = Provider.of<UserModel>(context, listen: false);
//           if (userModel.user == null) {
//             await Navigator.of(context).pushNamed(RouteList.login);
//             //return;
//           }
//              if (userModel.user!.email == "ktellawi@gmail.com") {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ChatScreen(),
//             ),
//           ); 
//           return ;
//     }
//           // await Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => const ChatScreen(),
//           //   ),
//           // );
//           // return;
//         }
// }
  IconButton getIconButton(
      IconData? iconData, double iconSize, Color iconColor, String? appUrl) {
    return IconButton(
      icon: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      onPressed: () async {
        if (Services().firebase.isEnabled || Config().isBuilder) {
          final userModel = Provider.of<UserModel>(context, listen: false);
          if (userModel.user == null) {
            await Navigator.of(context).pushNamed(RouteList.login);
            return;
          }
        //   await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const ChatScreen(),
        //     ),
        //   );
          return;
        }
        if (await canLaunch(appUrl!)) {
          if (appUrl.contains('http') && !appUrl.contains('wa.me')) {
           // openChat(url: appUrl, context: context);
          } else {
            await launch(appUrl);
          }
          return;
        }
        final snackBar = SnackBar(
          content: Text(
            S.of(context).canNotLaunch,
          ),
          action: SnackBarAction(
            label: S.of(context).undo,
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

  List<Map> getSmartChatOptions() {
    final result = [];
    for (var i = 0; i < optionData.length; i++) {
      switch (optionData[i]['app']) {
        case 'firebase':
          if (Services().firebase.isEnabled || Config().isBuilder) {
            result.add({
              'app': 'firebase',
              'description': optionData[i]['description'] ?? S.of(context).chat,
              'iconData': optionData[i]['iconData'],
              'imageData': optionData[i]['imageData'],
            });
          }
          continue;
        default:
          result.add({
            'app': optionData[i]['app'],
            'description': optionData[i]['description'] ?? '',
            'iconData': optionData[i]['iconData'],
            'imageData': optionData[i]['imageData'],
          });
      }
    }
    return List<Map>.from(result);
  }


  Widget buildItemAction({
    required Map option,
    required BuildContext context,
  }) {
    final iconData = option['iconData'];
    String imageData = option['imageData'] ?? '';
    final description = option['description'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageData.isNotEmpty)
          Image.network(imageData, width: 24, fit: BoxFit.contain),
        if (imageData.isEmpty)
          Icon(
            iconData,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            description,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ),
      ],
    );
  }

  // void openChat({
  //   String? url,
  //   required BuildContext context,
  // }) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(
  //       builder: (BuildContext context) => WebView(
  //         url: url!,
  //         appBar: AppBar(
  //           title: Text(S.of(context).message),
  //           centerTitle: true,
  //           leading: IconButton(
  //               icon: const Icon(Icons.arrow_back),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               }),
  //           elevation: 0.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context)  {
    final isDarkTheme = Provider.of<AppModel>(context).darkTheme;
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
//{
//   "layout":"bannerImage",
//   "design":"stack",
//   "fit":"fitHeight",
//   "marginLeft":15,
//   "items":[
//   {
//   "image":"https://cdn.shopify.com/s/files/1/0667/8157/7441/files/1_copy_2.png?v=1665405684",
//   "category":"",
//   "showSubcategory":false,
//   "bannerWithProduct":false,
//   "defaultShowProduct":false,
//   "products":[]
//   },
//   {
//   "image":"https://cdn.shopify.com/s/files/1/0667/8157/7441/files/1_copy.png?v=1665405684",
//   "category":"",
//   "showSubcategory":false,
//   "bannerWithProduct":false,
//   "defaultShowProduct":false,
//   "products":[]
//   }
//   ],
//   "marginBottom":0,
//   "marginRight":15,
//   "marginTop":0,
//   "radius":2,
//   "padding":0,
//   "enableParallax":false,
//   "parallaxImageRatio":1.2,
//   "isHorizontal":false,
//   "isSlider":true,
//   "autoPlay":false,
//   "intervalTime":3,
//   "showNumber":false,
//   "isBlur":false,
//   "showBackground":false,
//   "upHeight":0,
//   "parallax":false
//   };
final config1 = BannerConfig.fromJson(config);
         final iconsColor = isDarkTheme ? Colors.white.withOpacity(0.6) :Theme.of(context).colorScheme.secondary;

     final userModel = Provider.of<UserModel>(context, listen: false);
//  AnimationController  _controller= AnimationController(vsync:vsync, duration: Duration(milliseconds: 5000));
//  Animation<double> animation = Tween(begin: 0.0, end: 300.0).animate(_controller);
//   _controller.forward();
  //     AnimationController? _controller;
  // Animation<double>? animation;
    final  list = getSmartChatOptions();
    final iconData = list[0]['iconData'];
    String imageData = list[0]['imageData'] ?? '';
    final description = list[0]['description'];
    print(list);
    final user = Provider.of<UserModel>(context, listen: false);
    print(user.user?.email);
    //  final userModel = Provider.of<UserModel>(context, listen: false);
    //  if (userModel.user == null) {
    //    return 
    //  }


        return 
        Stack(
        children: <Widget>[

          if(!Provider.of<AppModel>(context, listen: false).darkTheme )    
                        Image.network(
            "https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
      
Scaffold(
    backgroundColor:Colors.transparent,
    appBar:      AppBar(
           // systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text( context.isRtl?
              'تواصل معنا':"Contact us",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            leading: 
           
                
                Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
          ),
          body:


        Container( 
            decoration:BoxDecoration(
            color:Color(0xff52260f).withOpacity(0.1),
            borderRadius:  BorderRadius.circular(25),
            //Provider.of<AppModel>(context, listen: false).darkTheme? Theme.of(context).backgroundColor :Colors.transparent,


            ),
           // padding:EdgeInsets.all(5),
          margin:EdgeInsets.only(top:MediaQuery.of(context).size.width /5,bottom:MediaQuery.of(context).size.width /5,
          left:MediaQuery.of(context).size.width /8,
          right:MediaQuery.of(context).size.width /8,
          ), 
     child: Center(
        child:     Column( 
         mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
    Text( context.isRtl?
                '''
    لاتترددوا في التواصل معنا
    وارسال استفسارتكم      
    من خلال الوسائل أدناه
                 ''' :
                 '''
    Do not hesitate to contact us And send
    your inquiry through the means below
                 ''',
                 
                 
               //  textAlign:TextAlign.start,
                 style:TextStyle( height: 2.2 ,fontSize:16,color: isDarkTheme ? Colors.white.withOpacity(0.6) : Color(0xff52260f))),
                   SizedBox(height:8),
                  Row(
                 mainAxisAlignment:MainAxisAlignment.spaceAround,
                 children:<Widget>[
                 
                  // Expanded( 
                  //   child:  
                    IconButton(
                      onPressed:  () async => await launch ("https://wa.me/966544851622"),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.whatsapp, color:isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f), size: 30.0)
                    ),
                    IconButton(
                      onPressed:  () async=>await launch("tel:966544851622"),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.phone, color: isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f), size: 30.0)
                    ),
                 // ),
                  // Expanded( 
                  //   child: 
                     IconButton(
                      onPressed:  ()async => await launch("sms://966544851622"),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.sms, color: isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f), size: 30.0)
                    ),
                 // ),


                ]
                 ),
                 SizedBox(height:25),

    //    Row(
    //       mainAxisAlignment:MainAxisAlignment.spaceEvenly,
    //     children:[
        

    //       Flexible(
    //         child:                ListTile(
    //         leading: Icon(
    //        FontAwesomeIcons.sms,
    //           size: 20,
    //          // color: iconsColor,
    //         ),
    //        // title:Text("رسالة",) ,
    //           // "orders",
    //        // style:style
    //         onTap:() async {await launch("sms://9647724886000"); },
    //         ),
           
    //          ),
    //      // ) ,
    //       Flexible(child:                ListTile(
    //         leading: Icon(
    //        FontAwesomeIcons.phone,
    //           size: 20,
    //          // color: iconsColor,
    //         ),
    //        // title: Text("هاتف",),
    //           // "orders",
    //        // style:style
    //        onTap:() async { await launch("tel:9647724886000");},
    //         ),
             

    //          ),
          
    //      // )   ,
    //           Flexible(
    //         child:ListTile(
    //         leading: Icon(
    //        FontAwesomeIcons.whatsapp,
    //           size: 20,
    //          // color: iconsColor,
    //         ),
    //        // title:Text("واتس"),
    //           // "orders",
    //        // style:style
    //           onTap: () async { await launch("https://wa.me/9647724886000");},
    //         ),
          
    //          ),
    //      // ) ,      


                        
   
    //     ]
      
    
       


                        
   
    // //     ]
    //    ),
     
Text(context.isRtl?
                '''
    ويمكنم متابعتنا على
    وسائل التواصل الاجتماعي
                 ''' :
    '''
    You can follow us on Social media
    
    '''
                 ,
                 //textAlign:TextAlign.start,
                 style:TextStyle( height: 2.2 ,fontSize:16,color:isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f))),
                 SizedBox(height:3),

                         Row(
                 mainAxisAlignment:MainAxisAlignment.spaceAround,
                 children:<Widget>[
                 
                  // Expanded( 
                  //   child:  
                    IconButton(
                      onPressed:  () async => await launch ("https://www.twitter.com/abushaher_ksa"),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.twitter, color:isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f), size: 30.0)
                    ),
                    IconButton(
                      onPressed:  () async=>await launch("https://www.snapchat.com/add/abushaher.ksa?share_id=UQofC3YX7c0&locale=ar-AE"),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.snapchat, color:isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f), size: 30.0)
                    ),
                 // ),
                  // Expanded( 
                  //   child: 
                     IconButton(
                      onPressed:  ()async => await launch("https://www.instagram.com/abushaher.ksa"),//_addToCart(context, enableBottomSheet),
                      icon:  Icon(FontAwesomeIcons.instagram, color:isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f), size: 30.0)
                    ),
                 // ),


                ]
                 ),
      
   
 


     ],
     ),

        ),
        ),
),

//////////////////////////

Align(
  alignment:Alignment.bottomCenter,
  child:SizedBox( 
             // height:42, //height of button
              width:double.infinity, //width of button
              child:
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary:Color(0xff52260f),// Theme.of(context).primaryColor,//Colors.black, //background color of button
                
                  shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.0),
              )),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed:() 
               { 
                ///
                showModalBottomSheet(
         // isScrollControlled: true,
            context: context,
                 shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
     // backgroundColor:!isDarkTheme ? Colors.white.withOpacity(0.6):Color(0xff52260f),
            builder: (sContext) => Container(
             // decoration: new BoxDecoration(
              //  color:Colors.red,
                                     // shape: BoxShape.circle,
                                     // border: new Border.all(color: Colors.black),
                                    
                  //                     image: new DecorationImage(
                  //                         fit: BoxFit.cover,
                  //                         image:  !isDarkTheme? new NetworkImage(
                  //                              "https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg") : null,),
                  // ) 
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  child: BannerSlider(
                    config:config1,
                    onTap:(){}
                  ),
                  
                
                )
                );
                
                
                }, 
                child: Text('حسابتنا البنكية',style:TextStyle(color: Colors.white)) 
              ),
            ),

),


//if (isShow)


        ],
    );

 


  }

 }