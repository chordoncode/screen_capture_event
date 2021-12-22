import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/ui/components/widget/hashtag_update_dialog_widget.dart';

class TagAreaWidget extends StatefulWidget {
  final HashTag hashTag;
  final bool editMode;

  const TagAreaWidget({Key? key, required this.hashTag, required this.editMode}) : super(key: key);

  @override
  _TagAreaWidgetState createState() => _TagAreaWidgetState();
}

class _TagAreaWidgetState extends State<TagAreaWidget> with Observer {
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    Observable.instance.addObserver(this);
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tags = widget.hashTag.tags.split(" ");

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
          onLongPressed:(item) {
            if (widget.editMode) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return HashTagUpdateDialogWidget(selectedTag: tag.replaceAll('#', ''), index: index);
                  }
              );
            }
          },
          removeButton: widget.editMode ? ItemTagsRemoveButton(
            size: 20,
            onRemoved: () {
              // Remove the item from the data source.
              setState(() {
                if (_tags.length == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You cannot remove all hash tags.', style: TextStyle(color: Colors.pinkAccent)),
                      duration: Duration(seconds: 2)
                    ));
                } else {
                  _tags.removeAt(index);

                  final HashTag newHashTag = HashTag.buildFromExisting(widget.hashTag, _tags);
                  Observable.instance.notifyObservers(["_HashTagComponentState"], notifyName : "removed", map: {"hashTag": newHashTag});
                  Observable.instance.notifyObservers(["_SaveButtonWidgetState"], notifyName : "removed", map: {"hashTag": newHashTag});
                  Observable.instance.notifyObservers(["_UneditableHashTagComponentState"], notifyName : "removed", map: {"hashTag": newHashTag});
                }
              });
              //required
              return true;
            },
          ) : null
        );
      },
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if (notifyName == 'added') {
      String newHashTagString = map!['newHashTag'];
      if (_tags.contains(newHashTagString)) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Found duplications', style: TextStyle(color: Colors.pinkAccent)),
                duration: Duration(seconds: 2)
            )
        );

      } else {
        _tags.add(newHashTagString);
      }

      setState(() {
        final HashTag newHashTag = HashTag.buildFromExisting(widget.hashTag, _tags);
        Observable.instance.notifyObservers(["_SaveButtonWidgetState"], notifyName : "added", map: {"hashTag": newHashTag});
        Observable.instance.notifyObservers(["_HashTagComponentState"], notifyName : "added", map: {"hashTag": newHashTag});
      });
      return;
    }
    if (notifyName == 'updated') {
      String updatedHashTagString = map!['updatedHashTag'];
      _tags[map!['index']] = updatedHashTagString;

      setState(() {
        final HashTag newHashTag = HashTag.buildFromExisting(widget.hashTag, _tags);
        Observable.instance.notifyObservers(["_SaveButtonWidgetState"], notifyName : "updated", map: {"hashTag": newHashTag});
        Observable.instance.notifyObservers(["_HashTagComponentState"], notifyName : "updated", map: {"hashTag": newHashTag});
      });
      return;
    }
  }
}