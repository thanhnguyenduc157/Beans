import 'package:beans/generated/r.dart';
import 'package:beans/model/relational_category.dart';
import 'package:beans/model/relational_subcategory.dart';
import 'package:beans/model/relational_subcategory_detail.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/custom/expansion_tile.dart';
import 'package:beans/widget/relation/relation_detail/relation_detail.dart';
import 'package:beans/widget/relation/relation_detail/relation_detail_other.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RelationTab extends StatelessWidget {
  final RelationalCategory category;

  const RelationTab({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            createTopTitle(context),
            createListViewCategory(category),
          ],
        ),
      ),
    );
  }
}

Widget createListViewCategory(RelationalCategory category) {
  List<Entry> data = [];

  var subcategories = category.subcategories;
  subcategories.forEach((subcat) {
    List<Entry> details = [];

    subcat.details.forEach((detail) {
      var detailEntry = Entry(detail.description, "");
      detailEntry.catID = subcat.relationalCategoryId;
      detailEntry.catTitle = category.name;
      detailEntry.detail = detail;
      detailEntry.description = subcat.description;
      detailEntry.subcateTitle = subcat.name;
      details.add(detailEntry);
    });

    data.add(Entry(subcat.name, subcat.description, details));
  });
  var entryOther= Entry("Khác", R.ic_more, [], true);

  entryOther.catID = -1;
  entryOther.catTitle = category.name;
  entryOther.subcateTitle = "Khác";

  data.add(entryOther);

  return ListView.builder(
    itemBuilder: (BuildContext context, int index) =>
        EntryItem(data[index], index, data.length),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: data.length,
  );
}

Widget createTopTitle(BuildContext context) {
  final userName = Provider.of<AuthProvider>(context, listen: false).name;

  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
    child: RichText(
      text: TextSpan(
        style: Styles.bodyGrey,
        children: [
          TextSpan(
              text:
                  '$userName hãy chọn 1 điều làm mình trăn trở hay hạnh phúc nhất hôm nay để ghi nhận lại. '),
          WidgetSpan(
            child: Image(
              image: AssetImage(R.tooltip),
              height: 28,
              width: 28,
            ),
          ),
        ],
      ),
    ),
  );
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(
    this.title,
    this.description, [
    this.children = const <Entry>[],
    this.isOther = false,
  ]);

   String title;
   String description;
   List<Entry> children;
   bool isOther;
  int catID;
  String catTitle;
  String subcateTitle;
  RelationalSubcategoryDetail detail;
}

// The entire multilevel list displayed by this app.

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.position, this.size);

  final Entry entry;
  final int position;
  final int size;

  Widget createChildItem(Entry root, int position, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RelationDetail(
              categoryId: root.catID,
              categoryTitle: root.catTitle,
              detail: root.detail,
              subcateTitle: root.subcateTitle,
            ),
          ),
        );
      },
      child: ListTile(
          title: Text(position.toString() + ". " + root.title,
              style: Styles.bodyGrey)),
    );
  }

  Widget createParentNoChild(Entry root, int position, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RelationDetailOther(    categoryId: root.catID,
            categoryTitle: root.catTitle,
            subcateTitle: root.subcateTitle,)),
        );
      },
      child: ListTile(
          title: Text(root.title, style: Styles.headingGrey)),
    );
  }

  Widget _buildTiles(Entry root, int position, BuildContext context) {
    if (root.isOther) {
      return createParentNoChild(root, position, context);
    }
    if (root.children.isNotEmpty) {
      return createParenItem(root, position, context);
    } else {
      return createChildItem(root, position, context);
    }
  }

  Widget createParenItem(Entry root, int position, BuildContext context) {
    return CustomExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: Styles.headingGrey,
      ),
      children: mapIndexed(root.children,
          (index, item) => _buildTiles(item, index + 1, context)).toList(),
      headerBackgroundColor: Colors.white,
      iconColor: Color(0xff88674d),
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
    return _buildTiles(entry, position, context);
  }
}
