import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../common/enums/load_state.dart';
import 'widgets/category_column_item1.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/category/category_model.dart';
import '../../../models/index.dart' show BackDropArguments, Category,BrandLayoutModel,AppModel;
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/index.dart';
import '../../../widgets/common/parallax_image.dart';
import '../../../widgets/common/refresh_scroll_physics.dart';
import '../index.dart';
import '../../../modules/dynamic_layout/config/brand_config.dart';
const _kCrossAxisCount = 3;

const _kDefaultGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: _kCrossAxisCount,
  mainAxisSpacing: 4.0,
  crossAxisSpacing: 4.0,
  childAspectRatio: 0.75,
);

class BrandCategories extends StatefulWidget {
//   static const String type = 'card';
//   final bool enableParallax;
//   final double? parallaxImageRatio;
//   final ScrollController? scrollController;

  const BrandCategories(
//     {
//     required this.enableParallax,
//     this.parallaxImageRatio,
//     this.scrollController,
//   }
  );

  @override
  BaseScreen<BrandCategories> createState() => _StateBrandCategories();
}

class _StateBrandCategories extends BaseScreen<BrandCategories> {
  late final ScrollController scrollController =  ScrollController();
     @override
  void initState() {
     // @override
  //late final ScrollController scrollController = widget.scrollController ?? ScrollController();

    Future.delayed(Duration.zero, () {
      final model = Provider.of<BrandLayoutModel>(context, listen: false);
      final langCode = Provider.of<AppModel>(context, listen: false).langCode;
      model.getBrands(langCode);
       printLog(langCode);
    });
   
    super.initState();
  }

  // late   String langCode = Provider.of<AppModel>(context, listen: true).langCode;

   final config = 
 BrandConfig( 
"brand",
	true,
	true,
	
	);
 
  // late final ScrollController _scrollController =
  //     widget.scrollController ?? ScrollController();

//   CategoryModel get categoryModel =>
//       Provider.of<CategoryModel>(context, listen: false);

//   bool hasChildren(id) {
//     return categoryModel.categories!
//         .where((o) => o.parent == id)
//         .toList()
//         .isNotEmpty;
//   }

//   List<Category> getSubCategories(id) {
//     return categoryModel.getCategory(parentId: id) ?? <Category>[];
//   }

//   void navigateToBackDrop(Category category) {
//     FluxNavigate.pushNamed(
//       RouteList.backdrop,
//       arguments: BackDropArguments(
//         cateId: category.id,
//         cateName: category.name,
//       ),
//     );
//   }

//   ChildList getChildCategoryList(category) {
//     return ChildList(
//       children: [
//         GestureDetector(
//           onTap: () => navigateToBackDrop(category),
//           child: SubItem(
//             category,
//             seeAll: S.of(context).seeAll,
//           ),
//         ),
//         for (var category in getSubCategories(category.id))
//           Parent(
//             callback: (isSelected) {
//               if (getSubCategories(category.id).isEmpty) {
//                 navigateToBackDrop(category);
//               }
//             },
//             parent: SubItem(category),
//             childList: ChildList(
//               children: [
//                 for (var cate in getSubCategories(category.id))
//                   Parent(
//                     callback: (isSelected) {
//                       if (getSubCategories(cate.id).isEmpty) {
//                         FluxNavigate.pushNamed(
//                           RouteList.backdrop,
//                           arguments: BackDropArguments(
//                             cateId: cate.id,
//                             cateName: cate.name,
//                           ),
//                         );
//                       }
//                     },
//                     parent: SubItem(cate, level: 1),
//                     childList: ChildList(
//                       children: [
//                         for (var cate in getSubCategories(cate.id))
//                           Parent(
//                             callback: (isSelected) {
//                               FluxNavigate.pushNamed(
//                                 RouteList.backdrop,
//                                 arguments: BackDropArguments(
//                                   cateId: cate.id,
//                                   cateName: cate.name,
//                                 ),
//                               );
//                             },
//                             parent: SubItem(cate, level: 2),
//                             childList: const ChildList(children: []),
//                           ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

