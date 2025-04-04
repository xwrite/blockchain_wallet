
import 'dart:typed_data';

import 'package:hex/hex.dart';

extension StringExtension on String{

  String toUriString({Map<String, dynamic /*String?|Iterable<String>*/>? queryParameters}){
    return Uri(path: this, queryParameters: queryParameters).toString();
  }

}