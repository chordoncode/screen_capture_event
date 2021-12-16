import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';

class HashTag {
  final int id;
  final DateTime createdDateTime;
  final DateTime modifiedDateTime;
  final String title;
  final String tags;
  final bool favorite;

  HashTag({required this.id, required this.createdDateTime, required this.modifiedDateTime, required this.title, required this.tags, required this.favorite});
  
  static HashTag buildNew(final int id, final List<String> tags) {
    return HashTag(
      id: id,
      createdDateTime: DateTime.now(),
      modifiedDateTime: DateTime.now(),
      title: "-",
      tags: tags.join(" "),
      favorite: false
    );
  }

  static HashTag buildFrom(final HashTagEntity hashTagEntity) {
    return HashTag(
        id: hashTagEntity.hashtagId,
        createdDateTime: hashTagEntity.createdDate,
        modifiedDateTime: hashTagEntity.modifiedDate,
        title: "-",
        tags: hashTagEntity.tags,
        favorite: hashTagEntity.favorite
    );
  }
}