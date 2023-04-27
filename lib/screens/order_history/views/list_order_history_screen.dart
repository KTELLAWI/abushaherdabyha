import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../widgets/common/paging_list.dart';
import '../../common/app_bar_mixin.dart';
import '../models/list_order_history_model.dart';
import '../models/order_history_detail_model.dart';
import 'widgets/order_list_item.dart';
import 'widgets/order_list_loading_item.dart';

class ListOrderHistoryScreen extends StatefulWidget {
  @override
  State<ListOrderHistoryScreen> createState() => _ListOrderHistoryScreenState();
}

class _ListOrderHistoryScreenState extends State<ListOrderHistoryScreen>
    with AppBarMixin {
  ListOrderHistoryModel get listOrderViewModel =>
      Provider.of<ListOrderHistoryModel>(context, listen: false);

  var mapOrderHistoryDetailModel = <int, OrderHistoryDetailModel>{};

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user ?? User();
     final style = Provider.of<AppModel>(context, listen: false).darkTheme?  TextStyle(fontSize: 17,color:Colors.white, ) :  TextStyle(fontSize: 17,color:Colors.black );

    return 
    Stack(
        children: <Widget>[
         if(!Provider.of<AppModel>(context, listen: false).darkTheme )    
                        Image.network(
            "https://abushaherdabayh.tk/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
     
    Scaffold(
      backgroundColor:Provider.of<AppModel>(context, listen: false).darkTheme ? Theme.of(context).backgroundColor :Colors.transparent,
      appBar: AppBar(
          shape: Border(
    bottom: BorderSide(
      color:const Color(0xff52260f),//Color(0xffff7a0a), //Colors.orange,const Color(0xff52260f)
      width: 1,
    ),
  ),
  elevation: 3,
        title: Text(S.of(context).orderHistory,
          //S.of(context).orderHistory,
          style: GoogleFonts.almarai(
                  textStyle: style
                ),
          // style: TextStyle(
          //   color: Theme.of(context).colorScheme.secondary,
          // ),
        ),
        centerTitle: true,
        backgroundColor: Provider.of<AppModel>(context, listen: false).darkTheme? Theme.of(context).backgroundColor : Colors.white, //Colors.white,// Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PagingList<ListOrderHistoryModel, Order>(
        onRefresh: mapOrderHistoryDetailModel.clear,
        itemBuilder: (_, order, index) {
          if (mapOrderHistoryDetailModel[index] == null) {
            final orderHistoryDetailModel = OrderHistoryDetailModel(
              order: order,
              user: user,
            );
            mapOrderHistoryDetailModel[index] = orderHistoryDetailModel;
          }
          return ChangeNotifierProvider<OrderHistoryDetailModel>.value(
            value: mapOrderHistoryDetailModel[index]!,
            child: OrderListItem(),
          );
        },
        lengthLoadingWidget: 3,
        loadingWidget:const OrderListLoadingItem(),
      ),
    ),
        ],
    );
    // renderScaffold(
    //   routeName: RouteList.orders,
    //   body: Scaffold(
    //     backgroundColor: Theme.of(context).backgroundColor,
    //     appBar: AppBar(
    //       title: Text(
    //         S.of(context).orderHistory,
    //         style: TextStyle(
    //           color: Theme.of(context).colorScheme.secondary,
    //         ),
    //       ),
    //       centerTitle: true,
    //       backgroundColor: Theme.of(context).backgroundColor,
    //       leading: IconButton(
    //         icon: Icon(
    //           Icons.arrow_back_ios_sharp,
    //           color: Theme.of(context).colorScheme.secondary,
    //         ),
    //         onPressed: () => Navigator.of(context).pop(),
    //       ),
    //     ),
    //     body: PagingList<ListOrderHistoryModel, Order>(
    //       onRefresh: mapOrderHistoryDetailModel.clear,
    //       itemBuilder: (_, order, index) {
    //         if (mapOrderHistoryDetailModel[index] == null) {
    //           final orderHistoryDetailModel = OrderHistoryDetailModel(
    //             order: order,
    //             user: user,
    //           );
    //           mapOrderHistoryDetailModel[index] = orderHistoryDetailModel;
    //         }
    //         return ChangeNotifierProvider<OrderHistoryDetailModel>.value(
    //           value: mapOrderHistoryDetailModel[index]!,
    //           child: OrderListItem(),
    //         );
    //       },
    //       lengthLoadingWidget: 3,
    //       loadingWidget: const OrderListLoadingItem(),
    //     ),
    //   ),
    // );
  }
}
