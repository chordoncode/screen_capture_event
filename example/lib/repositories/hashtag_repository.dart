import 'package:screen_capture_event_example/common/sqlite/hashtag_db.dart';
import 'package:screen_capture_event_example/common/sqlite/hashtag_table.dart';
import 'package:screen_capture_event_example/common/util/time_utils.dart';

class HashTagRepository {
  static const HashTagTable TABLE = HashTagTable.HASHTAG;
  static const String DDL = 'CREATE TABLE hashtag(hashtag_id INTEGER PRIMARY KEY AUTOINCREMENT, tags TEXT, created_date INTEGER)';

  static Future<int> save(final Map<String, dynamic> data) async {
    return await HashTagDb().insert(TABLE, data);
  }

  static Future<void> updateRead(final Map<String, dynamic> data, final int hashTagId) async {
    HashTagDb().update(TABLE, data, "hashtag_id = ?", [hashTagId]);
  }

  static Future<int> delete(final int hashTagId) async {
    return HashTagDb().delete(TABLE, "hashtag_id = ?", [hashTagId]);
  }

  static Future<List<HashTagEntity>> getHashTags() async {
    List<Map<String, dynamic>> result = await HashTagDb().select(
      TABLE,
      orderBy: 'hashtag_id desc');

    return List.generate(result.length, (i) {
      return HashTagEntity.from(result[i]);
    });
  }
}

class HashTagEntity {
  final int hashtagId;
  final String tags;
  final DateTime createdDate;

  HashTagEntity({
    required this.hashtagId,
    required this.tags,
    required this.createdDate
  });

  static HashTagEntity from(final Map<String, dynamic> map) {
    return HashTagEntity(
      hashtagId: map['hashtag_id'],
      tags: map['tags'],
      createdDate: TimeUtils.toDateTime(map['created_date'])
    );
  }
}