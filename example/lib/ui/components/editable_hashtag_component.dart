import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:grab_hashtag/common/ad/interstitial_ad_widget.dart';
import 'package:grab_hashtag/common/payment/payment_service.dart';
import 'package:grab_hashtag/model/hashtag.dart';
import 'package:grab_hashtag/repositories/hashtag_repository.dart';
import 'package:grab_hashtag/ui/components/widget/copy_button_widget.dart';
import 'package:grab_hashtag/ui/components/widget/hashtag_update_dialog_widget.dart';
import 'package:grab_hashtag/ui/components/widget/tag_date_widget.dart';

class EditableHashTagComponent extends StatefulWidget {
  final HashTag hashTag;

  const EditableHashTagComponent({Key? key, required this.hashTag}) : super(key: key);

  @override
  _EditableHashTagComponentState createState() => _EditableHashTagComponentState();
}

class _EditableHashTagComponentState extends State<EditableHashTagComponent> {
  late HashTag _hashTag;
  final TextEditingController _titleInputController = TextEditingController();
  final TextEditingController _newHashTagInputController = TextEditingController();
  bool _saveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _hashTag = widget.hashTag;
    _titleInputController.text = _hashTag.title;
  }

  @override
  void dispose() {
    _titleInputController.dispose();
    _newHashTagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        children: [
          Expanded(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TagDateWidget(hashTag: _hashTag),
                  Row(
                      children: [
                        CopyButtonWidget(hashTag: _hashTag),
                        const SizedBox(width: 5,),
                        _buildSaveButtonWidget()
                      ]
                  )
                ],
              ),
              _buildTitleArea(),
              SizedBox(height: 10.h),
              _buildTagAreaWidget(_hashTag),
              SizedBox(height: 10.h),
              _buildNewHashTagInputWidget()
            ],
          )
          ),
        ],
      ),
    );
  }

  Widget _buildTagAreaWidget(HashTag hashTag) {
    List<String> tags = hashTag.tags.split(" ");

    return Tags(
      alignment: WrapAlignment.start,
      itemCount: tags.length, // required
      itemBuilder: (int index){
        final String tag = tags[index];
        return ItemTags(
            key: Key(index.toString()),
            index: index, // required
            active: true,
            pressEnabled: false,
            title: tag.replaceAll('#', ''),
            textStyle: const TextStyle(fontSize: 10),
            combine: ItemTagsCombine.withTextBefore,
            onLongPressed:(item) async {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return HashTagUpdateDialogWidget(selectedTag: tag.replaceAll('#', ''), index: index);
                  }
              );
              if (result != null) {
                setState(() {
                  tags[index] = result;
                  _hashTag =  HashTag.buildFromExisting(_hashTag, tags);
                  _saveButtonEnabled = true;
                });
              }
            },
            removeButton: ItemTagsRemoveButton(
              size: 20,
              onRemoved: () {
                // Remove the item from the data source.
                setState(() {
                  if (tags.length == 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('You cannot remove all hash tags.', style: TextStyle(color: Colors.pinkAccent)),
                            duration: Duration(seconds: 2)
                        ));
                  } else {
                    tags.removeAt(index);
                    setState(() {
                      _hashTag =  HashTag.buildFromExisting(_hashTag, tags);
                      _saveButtonEnabled = true;
                    });
                  }
                });
                //required
                return true;
              },
            )
        );
      },
    );
  }

  Widget _buildTitleArea() {
    return Padding(
      child: TextField(
        onChanged: (text) {
          _onTitleChanged();
        },
        maxLength: 30,
        style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        controller: _titleInputController,
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white, fontSize: 8),
            errorStyle: TextStyle(color: Colors.red, fontSize: 8),
            labelText: 'Enter a title'
        ),
      ),
      padding: const EdgeInsets.all(20.0),
    );
  }

  Widget _buildSaveButtonWidget() {
    return SizedBox(
        height: 20,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                primary: _saveButtonEnabled ? Colors.white : Colors.grey,
                onPrimary: Colors.grey
            ),
            onPressed: () {
              if (_saveButtonEnabled) {
                if (!PaymentService.instance.isPro()) {
                  final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
                  _interstitialAdWidget.init(context, false);
                }

                _update();

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Saved successfully!', style: TextStyle(color: Colors.pinkAccent)),
                        duration: Duration(seconds: 2)
                    ));

                setState((){
                  _saveButtonEnabled  = false;
                });
              }
            },
            child: Text(
                'SAVE',
                style: TextStyle(
                  color: _saveButtonEnabled ? Colors.blueAccent : Colors.white,
                  fontSize: 10,)
            )
        )
    );
  }

  Widget _buildNewHashTagInputWidget() {
    return Padding(
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣\\s]')),
        ],
        onChanged: (text) {
          _onNewHashTagChanged(text);
        },
        maxLength: 30,
        style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        controller: _newHashTagInputController,
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white, fontSize: 8),
            errorStyle: TextStyle(color: Colors.red, fontSize: 8),
            labelText: 'Enter a new hash tag without # and space'
        ),
      ),
      padding: const EdgeInsets.all(10.0),
    );
  }

  void _onTitleChanged() {
    setState(() {
      _hashTag = HashTag.updateTitle(_hashTag, _titleInputController.text);
      _saveButtonEnabled = true;
    });
  }

  void _onNewHashTagChanged(String text) {
    final RegExp regexp = RegExp(r"[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣]{1,}");
    final Iterable<RegExpMatch> allMatches = regexp.allMatches(text);

    if ((text.length == 1 && text.endsWith(" ")) || allMatches.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter valid letters', style: TextStyle(color: Colors.pinkAccent)),
              duration: Duration(seconds: 2)
          )
      );
      _newHashTagInputController.clear();
      return;
    }

    if (text.endsWith(" ")) {
      final String newHashTagString = '#' + _newHashTagInputController.text.trim();
      List<String> tags = _hashTag.tags.split(" ");
      if (tags.contains(newHashTagString)) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Found duplications', style: TextStyle(color: Colors.pinkAccent)),
                duration: Duration(seconds: 2)
            )
        );
      } else {
        tags.add(newHashTagString);
      }

      setState(() {
        _newHashTagInputController.clear();
        _hashTag = HashTag.buildFromExisting(_hashTag, tags);
        _saveButtonEnabled = true;
      });
    }
  }

  void _update() {
    // save widget.hashTag to local DB.
    HashTagRepository.update({
      'tags': _hashTag.tags,
      'title': _hashTag.title,
    }, widget.hashTag.id, true);
  }
}
