import 'package:collection/collection.dart' show IterableExtension;
import 'package:country_pickers/country.dart' as picker_country;
import 'package:country_pickers/country_pickers.dart' as picker;
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../../models/entities/order_delivery_date.dart';
import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Address, CartModel, Country, UserModel;
import '../../../services/index.dart';
import '../../../widgets/common/common_safe_area.dart';
import '../../../widgets/common/flux_image.dart';
import '../../../widgets/common/place_picker.dart';
import '../choose_address_screen.dart';
import 'date_time_picker.dart';
import 'package:quiver/strings.dart';
import '../../../common/tools.dart';
import 'package:intl/intl.dart';
import 'payment_methods.dart';
import 'package:location/location.dart';
import 'date_time_picker_timeline.dart';
import 'date_time_scroller.dart';





class ShippingAddress extends StatefulWidget {
  final Function? onNext;
  //  final Function? onBack;
  // final Function? onFinish;
  // final Function(bool)? onLoading;


  const ShippingAddress({this.onNext});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
   final TextEditingController _buildingController = TextEditingController();
  //fina/l GlobalKey<_ShippingAddressState> _myWidgetShipping = GlobalKey<_ShippingAddressState>();
   String value = 'الفترة المسائية';
  String? datePicker;
 late OrderDeliveryDate  orderDeliveryDate;
 bool? thereis = false;
  bool googlePlace = false;

  final _lastNameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _emailNode = FocusNode();
  final _cityNode = FocusNode();
  final _streetNode = FocusNode();
  final _blockNode = FocusNode();
  final _zipNode = FocusNode();
  final _stateNode = FocusNode();
  final _countryNode = FocusNode();
  final _apartmentNode = FocusNode();
  final _buildingNode = FocusNode();

  Address? address;
  List<Country>? countries = [];
  List<dynamic> states = [];
  PermissionStatus? _permissionGranted;
//Location location = new Location();


  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _blockController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _apartmentController.dispose();
    _buildingController.dispose();

    _lastNameNode.dispose();
    _phoneNode.dispose();
    _emailNode.dispose();
    _cityNode.dispose();
    _streetNode.dispose();
    _blockNode.dispose();
    _zipNode.dispose();
    _stateNode.dispose();
    _countryNode.dispose();
    _apartmentNode.dispose();
    _buildingNode.dispose();

    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        final addressValue =
            await Provider.of<CartModel>(context, listen: false).getAddress();
        // ignore: unnecessary_null_comparison
        if (addressValue != null) {
          setState(() {
        // value =" ";
            address = addressValue;
           _cityController.text = address?.city ?? '';
            _streetController.text = address?.street ?? '';
            _zipController.text = address?.zipCode ?? '';
            _stateController.text = address?.state ?? '';
            _blockController.text = address?.block ?? '';
            _apartmentController.text = address?.apartment ?? '';
            _buildingController.text = address?.building ?? '';
          });
        } else {
          var user = Provider.of<UserModel>(context, listen: false).user;
          setState(() {
            address = Address(country: kPaymentConfig.defaultCountryISOCode);
            if (kPaymentConfig.defaultStateISOCode != null) {
              address!.state = kPaymentConfig.defaultStateISOCode;
            }
            _countryController.text = address!.country!;
            _stateController.text = address!.state!;
            if (user != null) {
              address!.firstName = user.firstName;
              address!.lastName = user.lastName;
              address!.email = user.email;
              
            }
          });
        }
        countries = await Services().widget.loadCountries();
        var country = countries!.firstWhereOrNull((element) =>
            element.id == address!.country || element.code == address!.country);
        if (country == null) {
          if (countries!.isNotEmpty) {
            country = countries![0];
            address!.country = countries![0].code;
          } else {
            country = Country.fromConfig(address!.country, null, null, []);
          }
        } else {
          address!.country = country.code;
          address!.countryId = country.id;
        }
        _countryController.text = country.code!;
        if (mounted) {
          setState(() {});
        }
        states = await Services().widget.loadStates(country);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future<void> updateState(Address? address) async {
    setState(() {
      _cityController.text = address?.city ?? '';
      _streetController.text = address?.street ?? '';
      _zipController.text = address?.zipCode ?? '';
      _stateController.text = address?.state ?? '';
      _countryController.text = address?.country ?? '';
      this.address?.country = address?.country ?? '';
      _apartmentController.text = address?.apartment ?? '';
      _buildingController.text = address?.building ?? '';
      _blockController.text = address?.block ?? '';
    });
  }

