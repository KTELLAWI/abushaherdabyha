import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

class RiveSplashScreen extends StatefulWidget {
  final Function onSuccess;
  final String imageUrl;
  final Color? color;
  final String animationName;
  final int duration;
  const RiveSplashScreen({
    Key? key,
    required this.onSuccess,
    required this.imageUrl,
    required this.animationName,
    this.color,
    this.duration = 1000,
  }) : super(key: key);
  @override
  State<RiveSplashScreen> createState() => _RiveSplashScreenState();
}

class _RiveSplashScreenState extends State<RiveSplashScreen> {
  Artboard? _riveArtboard;
  RiveAnimationController? _controller;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var data;
      if (widget.imageUrl.startsWith('http')) {
        var readBytes = await http.readBytes(Uri.parse(widget.imageUrl));
        data = ByteData.sublistView(readBytes);
      } else {
        data = await rootBundle.load(widget.imageUrl);
      }
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard
          .addController(_controller = SimpleAnimation(widget.animationName));
      setState(() {
        _riveArtboard = artboard;
      });
      _controller?.isActiveChanged.addListener(() {
        if (!(_controller?.isActive ?? true)) {
          Future.delayed(Duration(milliseconds: widget.duration))
              .then((value) => widget.onSuccess());
        }
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                               "https://abushaherdabayh.site/wp-content/uploads/2022/10/80a181e2-1e50-491e-8872-e1b8d4cd7d4d.jpg"))
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      //color: Color(0xff52260f),//Colors.black,
      child: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard!),
      ),
    );
  }
}