  @override
Widget build(BuildContext context) {
    return Consumer<BrandLayoutModel>(
      builder: (_, model, __) {
  
      if (model.state == FSLoadState.loading) {
          return Text("ddd");
      }
      return 
      Scaffold(
                  backgroundColor:Colors.white,

        appBar: AppBar(
          backgroundColor:Colors.white,
    title:  Text(
              "العلامات التجارية",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
    actions: [
      // IconButton(
      //   icon: Icon(Icons.search),
      //   onPressed: () {
      //     // Perform search action
      //   },
      // ),
      // IconButton(
      //   icon: Icon(Icons.more_vert),
      //   onPressed: () {
      //     // Perform more actions
      //   },
      // ),
    ],
  ),
        body:
        CustomScrollView(
              controller: scrollController,
              physics: const RefreshScrollPhysics(),
              slivers: [
                // CupertinoSliverRefreshControl(
                //   onRefresh: () async {
                //    // await model.refresh();
                //   },
                // ),
        // :Container(
        //   child:
          SliverGrid(
                        gridDelegate: _kDefaultGridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                           // final category = data[index];
                            final  brand = model.brands[index];
                            return GestureDetector(
                              onTap: () {
                                FluxNavigate.pushNamed(
                                RouteList.backdrop,
                                arguments: BackDropArguments(
                                  config: config?.toJson(),
                                  brandId: brand.id,
                                  brandName: brand.name,
                                  brandImg: brand.image,
                                  // data: snapshot.data,
                                ),
                              );
                                // FluxNavigate.pushNamed(
                                //   RouteList.backdrop,
                                //   arguments: BackDropArguments(
                                //     cateId: category.id,
                                //     cateName: category.name,
                                //   ),
                                // );
                              },
                              child: CategoryColumnItem1(brand),
                            );
                          },
                         childCount:model.brands.length 
                          // model.brands.length 
                          // +
                          //     (model.brands.length  % _kCrossAxisCount == 0
                          //         ? _kCrossAxisCount
                          //         : _kCrossAxisCount -
                          //             (model.brands.length  % _kCrossAxisCount)),
                        ),
                      ),





          //        ListView.builder(
          // //controller: _scrollController,
          // padding: const EdgeInsets.symmetric(vertical: 8),
          // physics: const RefreshScrollPhysics(),
          // scrollDirection: Axis.vertical,
          // itemCount: model.brands!.length,//categories.length,
          // itemBuilder: (_, index) {
          // var  brand= model.brands[index];
      
          //   return 
         
          //     _CategoryCardItem(
          //       brand,
          //       onTap: () => FluxNavigate.pushNamed(
          //                       RouteList.backdrop,
          //                       arguments: BackDropArguments(
          //                         config: config?.toJson(),
          //                         brandId: brand.id,
          //                         brandName: brand.name,
          //                         brandImg: brand.image,
          //                         // data: snapshot.data,
          //                       ),
          //                     ),
          //     );
          // }
          //  ),
              ]  
        )
      
      );
     

      
      },
    );
  }
}

class _CategoryCardItem extends StatelessWidget {
  final  category;
  final bool enableParallax;
  final double? parallaxImageRatio;
  final VoidCallback? onTap;

  const _CategoryCardItem(
    this.category, {
    this.enableParallax = false,
    this.parallaxImageRatio,
    this.onTap,
  });

  /// Render category Image support caching on ios/android
  /// also fix loading on Web
  Widget renderCategoryImage(maxWidth) {
    final image = category.image ?? '';
    if (image.isEmpty) return const SizedBox();

    var imageProxy = '$kImageProxy${maxWidth}x,q30/';

    if (image.contains('http') && kIsWeb) {
      return FadeInImage.memoryNetwork(
        image: '$imageProxy$image',
        fit: BoxFit.contain,
        width: maxWidth,
        height: maxWidth * 0.35,
        placeholder: kTransparentImage,
      );
    }

    return FluxImage(
      imageUrl: category.image!,
      fit: BoxFit.fill,
      width: maxWidth,
      height: maxWidth * 0.35,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

//  if(category!.id=="16"){
//     return SizedBox();
//   }
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (enableParallax) {
            return Container(
              height: constraints.maxWidth * 0.35,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ParallaxImage(
                  image: category.image ?? '',
                  name: category.name ?? '',
                  ratio: 2.2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }

          return Container(
            height: constraints.maxWidth * 0.35,
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(bottom: 10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    child: renderCategoryImage(constraints.maxWidth)),
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth * 0.35,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                   // color: const Color.fromRGBO(0, 0, 0, 0.3),
                    borderRadius: BorderRadius.circular(20.0),
                     border: Border.all(
      color:Theme.of(context).primaryColor,//Colors.green,
      width: 1,
    )
                  ),
                  child: SizedBox(
                  //   width: constraints.maxWidth /
                  //       (2 / (screenSize.height / constraints.maxWidth)),
                  //   height: constraints.maxWidth * 0.35,
                  //   child: Center(
                  //     child: Text(
                  //       //textAlign:TextAlign.center,
                  //       category.name?.toUpperCase() ?? '',
                  //       style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 22,
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //   ),
                   ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth * 0.35,
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: const Skeleton(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}

// class SubItem extends StatelessWidget {
//   final Category category;
//   final String seeAll;
//   final int level;

//   const SubItem(this.category, {this.seeAll = '', this.level = 0});

//   void showProductList() {
//     FluxNavigate.pushNamed(
//       RouteList.backdrop,
//       arguments: BackDropArguments(
//         cateId: category.id,
//         cateName: category.name,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return SizedBox(
//       width: screenSize.width,
//       child: FittedBox(
//         fit: BoxFit.cover,
//         child: Container(
//           width:
//               screenSize.width / (2 / (screenSize.height / screenSize.width)),
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 width: 0.5,
//                 color: Theme.of(context)
//                     .colorScheme
//                     .secondary
//                     .withOpacity(level == 0 && seeAll == '' ? 0.2 : 0),
//               ),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 5),
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: <Widget>[
//               const SizedBox(width: 15.0),
//               for (int i = 1; i <= level; i++)
//                 Container(
//                   width: 10.0,
//                   margin: const EdgeInsets.only(right: 8),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         width: 1.5,
//                         color: Theme.of(context).primaryColor.withOpacity(0.4),
//                       ),
//                     ),
//                   ),
//                 ),
//               Expanded(
//                 child: Text(
//                   seeAll != '' ? seeAll : category.name!,
//                   style: const TextStyle(
//                     fontSize: 17,
//                   ),
//                 ),
//               ),
//               if ((category.totalProduct ?? 0) > 0)
//                 GestureDetector(
//                   onTap: showProductList,
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                     child: Text(
//                       S.of(context).nItems(category.totalProduct.toString()),
//                       style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                             color: Theme.of(context).primaryColor,
//                           ),
//                     ),
//                   ),
//                 ),
//               IconButton(
//                 icon: const Icon(Icons.keyboard_arrow_right),
//                 onPressed: showProductList,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