  bool checkToSave() {
    final storage = LocalStorage(LocalStorageKey.address);
    var listAddress = <Address>[];
    try {
      var data = storage.getItem('data');
      if (data != null) {
        for (var item in (data as List)) {
          final add = Address.fromLocalJson(item);
          listAddress.add(add);
        }
      }
      for (var local in listAddress) {
        if (local.city != _cityController.text) continue;
        if (local.street != _streetController.text) continue;
        if (local.zipCode != _zipController.text) continue;
        if (local.state != _stateController.text) continue;
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).yourAddressExistYourLocal),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            );
          },
        );
        return false;
      }
    } catch (err) {
      printLog(err);
    }
    return true;
  }

  Future<void> saveDataToLocal() async {
    final storage = LocalStorage(LocalStorageKey.address);
    var listAddress = <Address?>[];
    listAddress.add(address);
    try {
      final ready = await storage.ready;
      if (ready) {
        var data = storage.getItem('data');
        if (data != null) {
          var listData = data as List;
          for (var item in listData) {
            final add = Address.fromLocalJson(item);
            listAddress.add(add);
          }
        }
        await storage.setItem(
            'data',
            listAddress.map((item) {
              return item!.toJsonEncodable();
            }).toList());
        await showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).youHaveBeenSaveAddressYourLocal),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            );
          },
        );
      }
    } catch (err) {
      printLog(err);
    }
  }

  String? validateEmail(String email) {
    if (email.isEmail) {
      return null;
    }
    return 'The E-mail Address must be a valid email address.';
  }

  @override
  Widget build(BuildContext context) {
    Location location = new Location();
     var deliveryOptions=[];
    //value ="dddvvv";
    final options = ['الفترة الصباحية','الفترة المسائية'];
      final options2 = ['Evening Period','Morning Period'];
      if (context.isRtl){
        deliveryOptions = options;
      } else{
                deliveryOptions = options2;

      }

    // = '';
 final cartModel = Provider.of<CartModel>(context, listen: false);
//print(value);
  final now = DateTime.now();
        final later = now.add( Duration(days: 0,));

      
      //////////////////
      Widget delivertDateScroller = DatePicker(
        later,
        locale: context.isRtl ? "ar_DZ": "en_US",
  onDateChange: (DateTime datetime) {
         orderDeliveryDate = OrderDeliveryDate(datetime) ;
        orderDeliveryDate!.dateString = DateFormat.yMd('en_US').format(datetime)  ;
        orderDeliveryDate!.deliveryDate = context.isRtl ? DateFormat.yMMMMEEEEd('ar_DZ').format(datetime)+ "  " + value :  DateFormat.yMMMMEEEEd('en_US').format(datetime)+ "  " + value ;
        cartModel.selectedDate = orderDeliveryDate;
        print(orderDeliveryDate!.dateString);
        setState((){
 datePicker = DateFormat.yMd('en_US').format(datetime) ;
 thereis = true;
        });
       
       // fullDate = DateFormat.yMd('en_US').format(datetime) + value!;
        print(orderDeliveryDate.dateString);
      },
        );
      
        //// date_picker_timeline

       Widget deliveryWidget2 = TimeLine(
        title:'hahhahah'
       );


      // String fullDate ='';
      Widget deliveryWidget = DateTimePicker(
       onChanged: (DateTime datetime) {
         orderDeliveryDate = OrderDeliveryDate(datetime) ;
        orderDeliveryDate!.dateString = DateFormat.yMd('en_US').format(datetime)  ;
        orderDeliveryDate!.deliveryDate =  DateFormat.yMMMMEEEEd('ar_DZ').format(datetime)+ "  " + value ;
        cartModel.selectedDate = orderDeliveryDate;
        print(orderDeliveryDate!.dateString);
        setState((){
 datePicker = DateFormat.yMd('en_US').format(datetime) ;
        });
       
       // fullDate = DateFormat.yMd('en_US').format(datetime) + value!;
        print(orderDeliveryDate.dateString);
      },
      minimumDate: DateTime.now(),
     initDate: cartModel.selectedDate?.dateTime,
      maximumDate: later,
     //dateFull:DateFormat.yMd('en_US').format(datetime) + value!,
      
      //maximumYear: "2022"

     // border: const OutlineInputBorder(),
    );
// Widget deliveryWidget = DateTimePicker(
       
//       onChanged: (DateTime datetime) {
//         final orderDeliveryDate = OrderDeliveryDate(datetime);
//         orderDeliveryDate.dateString =
//               DateFormat.yMMMMEEEEd().format(datetime);
//         cartModel.selectedDate = orderDeliveryDate;
//         print(orderDeliveryDate.dateString);
//       },
//       minimumDate: DateTime.now(),
//      initDate: cartModel.selectedDate?.dateTime,
//       maximumDate: later,
//       //maximumYear: "2022"

//      // border: const OutlineInputBorder(),
//     );



    var countryName = S.of(context).country;
    if (_countryController.text.isNotEmpty) {
      try {
        countryName = picker.CountryPickerUtils.getCountryByIsoCode(
                _countryController.text)
            .name;
      } catch (e) {
        countryName = S.of(context).country;
      }
    }

    if (address == null) {
      return SizedBox(height: 100, child: kLoadingWidget(context));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
             Form(
              key: _formKey,
              child: AutofillGroup(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        autocorrect: false,
                        initialValue: "",//address!.firstName,
                        autofillHints: const [AutofillHints.givenName],
                        decoration:
                            InputDecoration(
                              labelText: S.of(context).firstName,
                              labelStyle: const TextStyle(fontSize: 13),
                              ),
                              
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return val!.isEmpty
                              ? S.of(context).firstNameIsRequired
                              : null;
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_lastNameNode),
                        onSaved: (String? value) {
                          address!.firstName = value;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        initialValue: address!.lastName,
                        autofillHints: const [AutofillHints.familyName],
                        focusNode: _lastNameNode,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return val!.isEmpty
                              ? S.of(context).lastNameIsRequired
                              : null;
                        },
                        decoration:
                            InputDecoration(labelText: S.of(context).lastName,
                            labelStyle: const TextStyle(fontSize: 13),),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_phoneNode),
                        onSaved: (String? value) {
                          address!.lastName = value;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        initialValue:  "",//address!.firstName,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        focusNode: _phoneNode,
                        decoration: InputDecoration(
                          labelText: S.of(context).phoneNumber,
                          labelStyle: const TextStyle(fontSize: 13),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return val!.isEmpty
                              ? S.of(context).phoneIsRequired
                              : null;
                        },
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_emailNode),
                        onSaved: (String? value) {
                          address!.phoneNumber = value;
                        },
                      ),
                      // TextFormField(
                      //   autocorrect: false,
                      //   initialValue: address!.email,
                      //   autofillHints: const [AutofillHints.email],
                      //   focusNode: _emailNode,
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: InputDecoration(
                      //     labelText: S.of(context).email,
                      //   ),
                      //   textInputAction: TextInputAction.done,
                      //   validator: (val) {
                      //     if (val!.isEmpty) {
                      //       return S.of(context).emailIsRequired;
                      //     }
                      //     return validateEmail(val);
                      //   },
                      //   onSaved: (String? value) {
                      //     address!.email = value;
                      //   },
                      // ),
                      //  PlacePicker(
                      //                     kIsWeb
                      //                         ? kGoogleApiKey.web
                      //                         : isIos
                      //                             ? kGoogleApiKey.ios
                      //                             : kGoogleApiKey.android,
                      //                   ),
                      const SizedBox(height: 20.0),
                      if (kPaymentConfig.allowSearchingAddress &&
                          kGoogleApiKey.isNotEmpty)
                      //   Row(
                      //     children: [
                           
                      //       Expanded(
                      //         child:
                       ButtonTheme(
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    onPrimary: Colors.white,
                                        //Theme.of(context).primaryColorLight,
                                    primary:Theme.of(context).primaryColor,//Colors.red,//Colors.white.withOpacity(0.7),
                                        //Theme.of(context).primaryColorLight,
                                  ),
                                  onPressed: () async {
                                   // _permissionGranted = await location.hasPermission();
                                    ////  if (_permissionGranted == PermissionStatus.denied) {
                                        _permissionGranted = await location.requestPermission();
                                      //  }
                                    //_permissionGranted = await location.requestPermission();
                                    final result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PlacePicker(
                                          kIsWeb
                                              ? kGoogleApiKey.web
                                              : isIos
                                                  ? kGoogleApiKey.ios
                                                  : kGoogleApiKey.android,
                                        ),
                                      ),
                                    );

                                    if (result is LocationResult) {
                                      googlePlace = true;
                                      address!.country = result.country;
                                      address!.street = result.street;
                                      address!.state = result.state;
                                      address!.city = result.city;
                                      address!.zipCode = result.zip;
                                      if (result.latLng?.latitude != null &&
                                          result.latLng?.latitude != null) {
                                        address!.mapUrl =
                                            'https://maps.google.com/maps?q=${result.latLng?.latitude},${result.latLng?.longitude}&output=embed';
                                        address!.latitude =
                                            result.latLng?.latitude.toString();
                                        address!.longitude =
                                            result.latLng?.longitude.toString();
                                      }

                                      setState(() {
                                        _cityController.text =
                                            address!.city ?? '';
                                        _stateController.text =
                                            address!.state ?? '';
                                        _streetController.text =
                                            address!.street ?? '';
                                        _zipController.text =
                                            address!.zipCode ?? '';
                                        _countryController.text =
                                            address!.country ?? '';
                                      });
                                      final c = Country(
                                          id: result.country,
                                          name: result.country);
                                      states =
                                          await Services().widget.loadStates(c);
                                      setState(() {});
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        CupertinoIcons.arrow_up_right_diamond,
                                        size: 18,
                                        color:Colors.green,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(S
                                          .of(context)
                                          .searchingAddress
                                          .toUpperCase(),style:TextStyle(fontSize:10)),
                                    ],
                                  ),
                                ),
                              ),
                           // ),
                            SizedBox(height:8),
                      //       Expanded(
                      //         child:
                      // ButtonTheme(
                      //   height: 60,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       elevation: 0.0,
                      //       onPrimary: Colors.white,
                      //       primary:Theme.of(context).primaryColor,//Colors.white.withOpacity(0.7), //Theme.of(context).primaryColorLight,
                      //     ),
                      //     onPressed: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               ChooseAddressScreen(updateState),
                      //         ),
                      //       );
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         const Icon(
                      //           CupertinoIcons.person_crop_square,
                      //           size: 16,
                      //           color:Colors.green,
                      //         ),
                      //         const SizedBox(width: 10.0),
                      //         Text(
                      //           S.of(context).selectAddress.toUpperCase(),
                      //           style:TextStyle(fontSize:10)
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //  ),
                      //       )
                      //     ],
                      //   ),
                      const SizedBox(height: 10),
                      // ButtonTheme(
                      //   height: 60,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       elevation: 0.0,
                      //       onPrimary: Theme.of(context).colorScheme.secondary,
                      //       primary: Theme.of(context).primaryColorLight,
                      //     ),
                      //     onPressed: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               ChooseAddressScreen(updateState),
                      //         ),
                      //       );
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         const Icon(
                      //           CupertinoIcons.person_crop_square,
                      //           size: 16,
                      //         ),
                      //         const SizedBox(width: 10.0),
                      //         Text(
                      //           S.of(context).selectAddress.toUpperCase(),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      // Text(
                      //   S.of(context).country,
                      //   style: const TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w300,
                      //       color: Colors.grey),
                     // ),
                     // (countries!.length == 1)
                          // ? Text(
                          //     picker.CountryPickerUtils.getCountryByIsoCode(
                          //             countries![0].code!)
                          //         .name,
                          //     style: const TextStyle(fontSize: 18),
                          //   )
                          // : GestureDetector(
                          //     onTap: _openCountryPickerDialog,
                          //     child: Column(
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 20),
                          //           child: Row(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: <Widget>[
                          //               Expanded(
                          //                 child: Text(countryName,
                          //                     style: const TextStyle(
                          //                         fontSize: 17.0)),
                          //               ),
                          //               const Icon(Icons.arrow_drop_down)
                          //             ],
                          //           ),
                          //         ),
                          //         const Divider(
                          //           height: 1,
                          //           color: kGrey900,
                          //         )
                          //       ],
                          //     ),
                          //   ),
                     // renderStateInput(),
                      TextFormField(
                        autocorrect: false,
                        controller: _cityController,
                        autofillHints: const [AutofillHints.addressCity],
                        focusNode: _cityNode,
                        validator: (val) {
                          return val!.isEmpty
                              ? S.of(context).cityIsRequired
                              : null;
                        },
                        decoration:
                            InputDecoration(labelText: S.of(context).city,
                            labelStyle: const TextStyle(fontSize: 13),),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_apartmentNode),
                        onSaved: (String? value) {
                          address!.city = value;
                        },
                      ),
                         TextFormField(
                        autocorrect: false,
                        controller: _blockController,
                        focusNode: _blockNode,
                        validator: (val) {
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: S.of(context).streetNameBlock,
                            labelStyle: const TextStyle(fontSize: 13),),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_streetNode),
                        onSaved: (String? value) {
                          address!.block = value;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _streetController,
                        autofillHints: const [AutofillHints.fullStreetAddress],
                        focusNode: _streetNode,
                        validator: (val) {
                          return val!.isEmpty
                              ? S.of(context).streetIsRequired
                              : null;
                        },
                        decoration: InputDecoration(
                            labelText: S.of(context).streetName,
                            labelStyle: const TextStyle(fontSize: 13),),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_zipNode),
                        onSaved: (String? value) {
                          address!.street = value;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _buildingController,
                        focusNode: _buildingNode,
                        validator: (val) {
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: S.of(context).streetNameBuilding,
                            labelStyle: const TextStyle(fontSize: 13),),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_blockNode),
                        onSaved: (String? value) {
                          address!.apartment = value;
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _apartmentController,
                        focusNode: _apartmentNode,
                        validator: (val) {
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: S.of(context).streetNameApartment,
                            labelStyle: const TextStyle(fontSize: 13),),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_blockNode),
                        onSaved: (String? value) {
                          address!.apartment = value;
                        },
                      ),
                   
                   
                      
                      // TextFormField(
                      //   autocorrect: false,
                      //   controller: _zipController,
                      //   autofillHints: const [AutofillHints.postalCode],
                      //   focusNode: _zipNode,
                      //   validator: (val) {
                      //     return val!.isEmpty
                      //         ? S.of(context).zipCodeIsRequired
                      //         : null;
                      //   },
                      //   keyboardType: kPaymentConfig.enableAlphanumericZipCode
                      //       ? TextInputType.text
                      //       : TextInputType.number,
                      //   textInputAction: TextInputAction.done,
                      //   decoration:
                      //       InputDecoration(labelText: S.of(context).zipCode),
                      //   onSaved: (String? value) {
                      //     address!.zipCode = value;
                      //   },
                      // ),
                      const SizedBox(height: 20),
          //              SizedBox(
          //   width: 150,
          //   child: OutlinedButton.icon(
          //     style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
          //     onPressed: () {
          //       if (!checkToSave()) return;
          //       if (_formKey.currentState!.validate()) {
          //         _formKey.currentState!.save();
          //         Provider.of<CartModel>(context, listen: false)
          //             .setAddress(address);
          //         saveDataToLocal();
          //       }
          //     },
          //     icon: const Icon(
          //       CupertinoIcons.plus_app,
          //       size: 20,
          //     ),
          //     label: Text(
          //       S.of(context).saveAddress.toUpperCase(),
          //       style: Theme.of(context).textTheme.caption!.copyWith(
          //             color: Theme.of(context).colorScheme.secondary,
          //             fontSize:13,
          //           ),
          //     ),
          //   ),
          // ),
                      const SizedBox(height:50),
                              Text(S.of(context).deliveryZaman,style: const TextStyle(fontSize: 13)),
        SizedBox(height:20),
                                  
                            Wrap(
          spacing: 0.0,
          runSpacing: 12.0,
          children: <Widget>[
           //  context.isRtl ?
            for (var item in deliveryOptions)
              GestureDetector(
                onTap: () =>{
                    value = item,
                    //orderDeliveryDate!.dateString! = 'orderDeliveryDate!.dateString! + value!', 
                
                  setState((){

print(value);
                  }),
                },
                behavior: HitTestBehavior.opaque,
                child: 
                // Tooltip(
                //   message: item,
                //   verticalOffset: 32,
                //   preferBelow: false,
                //   child: 
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    margin: const EdgeInsets.only(
                      right: 12.0,
                      top: 8.0,
                    ),
                    
                    decoration:    BoxDecoration(
                            color:  item != value
                                      ? Colors.transparent
                                     // Theme.of(context).colorScheme.secondary 
                                      : const Color(0xff52260f),//Colors.white,
                              
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Color(0xff52260f),
                              // Theme.of(context)
                              //     .colorScheme
                              //     .secondary
                              //     .withOpacity(0.3),
                            ),
                          ),
                    child:
                        Container(
                            constraints: const BoxConstraints(minWidth: 40),
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                       item == value
                                      ? Colors.white
                                      : Colors.black,//Theme.of(context).colorScheme.secondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                  ),
                //),
              ),
              
          ],
        ),
                      const SizedBox(height:15),
                      
                      Container(
                        child:delivertDateScroller,//DatePicker(now)
                       // deliveryWidget2 ,
                      ) ,
                         const SizedBox(height: 50),
                         
