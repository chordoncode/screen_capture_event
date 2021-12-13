import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';

class HashTag {
  final int id;
  final DateTime dateTime;
  final String title;
  final String tags;

  HashTag({required this.id, required this.dateTime, required this.title, required this.tags});
  
  static HashTag buildNew(final int id, final List<String> tags) {
    return HashTag(
      id: id,
      dateTime: DateTime.now(),
      title: "-",
      tags: tags.join(" ")
    );
  }

  static HashTag buildFrom(final HashTagEntity hashTagEntity) {
    return HashTag(
        id: hashTagEntity.hashtagId,
        dateTime: hashTagEntity.createdDate,
        title: "-",
        tags: hashTagEntity.tags
    );
  }
}