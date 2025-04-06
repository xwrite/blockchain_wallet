
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

///自动取消stream订阅，自动dispose controller
mixin GetAutoDisposeMixin on DisposableInterface {
  final _subscriptions = <StreamSubscription>{};
  final _changeNotifiers = <ChangeNotifier>{};
  final _workers = <Worker>{};

  ///自动取消stream订阅
  StreamSubscription<T> autoCancel<T>(StreamSubscription<T> subscription) {
    _subscriptions.add(subscription);
    return subscription;
  }

  ///自动dispose
  void autoDispose(ChangeNotifier controller) {
    _changeNotifiers.add(controller);
  }

  ///自动dispose
  void autoDisposeWorker(Worker worker) {
    _workers.add(worker);
  }

  @override
  void onClose() {
    final iterator = _subscriptions.iterator;
    while (iterator.moveNext()) {
      iterator.current.cancel();
    }
    _subscriptions.clear();

    final changeNotifiersIterator = _changeNotifiers.iterator;
    while (changeNotifiersIterator.moveNext()) {
      changeNotifiersIterator.current.dispose();
    }
    _changeNotifiers.clear();

    final workersIterator = _workers.iterator;
    while (workersIterator.moveNext()) {
      workersIterator.current.dispose();
    }
    _workers.clear();
    super.onClose();
  }
}