import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Inprogress extends StatefulWidget {
  Inprogress({Key key}) : super(key: key);

  @override
  _InprogressState createState() => _InprogressState();
}

class _InprogressState extends State<Inprogress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50, bottom: 100),
          child: Text(
            'Đang xây dựng',
            style: Styles.superPurple2,
          ),
        ),
        SvgPicture.asset(R.ic_inprogress),
        Padding(
          padding: EdgeInsets.only(top: 22),
          child: Text(
            'Tính năng này sẽ được\ncập nhật ở Beta 2',
            style: Styles.titleGrey,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
