import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/widgets/copy_button_widget.dart';
import 'package:screen_capture_event_example/widgets/edit_button_widget.dart';
import 'package:screen_capture_event_example/widgets/tag_area_widget.dart';

class UneditableHashTagComponent extends StatefulWidget {
  final HashTag hashTag;

  const UneditableHashTagComponent({Key? key, required this.hashTag}) : super(key: key);

  @override
  _UneditableHashTagComponentState createState() => _UneditableHashTagComponentState();
}

class _UneditableHashTagComponentState extends State<UneditableHashTagComponent>  {
  late HashTag _hashTag;

  @override
  void initState() {
    super.initState();
    _hashTag = widget.hashTag;
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
                        const SizedBox(width: 15,),
                        EditButtonWidget(hashTag: _hashTag)
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
}
