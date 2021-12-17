import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/ui/components/widget/copy_button_widget.dart';
import 'package:screen_capture_event_example/ui/components/widget/edit_button_widget.dart';
import 'package:screen_capture_event_example/ui/components/widget/tag_area_widget.dart';

class UneditableHashTagComponent extends StatefulWidget {
  final HashTag hashTag;
  final Function callback;

  const UneditableHashTagComponent({Key? key, required this.hashTag, required this.callback}) : super(key: key);

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
                        CopyButtonWidget(hashTag: _hashTag),
                        const SizedBox(width: 5,),
                        EditButtonWidget(hashTag: _hashTag, callback: widget.callback)
                      ]
                  )
                ],
              ),
              SizedBox(height: 10.h),
              TagAreaWidget(hashTag: _hashTag)
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
