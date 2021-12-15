enum SharedStorageKey {
  doneOnBoarding,
  activated
}

extension ParseToName on SharedStorageKey {
  String name() {
    return this.toString().split(".").last;
  }
}