//                             Wrap(
//           spacing: 0.0,
//           runSpacing: 12.0,
//           children: <Widget>[
//             for (var item in options)
//               GestureDetector(
//                 onTap: () =>{
//                     value = item,
//                     //orderDeliveryDate!.dateString! = 'orderDeliveryDate!.dateString! + value!', 
                
//                   setState((){

// print(value);
//                   }),
//                 },
//                 behavior: HitTestBehavior.opaque,
//                 child: 
//                 // Tooltip(
//                 //   message: item,
//                 //   verticalOffset: 32,
//                 //   preferBelow: false,
//                 //   child: 
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeIn,
//                     margin: const EdgeInsets.only(
//                       right: 12.0,
//                       top: 8.0,
//                     ),
                    
//                     decoration:    BoxDecoration(
//                             color:  item != value
//                                       ? Colors.transparent
//                                      // Theme.of(context).colorScheme.secondary 
//                                       : const Color(0xff52260f),//Colors.white,
                              
//                             borderRadius: BorderRadius.circular(5.0),
//                             border: Border.all(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .secondary
//                                   .withOpacity(0.3),
//                             ),
//                           ),
//                     child:
//                         Container(
//                             constraints: const BoxConstraints(minWidth: 40),
//                             padding:
//                                 const EdgeInsets.only(left: 10.0, right: 10.0),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 10, bottom: 10),
//                               child: Text(
//                                 item,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color:
//                                        item == value
//                                       ? Colors.black
//                                       : Colors.grey,//Theme.of(context).colorScheme.secondary,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 //),
//               )
//           ],
//         ),
//                          SizedBox(height:20),
              //            Expanded(
              //             child: PaymentMethods(
              // onBack: widget.onBack,
              // onFinish: widget.onFinish,
              // onLoading: widget.onLoading,
              // ),
              //            )
                        
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildBottom(),
      ],
    );
  }

  Widget _buildBottom() {
    return CommonSafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   width: 150,
          //   child: OutlinedButton.icon(
          //     style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
          //     onPressed: () {
          //       if (!checkToSave()) return;
          //       if (_formKey.currentState!.validate()) {
          //         _formKey.currentState!.save();
          //         Provider.of<CartModel>(context, listen: false)
          //             .setAddress(address);
          //         saveDataToLocal();
          //       }
          //     },
          //     icon: const Icon(
          //       CupertinoIcons.plus_app,
          //       size: 20,
          //     ),
          //     label: Text(
          //       S.of(context).saveAddress.toUpperCase(),
          //       style: Theme.of(context).textTheme.caption!.copyWith(
          //             color: Theme.of(context).colorScheme.secondary,
          //           ),
          //     ),
          //   ),
          // ),
          // Container(width: 8),
          Expanded(
            child: SizedBox(
              width:double.infinity,
              child:
          
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.0),
              )),
                elevation: 0.0,
                onPrimary: Colors.white,
                primary: Theme.of(context).primaryColor,
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(
                Icons.payment,
                size: 18,
              ),
              onPressed: _onNext,
              label: Text(
                (kPaymentConfig.enableShipping
                        ? S.of(context).continueToShipping
                        : kPaymentConfig.enableReview
                            ? S.of(context).continueToReview
                            : S.of(context).continueToPayment)
                    .toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  /// Load Shipping beforehand
  void _loadShipping({bool beforehand = true}) {
    Services().widget.loadShippingMethods(
        context, Provider.of<CartModel>(context, listen: false), beforehand);
  }

  /// on tap to Next Button
  void _onNext() {
    {  
      if (_formKey.currentState!.validate() && value != null && Provider.of<CartModel>(context, listen: false).selectedDate !=null && thereis! ) {
        if (!googlePlace){
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(" Insert Address by Google maps\n يرجى تحديد الموقع من خلال الخريطة",style:TextStyle(fontSize:13)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(color: Theme.of(context).primaryColor,fontSize:13),
                  ),
                )
              ],
            );
          },
        );
    } else{
       _formKey.currentState!.save();
        Provider.of<CartModel>(context, listen: false).setAddress(address);
        _loadShipping(beforehand: false);
        widget.onNext!();
    }
       
      }
      else {
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).insertDeliveryTime,style:TextStyle(fontSize:13)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    style: TextStyle(color: Theme.of(context).primaryColor,fontSize:13),
                  ),
                )
              ],
            );
          },
        );
      }

    }
  }

  Widget renderStateInput() {
    if (states.isNotEmpty) {
      var items = <DropdownMenuItem>[];
      for (var item in states) {
        items.add(
          DropdownMenuItem(
            value: item.id,
            child: Text(item.name),
          ),
        );
      }
      String? value;

      Object? firstState = states.firstWhereOrNull(
          (o) => o.id.toString() == address!.state.toString());

      if (firstState != null) {
        value = address!.state;
      }
      return DropdownButton(
        items: items,
        value: value,
        onChanged: (dynamic val) {
          setState(() {
            address!.state = val;
          });
        },
        isExpanded: true,
        itemHeight: 70,
        hint: Text(S.of(context).stateProvince),
      );
    } else {
      return TextFormField(
        autocorrect: false,
        controller: _stateController,
        autofillHints: const [AutofillHints.addressState],
        validator: (val) {
          return val!.isEmpty ? S.of(context).streetIsRequired : null;
        },
        decoration: InputDecoration(labelText: S.of(context).stateProvince),
        onSaved: (String? value) {
          address!.state = value;
        },
      );
    }
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        useRootNavigator: false,
        builder: (contextBuilder) => countries!.isEmpty
            ? Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                child: SizedBox(
                  height: 500,
                  child: picker.CountryPickerDialog(
                       // countryFilter: <String>['CD', 'CG', 'KE', 'UG'], // only specific countries

                    titlePadding: const EdgeInsets.all(8.0),
                    contentPadding: const EdgeInsets.all(2.0),
                    searchCursorColor: Colors.pinkAccent,
                    searchInputDecoration:
                        const InputDecoration(hintText: 'Search...'),
                    isSearchable: true,
                    title: Text(S.of(context).country),
                    onValuePicked: (picker_country.Country country) async {
                      _countryController.text = country.isoCode;
                      address!.country = country.isoCode;
                      if (mounted) {
                        setState(() {});
                      }
                      final c =
                          Country(id: country.isoCode, name: country.name);
                      states = await Services().widget.loadStates(c);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    itemBuilder: (country) {
                      return Row(
                        children: <Widget>[
                          picker.CountryPickerUtils.getDefaultFlagImage(
                              country),
                          const SizedBox(width: 8.0),
                          Expanded(child: Text(country.name)),
                        ],
                      );
                    },
                  ),
                ),
              )
            : Dialog(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      countries!.length,
                      (index) {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              _countryController.text = countries![index].code!;
                              address!.country = countries![index].id;
                              address!.countryId = countries![index].id;
                            });
                            Navigator.pop(contextBuilder);
                            states = await Services()
                                .widget
                                .loadStates(countries![index]);
                            setState(() {});
                          },
                          child: ListTile(
                            leading: countries![index].icon != null
                                ? SizedBox(
                                    height: 40,
                                    width: 60,
                                    child: FluxImage(
                                      imageUrl: countries![index].icon!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : (countries![index].code != null
                                    ? Image.asset(
                                        picker.CountryPickerUtils
                                            .getFlagImageAssetPath(
                                                countries![index].code!),
                                        height: 40,
                                        width: 60,
                                        fit: BoxFit.fill,
                                        package: 'country_pickers',
                                      )
                                    : const SizedBox(
                                        height: 40,
                                        width: 60,
                                        child: Icon(Icons.streetview),
                                      )),
                            title: Text(countries![index].name!),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
      );
}
