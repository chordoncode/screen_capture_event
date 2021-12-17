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

  static HashTag buildFromExisting(final HashTag hashTag, final List<String> tags) {
    return HashTag(
        id: hashTag.id,
        createdDateTime: hashTag.createdDateTime,
        modifiedDateTime: hashTag.modifiedDateTime,
        title: hashTag.title,
        tags: tags.join(" "),
        favorite: hashTag.favorite
    );
  }

  static HashTag buildFrom(final HashTagEntity hashTagEntity) {
    return HashTag(
        id: hashTagEntity.hashtagId,
        createdDateTime: hashTagEntity.createdDate,
        modifiedDateTime: hashTagEntity.modifiedDate,
        title: hashTagEntity.title,
        tags: hashTagEntity.tags,
        favorite: hashTagEntity.favorite
    );
  }

  static HashTag updateTitle(final HashTag hashTag, final String title) {
    return HashTag(
        id: hashTag.id,
        createdDateTime: hashTag.createdDateTime,
        modifiedDateTime: hashTag.modifiedDateTime,
        title: title,
        tags: hashTag.tags,
        favorite: hashTag.favorite
    );
  }

  static HashTag updateTags(final HashTag hashTag, final String tags) {
    return HashTag(
        id: hashTag.id,
        createdDateTime: hashTag.createdDateTime,
        modifiedDateTime: hashTag.modifiedDateTime,
        title: hashTag.title,
        tags: tags,
        favorite: hashTag.favorite
    );
  }
}