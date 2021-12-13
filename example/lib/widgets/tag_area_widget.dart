import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';

class TagAreaWidget extends StatefulWidget {
  final HashTag hashTag;

  const TagAreaWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _TagAreaWidgetState createState() => _TagAreaWidgetState();
}

class _TagAreaWidgetState extends State<TagAreaWidget> {
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();

    _tags = widget.hashTag.tags.split(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      alignment: WrapAlignment.start,
      itemCount: _tags.length, // required
      itemBuilder: (int index){
        final String tag = _tags[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index, // required
          active: true,
          pressEnabled: false,
          title: tag.replaceAll('#', ''),
          textStyle: const TextStyle(fontSize: 10),
          combine: ItemTagsCombine.withTextBefore,
          removeButton: ItemTagsRemoveButton(
            size: 20,
            onRemoved: () {
              // Remove the item from the data source.
              setState(() {
                _tags.removeAt(index);

                final HashTag newHashTag = HashTag.buildNew(widget.hashTag.id, _tags);
                Observable.instance.notifyObservers(["_HashTagComponentState"], notifyName : "removed", map: {"hashTag": newHashTag});
              });
              //required
              return true;
            },
          )
        );
      },
    );
  }
}