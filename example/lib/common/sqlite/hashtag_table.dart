enum HashTagTable {
  HASHTAG
}

extension HashTagTableExtension on HashTagTable {
  String tableName() {
    return this.toString().split(".").last.toLowerCase();
  }
}