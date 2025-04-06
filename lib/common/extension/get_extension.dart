import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension GetExtension on GetInterface {
  ///Get.arguments未map类型时，尝试获取指定key的值
  T? tryGetArgs<T>(String key) {
    if (Get.arguments is Map) {
      final value = arguments[key];
      if (value is T) {
        return value;
      }
    }
    return null;
  }

  ///Get.arguments未map类型时，获取指定key的值,如果没有则返回defaultValue
  T getArgs<T>(String key, T defaultValue) {
    if (arguments is Map) {
      final value = arguments[key];
      if (value is T) {
        return value;
      }
    }
    return defaultValue;
  }

  ///尝试查找对象，如果不存在则返回null
  T? tryFind<T>({String? tag}) {
    if (Get.isRegistered<T>(tag: tag)) {
      return Get.find<T>(tag: tag);
    }
    return null;
  }


  EdgeInsets get padding => mediaQuery.padding;
}
