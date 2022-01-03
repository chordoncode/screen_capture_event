import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:grab_tags/common/ad/interstitial_ad_widget.dart';
import 'package:grab_tags/common/payment/payment_service.dart';
import 'package:grab_tags/model/hashtag.dart';
import 'package:grab_tags/ui/components/widget/copy_button_widget.dart';
import 'package:grab_tags/ui/pages/mytag/edit_hashtag_page.dart';

class UneditableHashTagComponent extends StatefulWidget {
  final HashTag hashTag;
  final Function callback;
  final int index;

  const UneditableHashTagComponent({Key? key, required this.hashTag, required this.callback, required this.index}) : super(key: key);

  @override
  _UneditableHashTagComponentState createState() => _UneditableHashTagComponentState();
}

class _UneditableHashTagComponentState extends State<UneditableHashTagComponent> {
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
                      const SizedBox(width: 5,),
                      _buildEditButtonWidget()
                    ]
                  )
                ],
              ),
              SizedBox(height: 10.h),
              _buildTagAreaWidget(_hashTag)
            ],
          )
          ),
        ],
      ),
    );
  }

  Widget _buildEditButtonWidget() {
    return SizedBox(
      height: 20,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          primary: Colors.white, // background
        ),
        onPressed: () async {
          if (!PaymentService.instance.isPro()) {
            final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
            _interstitialAdWidget.init(context, true);
          }

          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditHashTagPage(hashTagId: widget.hashTag.id)));

          setState(() {
            widget.callback();
          });
        },
        child: const Text(
            'EDIT',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 10
            )
        )
      )
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
            removeButton: null
        );
      },
    );
  }
}
