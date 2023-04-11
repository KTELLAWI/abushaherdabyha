// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the 'License');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'filters/container_filter.dart';
import 'package:provider/provider.dart';
import '../../models/index.dart'
    show AppModel;
import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/service_config.dart';
import 'backdrop_constants.dart';

const Cubic _kAccelerateCurve = Cubic(0.548, 0.0, 0.757, 0.464);
const Cubic _kDecelerateCurve = Cubic(0.23, 0.94, 0.41, 1.0);
const double _kPeakVelocityTime = 0.248210;
const double _kPeakVelocityProgress = 0.379146;

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({Key? key, this.onTap, this.child, this.visible})
      : super(key: key);

  final VoidCallback? onTap;
  final Widget? child;
  final bool? visible;

  @override
  Widget build(BuildContext context) {
    var radius = visible! ? 12.0 : 16.0;

    return Material(
      elevation: 16.0,
      color: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: visible! ? 10.0 : 40.0,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(
            child: child!,
          ),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final Function? onPress;
  final Widget frontTitle;
  final Widget backTitle;
  final bool? visible;
  final Color? titleColor;

  const _BackdropTitle({
    Key? key,
    required Listenable listenable,
    this.onPress,
    this.visible,
    this.titleColor,
    required this.frontTitle,
    required this.backTitle,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: listenable as Animation<double>,
      curve: const Interval(0.0, 0.78),
    );

    return DefaultTextStyle(
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: titleColor ?? Colors.white),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1.0),
            ).value,
            child: FractionalTranslation(
              translation: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0.5, 0.0),
              ).evaluate(animation),
              child: backTitle,
            ),
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0),
            ).value,
            child: FractionalTranslation(
              translation: Tween<Offset>(
                begin: const Offset(-0.25, 0.0),
                end: Offset.zero,
              ).evaluate(animation),
              child: frontTitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Builds a Backdrop.
///
/// A Backdrop widget has two layers, front and back. The front layer is shown
/// by default, and slides down to show the back layer, from which a user
/// can make a selection. The user can also configure the titles for when the
/// front or back layer is showing.
class Backdrop extends StatefulWidget {
  final Widget frontLayer;
  final Widget backLayer;
  final Widget? backLayer2;
  final Widget frontTitle;
  final Widget backTitle;
  final Widget? appbarCategory;
  final AnimationController controller;
  final bool showFilter;
  final bool isBlog;
  final VoidCallback? onTapShareButton;
  final bool hasAppBar;
  final String selectSort;
   final Function? onSort;
  

  /// This color is pick from the Horizontal Config on Home Screen
  /// use to override the Backdrop color
  final Color? bgColor;

  const Backdrop({
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    required this.controller,
    this.backLayer2,
    this.appbarCategory,
    this.showFilter = true,
    this.isBlog = false,
    this.bgColor,
    this.onTapShareButton,
    this.hasAppBar = false,
    this.selectSort = 'date',
    this.onSort,

  });

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  late AnimationController _controller;
  late Animation<RelativeRect> _layerAnimation;
  bool viewStyle = false;
String _selectSort = 'date';
  /// background color
  bool get useBackgroundColor =>
      productFilterColor?.useBackgroundColor ?? false;

  bool get userPrimaryColorLight =>
      productFilterColor?.usePrimaryColorLight ?? false;

  Color get systemBackgroundColor => useBackgroundColor
      ? Theme.of(context).colorScheme.background
      : (userPrimaryColorLight
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).primaryColor);

  Color get backgroundColor =>
      widget.bgColor ??
      ((productFilterColor?.backgroundColor != null
              ? HexColor(productFilterColor?.backgroundColor)
              : systemBackgroundColor))
          .withOpacity(
              productFilterColor?.backgroundColorOpacity.toDouble() ?? 1.0);

  /// label color
  Color get systemLabelColor => (productFilterColor?.useAccentColor ?? false)
      ? Theme.of(context).colorScheme.secondary
      : Colors.white;

  Color get labelColor {
    /// use the label color from bgColor
    if (widget.bgColor != null) {
      return widget.bgColor!.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    }

    return (productFilterColor?.labelColor != null
            ? HexColor(productFilterColor?.labelColor)
            : systemLabelColor)
        .withOpacity(productFilterColor?.labelColorOpacity.toDouble() ?? 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _selectSort = widget.selectSort;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    // Call setState here to update layerAnimation if that's necessary
    setState(() {
      _frontLayerVisible ? _controller.reverse() : _controller.forward();
    });
    // Future.delayed(Duration(milliseconds: _frontLayerVisible ? 0 : 75), () {
    //   setState(() {
    //     shouldShowCategory = _frontLayerVisible;
    //   });
    // });
  }

  // _layerAnimation animates the front layer between open and close.
  // _getLayerAnimation adjusts the values in the TweenSequence so the
  // curve and timing are correct in both directions.
  Animation<RelativeRect> _getLayerAnimation(Size layerSize, double layerTop) {
    Curve firstCurve; // Curve for first TweenSequenceItem
    Curve secondCurve; // Curve for second TweenSequenceItem
    double firstWeight; // Weight of first TweenSequenceItem
    double secondWeight; // Weight of second TweenSequenceItem
    Animation animation; // Animation on which TweenSequence runs

    if (_frontLayerVisible) {
      firstCurve = _kAccelerateCurve;
      secondCurve = _kDecelerateCurve;
      firstWeight = _kPeakVelocityTime;
      secondWeight = 1.0 - _kPeakVelocityTime;
      animation = CurvedAnimation(
        parent: _controller.view,
        curve: const Interval(0.0, 0.78),
      );
    } else {
      // These values are only used when the controller runs from t=1.0 to t=0.0
      firstCurve = _kDecelerateCurve.flipped;
      secondCurve = _kAccelerateCurve.flipped;
      firstWeight = 1.0 - _kPeakVelocityTime;
      secondWeight = _kPeakVelocityTime;
      animation = _controller.view;
    }

    return TweenSequence(
      <TweenSequenceItem<RelativeRect>>[
        TweenSequenceItem<RelativeRect>(
          tween: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
              0.0,
              layerTop,
              0.0,
              layerTop - layerSize.height,
            ),
            end: RelativeRect.fromLTRB(
              0.0,
              layerTop * _kPeakVelocityProgress,
              0.0,
              (layerTop - layerSize.height) * _kPeakVelocityProgress,
            ),
          ).chain(CurveTween(curve: firstCurve)),
          weight: firstWeight,
        ),
        TweenSequenceItem<RelativeRect>(
          tween: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
              0.0,
              layerTop * _kPeakVelocityProgress,
              0.0,
              (layerTop - layerSize.height) * _kPeakVelocityProgress,
            ),
            end: RelativeRect.fill,
          ).chain(CurveTween(curve: secondCurve)),
          weight: secondWeight,
        ),
      ],
    ).animate(animation as Animation<double>);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const layerTitleHeight = 20.0;
    final layerSize = constraints.biggest;
    final layerTop = layerSize.height - layerTitleHeight;
    _layerAnimation = _getLayerAnimation(layerSize, layerTop);

    return Stack(
      key: _backdropKey,
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color:Colors.white, //backgroundColor,
          child: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      secondary:Colors.black //labelColor,
                    ),
                textTheme: Theme.of(context).textTheme.copyWith(
                      titleMedium:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.black //labelColor,
                              ),
                      titleLarge:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.black //labelColor,
                              ),
                    )),
            child:viewStyle ? widget!.backLayer2! :widget.backLayer,
          ),
        ),
        PositionedTransition(
          rect: _layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            visible: _frontLayerVisible,
            child: widget.frontLayer,
          ),
        ),
