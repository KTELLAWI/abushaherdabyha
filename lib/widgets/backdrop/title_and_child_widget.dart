import 'package:flutter/material.dart';

class TitleAndChildWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const TitleAndChildWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child:Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),
        
        SizedBox(height: 8),
        child,
      ],
    );
  }
}
