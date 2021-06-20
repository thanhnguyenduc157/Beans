import 'dart:ui';
import 'package:beans/model/relational_category.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/provider/challenge_provider.dart';
import 'package:beans/provider/relation_list_provider.dart';
import 'package:beans/utils/cacher.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/about/about_beans.dart';
import 'package:beans/widget/challenge/challenge_view.dart';
import 'package:beans/widget/relation/relation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthProvider>(context, listen: false).name;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: createAppbar(userName, context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              new Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    titleTop(userName),
                    godWordText(),
                    Provider(
                      create: (context) => RelationListProvider(),
                      child: getListRelation(),
                    ),
                  ],
                ),
              ),
              new Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new Container(
                          height: 30,
                          width: 60,
                          decoration: new BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(50),
                              topRight: const Radius.circular(50),
                            ),
                          ),
                          child: new IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up),
                            iconSize: 35.0,
                            color: const Color(0xFFffffff),
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 350,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          color: Colors.orangeAccent,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 3,
                                        ),
                                        new Container(
                                          padding: const EdgeInsets.all(0.0),
                                          height: 30,
                                          width: 60,
                                          decoration: new BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius:
                                                  new BorderRadius.only(
                                                bottomRight:
                                                    const Radius.circular(50),
                                                bottomLeft:
                                                    const Radius.circular(50),
                                              )),
                                          child: new IconButton(
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            iconSize: 35.0,
                                            color: const Color(0XFFffffff),
                                            padding: const EdgeInsets.all(0.0),
                                            alignment: Alignment.center,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ),
                                        ChangeNotifierProvider(
                                          create: (context) =>
                                              ChallengeProvider(),
                                          child: ChallengeView(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    new Container(
                      color: Colors.orangeAccent,
                      width: MediaQuery.of(context).size.width,
                      height: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 350,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    color: Colors.orangeAccent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 3,
                                  ),
                                  new Container(
                                    padding: const EdgeInsets.all(0.0),
                                    height: 30,
                                    width: 60,
                                    decoration: new BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: new BorderRadius.only(
                                          bottomRight:
                                              const Radius.circular(50),
                                          bottomLeft: const Radius.circular(50),
                                        )),
                                    child: new IconButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 35.0,
                                      color: const Color(0XFFffffff),
                                      padding: const EdgeInsets.all(0.0),
                                      alignment: Alignment.center,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  ChangeNotifierProvider(
                                    create: (context) => ChallengeProvider(),
                                    child: ChallengeView(),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: new Image.asset(
                        'assets/challengeviewbottom.png',
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // TODO: Not implemnet yet
      // endDrawer: SlidingMenu(),
    );
  }

  Widget titleChallenge() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Styles.headingPurple,
          children: [TextSpan(text: 'Thử thách 24 giờ  ')],
        ),
      );

  Widget godWordText() {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 30),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '“Bình an cho anh em”(Lc 24, 36)',
              style: Styles.headingPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget getListRelation() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: Consumer<RelationListProvider>(
        builder: (context, value, child) => FutureBuilder(
          future: value.fetchCategories(),
          initialData: List<RelationalCategory>(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final List<RelationalCategory> categories = snapshot.data;
            Cacher.categories = snapshot.data;
            return GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: categories
                  .asMap()
                  .map((i, cat) =>
                      MapEntry(i, getItemRelation(context, categories, i)))
                  .values
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget getItemRelation(
    BuildContext context,
    List<RelationalCategory> categories,
    int currentCategoryIndex,
  ) {
    final category = categories[currentCategoryIndex];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RelationList(categories: categories)),
        );
      },
      // The custom button
      child: Column(
        children: [
          Image(
            width: 85,
            height: 85,
            image: AssetImage(category.icon),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(category.name, style: Styles.textStyleRelation))
        ],
      ),
    );
  }

  GradientAppBar createAppbar(String name, BuildContext context) {
    return GradientAppBar(
      brightness: Brightness.light,
      elevation: 1,
      centerTitle: false,
      titleSpacing: 0.0,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutBeans(),
              ),
            );
          },
          child: Icon(Icons.more_vert, color: Color(0xff88674d), size: 36.0),
        )
      ],
      title: Container(
        margin: EdgeInsets.only(left: 16),
        child: Text(
          'Hộp Đậu của $name',
          style: Styles.headingPurple,
        ),
      ),
      gradient: GradientApp.gradientAppbar,
      automaticallyImplyLeading: false,
    );
  }

  Column titleTop(String userName) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 27, bottom: 30),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'XÉT MÌNH\n',
                  style: Styles.extraHeadingPurple,
                ),
                TextSpan(
                  text: "NGÀY ${Utils.getCurrentDate()}",
                  style: Styles.dateStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
