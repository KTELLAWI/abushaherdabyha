import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart' deferred as defer_icon;
import 'package:inspireui/inspireui.dart' show DeferredWidget;

import '../../../widgets/common/flux_image.dart';
import '../config/tab_bar_config.dart';
import '../config/tab_bar_floating_config.dart';
import '../config/tab_bar_indicator_config.dart';
import 'tab_indicator/diamond_border.dart';
import 'tabbar_icon.dart';

class IconFloatingAction extends StatelessWidget {
  final TabBarFloatingConfig config;
  final Function? onTap;
  final Map item;
  final int totalCart;
   final int notificationCount;
  const IconFloatingAction({
    Key? key,
    required this.onTap,
    required this.item,
    required this.config,
    required this.totalCart,
    required this.notificationCount,

  }) : super(key: key);

  ShapeBorder shapeBorder() {
    switch (config.floatingType) {
      case FloatingType.diamond:
        return const DiamondBorder();
      default:
        return
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 14.0),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Widget icon = Builder(
      builder: (context) {
        var iconColor = Colors.white;
        var isImage = item['icon'].contains('/');
        return isImage
            ? FluxImage(imageUrl: item['icon'], color: iconColor, width: 24)
            : DeferredWidget(
                defer_icon.loadLibrary,
                () => Icon(
                    defer_icon.iconPicker(
                      item['icon'],
                      item['fontFamily'],
                    ),
                    color: iconColor,
                    size: 22),
              );
      },
    );

    if (item['layout'] == 'cart') {
      icon = IconCart(
        icon: icon,
        totalCart: totalCart,
        config: TabBarConfig(
          tabBarFloating: config,
          tabBarIndicator: TabBarIndicatorConfig(),
        ),
      );
    }
       if (item['layout'] == 'notify') {
      icon = IconCartNotify(
        icon: icon,
       
        notificationCount:notificationCount,
        config: TabBarConfig(
          tabBarFloating: config,
          tabBarIndicator: TabBarIndicatorConfig(),
        ),
      );
    }

    return
     RawMaterialButton(
      elevation: config.elevation ?? 4.0,
      shape: shapeBorder(),
      fillColor: config.color ?? Theme.of(context).primaryColor,
      onPressed: () => onTap!(),
      constraints: BoxConstraints.tightFor(
        width: 0,
        height: 0,
      ),
      child: icon,
    );
  }
}
