
extension MapExtension on Map{

  String? getString(String key){
    final value = this[key];
    if(value == null){
      return null;
    }
    if(value is String){
      return value;
    }
    return value.toString();
  }

  int? getInt(String key){
    final value = this[key];
    if(value == null){
      return null;
    }
    if(value is int){
      return value;
    }
    return int.tryParse(value.toString());
  }

  double? getDouble(String key){
    final value = this[key];
    if(value == null){
      return null;
    }
    if(value is double){
      return value;
    }
    return double.tryParse(value.toString());
  }

}