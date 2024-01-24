class MySingleton {
  static final MySingleton _instance = MySingleton._internal();

  factory MySingleton() {
    return _instance;
  }

  MySingleton._internal();

  bool isForLoopCalled = false;
  bool isDataFound = false;
  bool isCalled = false;

  setBooleanVal(bool value) {
    isForLoopCalled = value;
  }

  setBoolVal(bool value) {
    isDataFound = value;
  }

  setVal(bool value) {
    isCalled = value;
  }
}
