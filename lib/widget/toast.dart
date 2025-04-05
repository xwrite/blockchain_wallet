
import 'package:fluttertoast/fluttertoast.dart';

class Toast{

  const Toast._();

  static Future<void> show(String msg) async{
    await Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  static Future<void> cancel() async{
    await Fluttertoast.cancel();
  }
}