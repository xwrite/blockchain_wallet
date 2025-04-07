
///函数式方法
extension FunctionMethod<T> on T{

  R let<R>(R Function(T it) action) => action(this);

  T also(void Function(T it) action){
    action(this);
    return this;
  }

}