// Container(
//   //color:Colors.blue,
//   child:SizedBox(
//   height:MediaQuery.of(context).size.width,
// //  color:Colors.black,
//   child:Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//     ...renderLayout()
//   ]
// )
// )
// )
      ],
      
    );
  }

    PopupMenuItem<String> _buildMenuItem(
      IconData icon, String label, String value,
      [bool isSelect = false]) {
    final menuItemStyle = TextStyle(
      fontSize: 13.0,
      color: isSelect
          ? Theme.of(context).primaryColor
          : Theme.of(context).colorScheme.secondary,
      height: 24.0 / 15.0,
    );
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(icon,
                color: isSelect
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                size: 17),
          ),
          Text(label, style: menuItemStyle),
        ],
      ),
    );
  }
  List<Widget> renderLayout() {
    return [
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "طريقة العرض",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      const SizedBox(height: 5.0),

      /// render layout
      Selector<AppModel, String>(
        selector: (context, AppModel _) => _.productListLayout,
        builder: (context, String selectLayout, _) {
          return Container(
          //  margin:EdgeInsets.only(top:-15),
            width:MediaQuery.of(context).size.width,
            color:Colors.red,
            child: Wrap(
            children: <Widget>[
              const SizedBox(width: 8),
              for (var item
                  in widget.isBlog ? kBlogListLayout : kProductListLayout)
                Tooltip(
                  message: item['layout']!,
                  child: GestureDetector(
                    onTap: () => Provider.of<AppModel>(context, listen: false)
                        .updateProductListLayout(item['layout']),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: ContainerFilter(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(
                          bottom: 15,
                          left: 8,
                          right: 8,
                          top: 15,
                        ),
                        isSelected: selectLayout == item['layout'],
                        child: Image.asset(
                          item['image']!,
                          color: selectLayout == item['layout']
                              ? (widget.isBlog &&
                                      !kAdvanceConfig.enableProductBackdrop
                                  ? Colors.white
                                  : Theme.of(context).primaryColor)
                              : Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          )
          );
         
        },
      ),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!Layout.isDisplayDesktop(context))
          AppBar(
            primary: !widget.hasAppBar,
            backgroundColor: backgroundColor,
            elevation: 0.0,
            titleSpacing: 0.0,
            title: _BackdropTitle(
                listenable: _controller.view,
                titleColor: labelColor,
                onPress: _toggleBackdropLayerVisibility,
                frontTitle: widget.frontTitle,
                backTitle: widget.backTitle,
                visible: _frontLayerVisible),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20, color: labelColor),
              onPressed: () {
                if (kIsWeb) {
                  eventBus.fire(const EventOpenCustomDrawer());
                  // LayoutWebCustom.changeStateMenu(true);
                }
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              /// Share product category by dynamic link
              if (firebaseDynamicLinkConfig['isEnabled'] &&
                  ServerConfig().isWooType &&
                  !ServerConfig().isListingType &&
                  !widget.isBlog)
                IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 18.0,
                    color: labelColor,
                  ),
                  onPressed: () => widget.onTapShareButton?.call(),
                ),
             
                if (widget.showFilter)
                  IconButton(
                  icon: Icon(
                    CupertinoIcons.sort_down,
                    size: 18.0,
                    color: labelColor,
                  ),
                  onPressed:() {
                       // renderLayout();

                      setState((){
                    viewStyle= true;
                  });
                    _toggleBackdropLayerVisibility();
                   }
                 
                ),
                /////

          //       if ((!ServerConfig().isListingType) ^ (ServerConfig().type == ConfigType.shopify) 
          //       //&&
          //   //widget.showSort
          //   )
          // PopupMenuButton<String>(
          //   icon: const Icon(CupertinoIcons.sort_down,
          //       color: Colors.white, size: 18),
          //   onSelected: (String item) {
          //     _selectSort = item;
          //     widget.onSort!(item);
          //   },
          //   itemBuilder: (BuildContext context) => (!ServerConfig().isWordPress)
          //       ? <PopupMenuItem<String>>[
          //           _buildMenuItem(CupertinoIcons.calendar, S.of(context).date,
          //               'date', _selectSort == 'date'),
          //           ...(ServerConfig().type != ConfigType.magento
          //               ? [
          //                   _buildMenuItem(
          //                       CupertinoIcons.star,
          //                       S.of(context).featured,
          //                       'featured',
          //                       _selectSort == 'featured'),
          //                   _buildMenuItem(
          //                       CupertinoIcons.money_dollar,
          //                       S.of(context).byPrice,
          //                       'price',
          //                       _selectSort == 'price')
          //                 ]
          //               : []),
          //           _buildMenuItem(CupertinoIcons.percent, S.of(context).onSale,
          //               'on_sale', _selectSort == 'on_sale'),
          //         ]
          //       : <PopupMenuItem<String>>[
          //           _buildMenuItem(
          //             CupertinoIcons.sort_down,
          //             S.of(context).dateASC,
          //             'asc',
          //           ),
          //           _buildMenuItem(
          //             CupertinoIcons.sort_up,
          //             "S.of(context).DateDESC",
          //             'desc',
          //           ),
          //         ],
          // ),

                ////////////
          
          // PopupMenuButton<String>(
          //   icon: const Icon(CupertinoIcons.sort_down,
          //       color: Colors.white, size: 18),
            // onSelected: (String item) {
            //   _selectSort = item;
            //   widget.onSort!(item);
            // },
            // itemBuilder: (BuildContext context) => 
                //?
                //  <PopupMenuItem<String>>[
                //     _buildMenuItem(CupertinoIcons.calendar, "S.of(context).date",
                //         'date',),
                    // ...(ServerConfig().type != ConfigType.magento
                    //     ? [
                    //         _buildMenuItem(
                    //             CupertinoIcons.star,
                    //             S.of(context).featured,
                    //             'featured',
                    //             _selectSort == 'featured'),
                    //         _buildMenuItem(
                    //             CupertinoIcons.money_dollar,
                    //             S.of(context).byPrice,
                    //             'price',
                    //             _selectSort == 'price')
                    //       ]
                    //     : []),
                  //   _buildMenuItem(CupertinoIcons.percent, "S.of(context).onSale",
                  //       'on_sale',),
                  // ]
          //        <PopupMenuItem<String>>[
          //           _buildMenuItem(
          //             CupertinoIcons.sort_down,
          //             "S.of(context).dateASC",
          //             'asc',
          //           ),
          //           _buildMenuItem(
          //             CupertinoIcons.sort_up,
          //            " S.of(context).DateDESC",
          //             'desc',
          //           ),
          //         ],
          //  ),
              if (widget.showFilter)
                IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.close_menu,
                      progress: _controller,
                    ),
                    color: labelColor,
                    onPressed: () {
                      setState((){
                    viewStyle= false;
                  });
                    _toggleBackdropLayerVisibility();
                  }
                    //_toggleBackdropLayerVisibility
                    ),
            ],
          ),
        if (!ServerConfig().isListingType && widget.appbarCategory != null)
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    secondary: labelColor,
                    background: backgroundColor,
                  ).copyWith(background: backgroundColor),
            ),
            child: widget.appbarCategory!,
          ),
        Expanded(
          child: Row(
            children: <Widget>[
              Layout.isDisplayDesktop(context)
                  ? Container(
                      width: BackdropConstants.drawerWidth,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(bottom: 32),
                      color: backgroundColor,
                      child: widget.backLayer,
                    )
                  : const SizedBox(),
              Expanded(
                child: LayoutBuilder(
                  builder: _buildStack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
