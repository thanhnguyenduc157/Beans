import 'package:flutter/material.dart';

class RelationDetailProvider with ChangeNotifier {

  int _gratefulCount = 0;
  String get grateFulCount {
    if (_gratefulCount == 0) {
      return '';
    }
    return '+$_gratefulCount';
  }

  int _ungratefulCount = 0;
  String get ungrateFulCount {
    if (_ungratefulCount == 0) {
      return '';
    }
    return '+$_ungratefulCount';
  }

  submitRelation() {

  }
}