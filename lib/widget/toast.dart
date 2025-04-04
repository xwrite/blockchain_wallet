
import 'package:fluttertoast/fluttertoast.dart';

class Toast{

  const Toast._();

  static Future<void> show(String msg) async{
    await Fluttertoast.showToast(msg: msg);
  }

  static Future<void> cancel() async{
    await Fluttertoast.cancel();
  }
}