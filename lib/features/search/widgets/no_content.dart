import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasassy/constants/assets.dart';

class NoContent extends StatelessWidget {
  const NoContent({Key? key, required this.displayText}) : super(key: key);

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SvgPicture.asset(
            SVG.search,
            height: 300,
          ),
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 60,
            ),
          ),
        ],
      ),
    );
  }
}
