import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../models/entities/index.dart';
import '../../../routes/flux_navigate.dart';

class CategoryColumnItem extends StatelessWidget {
  final Category category;

  const CategoryColumnItem(this.category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FluxNavigate.pushNamed(
        RouteList.backdrop,
        arguments: BackDropArguments(
          cateId: category.id,
          cateName: category.name,
        ),
      ),
      child: 
    // Stack(
      //  children: <Widget>[
          Container(
            child:
           
             Image.network(
category.image!,
                                 // width: MediaQuery.of(context).size.width,
                                 // height: 200,
                                ),
             
            height:00,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: NetworkImage(category.image!), fit: BoxFit.fill),
            // ),
          ),
          // Container(
          //   //color: Colors.red,//..const Color.fromRGBO(0, 0, 0, 0.4),
          //   child: Center(
          //     child: Text(
          //       category.name!,
          //       style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // )
        //],
    //  ),
    );
  }
}
