enum SharedStorageKey {
  doneOnBoarding,
  activated,
  pro
}

extension ParseToName on SharedStorageKey {
  String name() {
    return this.toString().split(".").last;
  }
}