import 'package:beans/generated/r.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/custom/expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AboutBeans extends StatelessWidget {
  const AboutBeans({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthProvider>(context, listen: false).name;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(
            elevation: 0,
            brightness: Brightness.light,
            gradient: GradientApp.gradientAppbar,
            leading: IconButton(
              icon: Utils.getIconBack(),
              color: Color(0xff88674d),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: false,
            titleSpacing: 0.0,
            title: Text("Chào ${userName}!", style: Styles.headingBoldPurple)),
        body: createListViewAbout(context),
      ),
    );
  }
}

Widget createListViewAbout(BuildContext context) {
  List<About> data = [];
  List<AboutDes> listDes = [];
  listDes.add(new AboutDes("Giới thiệu về Beans"));
  data.add(About("Giới thiệu về Beans", listDes, true, R.ic_down_arrow));
  data.add(About(
      "Chia sẻ Beans với người thân", new List<AboutDes>(), false, R.ic_share));
  data.add(About(
      "Liên hệ Beans/ Cần hỗ trợ", new List<AboutDes>(), false, R.ic_contact));
  data.add(
      About("Cài đặt & Bảo mật", new List<AboutDes>(), false, R.ic_settings));
  data.add(About("Tặng cho Beans 1 ly trà sữa", new List<AboutDes>(), false,
      R.ic_milkshake));

  return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AboutItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
      ));
}

class About {
  About(this.title, this.aboutDes, this.isExpand, this.icon);

  String title;
  List<AboutDes> aboutDes = [];
  bool isExpand;
  String icon;
}

class AboutDes {
  AboutDes(this.description);

  String description;
}

class AboutItem extends StatelessWidget {
  const AboutItem(this.about, this.position, this.size);

  final About about;
  final int position;
  final int size;

  Widget createParentNoChild(About root, int position, BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: ListTile(
          trailing: SvgPicture.asset(root.icon, color: Color(0xff88674d)),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${root.title}',
                  style: Styles.headingGrey,
                  textAlign: TextAlign.start,
                ),
              ]),
        ));
  }

  Widget _buildTiles(About root, int position, BuildContext context) {
    if (root.isExpand) {
      return createParenItem(root, position, context);
    } else {
      return createParentNoChild(root, position, context);
    }
  }

  Widget createParenItem(About root, int position, BuildContext context) {
    return CustomExpansionTile(
      key: PageStorageKey<About>(root),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${root.title}',
              style: Styles.headingGrey,
              textAlign: TextAlign.start,
            ),
          ]),
      children: mapIndexed(root.aboutDes,
          (index, item) => createChildItem(item, index + 1, context)).toList(),
      headerBackgroundColor: Colors.white,
      trailing: SvgPicture.asset(root.icon, color: Color(0xff88674d)),
    );
  }

  Widget createChildItem(AboutDes root, int position, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ListTile(title: Text(root.description, style: Styles.titlePurple)),
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(about, position, context);
  }
}
