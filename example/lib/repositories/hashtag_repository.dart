import 'package:grab_tags/common/sqlite/hashtag_db.dart';
import 'package:grab_tags/common/sqlite/hashtag_table.dart';
import 'package:grab_tags/common/util/time_utils.dart';

class HashTagRepository {
  static const HashTagTable TABLE = HashTagTable.HASHTAG;
  static const String DDL = 'CREATE TABLE hashtag(hashtag_id INTEGER PRIMARY KEY AUTOINCREMENT, tags TEXT, title TEXT, favorite INTEGER, created_date INTEGER, modified_date INTEGER)';

  static Future<int> save(final Map<String, dynamic> data) async {
    data['favorite'] = 0;

    return await HashTagDb().insert(TABLE, data);
  }

  static Future<void> update(final Map<String, dynamic> data, final int hashTagId, final bool updateDate) async {
    if (updateDate) {
      final int now = TimeUtils.nowForMillisecondsSinceEpoch();
      data['modified_date'] = now;
    }

    HashTagDb().update(TABLE, data, "hashtag_id = ?", [hashTagId]);
  }

  static Future<int> delete(final int hashTagId) async {
    return HashTagDb().delete(TABLE, "hashtag_id = ?", [hashTagId]);
  }

  static Future<HashTagEntity> getHashTag(final int hashTagId) async {
    Map<String, dynamic> result = await HashTagDb().selectOne(
        TABLE,
        where: "hashtag_id = ?",
        whereArgs: [hashTagId]);

    return HashTagEntity.from(result);
  }

  static Future<List<HashTagEntity>> getHashTags() async {
    //List<Map<String, dynamic>> result = [];

    /*
    List<Map<String, dynamic>> favorite = await HashTagDb().select(
      TABLE,
      where: "favorite = ?",
      whereArgs: [1],
      orderBy: 'modified_date desc');
     */

    List<Map<String, dynamic>> result = await HashTagDb().select(
        TABLE,
        //where: "favorite = ?",
        //whereArgs: [0],
        orderBy: 'modified_date desc');
    /*
    result.addAll(favorite);
    result.addAll(nonFavorite);
     */

    return List.generate(result.length, (i) {
      return HashTagEntity.from(result[i]);
    });
  }
}

class HashTagEntity {
  final int hashtagId;
  final bool favorite;
  final String title;
  final String tags;
  final DateTime createdDate;
  final DateTime modifiedDate;

  HashTagEntity({
    required this.hashtagId,
    required this.favorite,
    required this.title,
    required this.tags,
    required this.createdDate,
    required this.modifiedDate
  });

  static HashTagEntity from(final Map<String, dynamic> map) {
    return HashTagEntity(
      hashtagId: map['hashtag_id'],
      favorite: map['favorite'] == 1,
      title: map['title'],
      tags: map['tags'],
      createdDate: TimeUtils.toDateTime(map['created_date']),
      modifiedDate: TimeUtils.toDateTime(map['modified_date'])
    );
  }
}