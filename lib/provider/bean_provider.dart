import 'package:beans/dao/target_dao.dart';
import 'package:beans/model/target.dart';
import 'package:flutter/material.dart';

class BeanProvider with ChangeNotifier {
  Target get target => _target;
  Target _target;

  final _targetDao = TargetDao();

  int get greenTagetCount => target?.greenCount ?? 0;

  int get blackTargetCount => target?.blackCount ?? 0;

  BeanProvider() {
    getTarget();
  }

  getTarget() async {
    _target = await _targetDao.getOrCreate();
    target.greenCount = _target.greenCount;
    target.blackCount = _target.blackCount;
    notifyListeners();
  }
}
