import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/widgets/copy_button_widget.dart';
import 'package:screen_capture_event_example/widgets/save_button_widget.dart';
import 'package:screen_capture_event_example/widgets/tag_area_widget.dart';
import 'package:screen_capture_event_example/widgets/tag_date_title_widget.dart';

class HashTagComponent extends StatefulWidget {
  final HashTag hashTag;

  const HashTagComponent({Key? key, required this.hashTag}) : super(key: key);

  @override
  _HashTagComponentState createState() => _HashTagComponentState();
}

class _HashTagComponentState extends State<HashTagComponent> with Observer {
  late HashTag _hashTag;
  bool _enabled = false;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TagDateTitleWidget(hashTag: _hashTag),
                  Row(
                      children: [
                        CopyButtonWidget(hashTag: _hashTag),
                        const SizedBox(width: 15,),
                        SaveButtonWidget(hashTag: _hashTag, enabled: _enabled)
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
        _enabled = true;
      });
    } else if (notifyName == 'saved') {
      setState(() {
        _enabled = false;
      });
    }
  }
}
