import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grab_tags/model/hashtag.dart';
import 'package:grab_tags/ui/components/widget/copy_button_widget.dart';
import 'package:grab_tags/ui/components/widget/edit_button_widget.dart';
import 'package:grab_tags/ui/components/widget/tag_area_widget.dart';

class UneditableHashTagComponent extends StatefulWidget {
  final HashTag hashTag;
  final Function callback;
  final int index;

  const UneditableHashTagComponent({Key? key, required this.hashTag, required this.callback, required this.index}) : super(key: key);

  @override
  _UneditableHashTagComponentState createState() => _UneditableHashTagComponentState();
}

class _UneditableHashTagComponentState extends State<UneditableHashTagComponent> with Observer {
  late HashTag _hashTag;

  @override
  void initState() {
    super.initState();
    _hashTag = widget.hashTag;
    Observable.instance.addObserver(this);
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      CopyButtonWidget(hashTag: _hashTag, index: widget.index),
                      const SizedBox(width: 5,),
                      EditButtonWidget(hashTag: _hashTag, callback: widget.callback, index: widget.index)
                    ]
                  )
                ],
              ),
              SizedBox(height: 10.h),
              TagAreaWidget(hashTag: _hashTag, editMode: false)
            ],
          )
          ),
        ],
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if (notifyName == 'removed') {
      setState(() {
        _hashTag = map!['hashTag'];
      });
    }
  }
}
