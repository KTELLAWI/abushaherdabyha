import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart';
import '../../services/services.dart';
import '../../widgets/common/flux_image.dart';
import '../../widgets/common/login_animation.dart';
import 'verify.dart';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginSMSScreen extends StatefulWidget {
  const LoginSMSScreen();

  @override
  LoginSMSScreenState createState() => LoginSMSScreenState();
}

class LoginSMSScreenState<T extends LoginSMSScreen> extends State<T>
    with TickerProviderStateMixin {
  late AnimationController _loginButtonController;
  final TextEditingController _controller = TextEditingController(text: '');

  CountryCode? countryCode;
  String? phoneNumber ;
  String? _phone;
  bool isLoading = false;

  late final verifySuccessStream;

  @override
  void initState() {
    super.initState();
    verifySuccessStream = Services().firebase.getFirebaseStream();

    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _phone = '';

    if (LoginSMSConstants.dialCodeDefault.isNotEmpty ||
        LoginSMSConstants.countryCodeDefault.isNotEmpty ||
        LoginSMSConstants.nameDefault.isNotEmpty) {
      countryCode = CountryCode(
        code: LoginSMSConstants.countryCodeDefault.isNotEmpty
            ? LoginSMSConstants.countryCodeDefault
            : null,
        dialCode: LoginSMSConstants.dialCodeDefault.isNotEmpty
            ? LoginSMSConstants.dialCodeDefault
            : null,
        name: LoginSMSConstants.nameDefault.isNotEmpty
            ? LoginSMSConstants.nameDefault
            : null,
      );
    }

    _controller.addListener(() {
      if (_controller.text != _phone && _controller.text != '') {
        _phone = _controller.text;
        onPhoneNumberChange(
          _phone,
          '${countryCode!.dialCode}$_phone',
          countryCode!.code,
        );
      }
    });
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
  }

  void failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      content: Text('⚠️: $message'),
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void onPhoneNumberChange(
    String? number,
    String internationalizedPhoneNumber,
    String? isoCode,
  ) {
    if (internationalizedPhoneNumber.isNotEmpty) {
      phoneNumber = internationalizedPhoneNumber;
    } else {
      phoneNumber = null;
    }
  }

  Future<void> loginSMS(context) async {
 FirebaseMessaging.instance.subscribeToTopic("general");

    if (phoneNumber == null) {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).pleaseInput);
    } else {
      await playAnimation();

      Future autoRetrieve(String verId) {
        return stopAnimation();
      }

      Future smsCodeSent(String verId, [int? forceCodeResend]) {
        stopAnimation();
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCode(
              verId: verId,
              phoneNumber: phoneNumber,
              verifySuccessStream: verifySuccessStream.stream,
              resendToken: forceCodeResend,
            ),
          ),
        );
      }

      final verifiedSuccess = verifySuccessStream.add;

      void verifyFailed(exception) {
        stopAnimation();
        failMessage(exception.message, context);
      }

      Services().firebase.verifyPhoneNumber(
            phoneNumber: phoneNumber!,
            codeAutoRetrievalTimeout: autoRetrieve,
            codeSent: smsCodeSent,
            verificationCompleted: verifiedSuccess,
            verificationFailed: verifyFailed,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: true);
    final themeConfig = appModel.themeConfig;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title:Text(S.of(context).login,
        style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.secondary,//Theme.of(context).colorScheme.onBackground,
          ),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushNamed(RouteList.home);
            }
          },
        ),
        backgroundColor: Colors.transparent,//Color(0xff52260f),//Provider.of<AppModel>(context, listen: false).darkTheme ? Color(0xffffdf90).withOpacity(0.5): Colors.white.withOpacity(0.5),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) => Stack(
        
            children: [
                    if(!Provider.of<AppModel>(context, listen: false).darkTheme )    
                        Image.network(
            "https://abushaher-f6afbkd9cygcaagj.germanywestcentral-01.azurewebsites.net/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
              ListenableProvider.value(
                value: Provider.of<UserModel>(context),
                child: Consumer<UserModel>(
                  builder: (context, model, child) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                      
                      margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/4), 
                      decoration: BoxDecoration(
                      // color:Colors.white,
      //                  boxShadow: [
      // //            // if (widget.config.boxShadow != null)
      //               BoxShadow(
      //                 color: Colors.grey.withOpacity(0.4),//Color(0xffc8ddf7),
      //                 offset: Offset(
      //                    1.1,
      //                   -1.1,
      //                 ),
      //                 blurRadius:  1.0,
      //               ),
      //           ],
         // borderRadius: BorderRadius.circular(25),
           borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
             bottomLeft: const Radius.circular(30.0),
            bottomRight: const Radius.circular(30.0),
  ),
                      ),     
                      child:
                      BackdropFilter(
            filter: ImageFilter.blur(sigmaX:2.0, sigmaY:2.0),
            child:
                      
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 80.0),
                          Column(
                            
                            children: <Widget>[
                             Container(
                            //  color:Colors.white.withOpacity(0.7),
                              child:
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40.0,
                                    child:
                                        FluxImage(imageUrl: themeConfig.logo),
                                  ),
                                ],
                              ),
                             )
                            ],
                          ),
                          const SizedBox(height: 120.0),
                         Container(
                          decoration:  BoxDecoration(
                                               border:Border.all(
                              color: Color(0xff52260f),
            ),
                            // color:Color(0xffeac85f).withOpacity(0.3),    // Provider.of<AppModel>(context, listen: false).darkTheme ? Color(0xffffdf90).withOpacity(0.5) :Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(8))),
                         

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if( context.isRtl )
                             Expanded(
                                child: 
                                TextField(
                                  textAlign: context.isRtl ? TextAlign.end :  TextAlign.start,
                                  decoration: InputDecoration(
                                      labelText: S.of(context).phone),
                                  keyboardType: TextInputType.phone,
                                  controller: _controller,
                                ),
                                  ),
                                  if( context.isRtl )
                              const SizedBox(width: 8.0),
                              if( context.isRtl )
                                 CountryCodePicker(
                                  enabled:false,
                                     countryFilter: <String>['SA'], // only specific countries

                                onChanged: (country) {
                                  setState(() {
                                    countryCode = country;
                                  });
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: countryCode!.code,

                                //Get the country information relevant to the initial selection
                                onInit: (code) {
                                  countryCode = code;
                                },
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                dialogBackgroundColor:
                                    Theme.of(context).dialogBackgroundColor,
                              ),
                              if( !context.isRtl )
                             CountryCodePicker(
                                  enabled:false,
                                     countryFilter: <String>['SA'], // only specific countries

                                onChanged: (country) {
                                  setState(() {
                                    countryCode = country;
                                  });
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: countryCode!.code,

                                //Get the country information relevant to the initial selection
                                onInit: (code) {
                                  countryCode = code;
                                },
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                dialogBackgroundColor:
                                    Theme.of(context).dialogBackgroundColor,
                              ),
                              if(! context.isRtl )
                                    const SizedBox(width: 8.0),
                                    if( !context.isRtl )
                               Expanded(
                                child: 
                                TextField(
                                  textAlign: context.isRtl ? TextAlign.end :  TextAlign.start,
                                  decoration: InputDecoration(
                                      labelText: S.of(context).phone),
                                  keyboardType: TextInputType.phone,
                                  controller: _controller,
                                ),
                                  ),
                           
                            ],
                          ),
                         ),
                          const SizedBox(height: 60),
                          StaggerAnimation(
                            titleButton: S.of(context).sendSMSCode,
                            buttonController: _loginButtonController.view
                                as AnimationController,
                            onTap: () {
                              if (!isLoading) {
                                loginSMS(context);
                              }
                            },
                          ),
                        ],
                      )
                      ),
                    ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
