import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/index.dart'
    show AppModel;
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Blog;
import '../../services/index.dart';
import '../../widgets/html/index.dart';
import '../common/app_bar_mixin.dart';

class PostScreen extends StatefulWidget {
  final int? pageId;
  final String? pageTitle;
  final bool isLocatedInTabbar;

  const PostScreen({
    this.pageId,
    this.pageTitle,
    this.isLocatedInTabbar = false,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with AppBarMixin {
  final Services _service = Services();
  Future<Blog?>? _getPage;
  final _memoizer = AsyncMemoizer<Blog?>();

  @override
  void initState() {
    // only create the future once
    Future.delayed(Duration.zero, () {
      setState(() {
        _getPage = getPageById(widget.pageId);
      });
    });
    super.initState();
  }

  Future<Blog?> getPageById(context) => _memoizer.runOnce(
        () => _service.api.getPageById(
          widget.pageId,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
              children:[
                  if(Provider.of<AppModel>(context, listen: false).darkTheme ==false)    
                        Image.network(
            "https://abushaherdabayh.site/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),BackdropFilter(
            filter: ImageFilter.blur(sigmaX:2.0, sigmaY: 2.0),
            child:  renderScaffold(
      routeName: RouteList.postScreen,
      backgroundColor:Provider.of<AppModel>(context, listen: false).darkTheme? Theme.of(context).backgroundColor:Colors.transparent,
      body: Column(
        children: [
          AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text(
              widget.pageTitle.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            leading: widget.isLocatedInTabbar
                ? const SizedBox()
                : Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
          ),
          SizedBox(height:50),
          Expanded(
            child:
            FutureBuilder<Blog?>(
              future: _getPage,
              builder: (BuildContext context, AsyncSnapshot<Blog?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Scaffold(
                      body: Container(
                        color: Theme.of(context).backgroundColor,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError || snapshot.data!.id == null) {
                      return Material(
                        child: Container(
                          color: Theme.of(context).backgroundColor,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                S.of(context).noPost,
                              ),
                              widget.isLocatedInTabbar
                                  ? const SizedBox()
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(S.of(context).goBackHomePage),
                                    ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 0.0,
                      ),
                      child: PostView(
                        item: snapshot.data,
                      ),
                    );
                }
              },
            ),
            //),
          ),
        ],
      ),
    ),
          ),

              ],
    );
    // renderScaffold(
    //   routeName: RouteList.postScreen,
    //   backgroundColor: Theme.of(context).backgroundColor,
    //   body: Column(
    //     children: [
    //       AppBar(
    //         systemOverlayStyle: SystemUiOverlayStyle.light,
    //         title: Text(
    //           widget.pageTitle.toString(),
    //           style: Theme.of(context)
    //               .textTheme
    //               .headline6
    //               ?.copyWith(fontWeight: FontWeight.w700),
    //         ),
    //         backgroundColor: Theme.of(context).backgroundColor,
    //         leading: widget.isLocatedInTabbar
    //             ? const SizedBox()
    //             : Center(
    //                 child: GestureDetector(
    //                   onTap: () => Navigator.pop(context),
    //                   child: Icon(
    //                     Icons.arrow_back_ios,
    //                     color: Theme.of(context).colorScheme.secondary,
    //                   ),
    //                 ),
    //               ),
    //       ),
    //       Expanded(
    //         child: FutureBuilder<Blog?>(
    //           future: _getPage,
    //           builder: (BuildContext context, AsyncSnapshot<Blog?> snapshot) {
    //             switch (snapshot.connectionState) {
    //               case ConnectionState.none:
    //               case ConnectionState.active:
    //               case ConnectionState.waiting:
    //                 return Scaffold(
    //                   body: Container(
    //                     color: Theme.of(context).backgroundColor,
    //                     child: const Center(
    //                       child: CircularProgressIndicator(),
    //                     ),
    //                   ),
    //                 );
    //               case ConnectionState.done:
    //               default:
    //                 if (snapshot.hasError || snapshot.data!.id == null) {
    //                   return Material(
    //                     child: Container(
    //                       color: Theme.of(context).backgroundColor,
    //                       alignment: Alignment.center,
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: <Widget>[
    //                           Text(
    //                             S.of(context).noPost,
    //                           ),
    //                           widget.isLocatedInTabbar
    //                               ? const SizedBox()
    //                               : TextButton(
    //                                   style: TextButton.styleFrom(
    //                                     primary: Theme.of(context)
    //                                         .colorScheme
    //                                         .secondary,
    //                                   ),
    //                                   onPressed: () {
    //                                     Navigator.of(context).pop();
    //                                   },
    //                                   child: Text(S.of(context).goBackHomePage),
    //                                 ),
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 }

    //                 return Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 15.0,
    //                     vertical: 0.0,
    //                   ),
    //                   child: PostView(
    //                     item: snapshot.data,
    //                   ),
    //                 );
    //             }
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  }
}

class PostView extends StatelessWidget {
  final Blog? item;

  const PostView({this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: HtmlWidget(
        item!.content,
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              height: 1.4,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
