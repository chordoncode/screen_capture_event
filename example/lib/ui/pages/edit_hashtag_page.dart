import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit_for_korean/google_ml_kit_for_korean.dart';
import 'package:screen_capture_event_example/common/ad/banner_ad_widget.dart';
import 'package:screen_capture_event_example/common/detector/hashtag_detector.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:screen_capture_event_example/common/util/file_utils.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';
import 'package:screen_capture_event_example/ui/components/hashtag_component.dart';
import 'package:screen_capture_event_example/widgets/appbar/custom_app_bar.dart';
import 'package:screen_capture_event_example/widgets/center_indicator.dart';

class EditHashTagPage extends StatefulWidget {
  final int hashTagId;
  const EditHashTagPage({Key? key, required this.hashTagId}) : super(key: key);

  @override
  _EditHashTagPageState createState() => _EditHashTagPageState();
}

class _EditHashTagPageState extends LifecycleWatcherState<EditHashTagPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(hasActions: false, fromOnBoardingPage: false, title: 'Edit hash tags'),
      body: Center(
        child: Column(
            children: [
              const SizedBox(height: 10,),
              const BannerAdWidget(),
              const SizedBox(height: 10,),
              FutureBuilder<HashTag>(
                  future: _findHashTag(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CenterIndicator();
                    }
                    return snapshot.data == null ? buildEmptyResult() : buildResult(snapshot);
                  }
              )
            ]
        )
      )
    );
  }

  Widget buildResult(AsyncSnapshot<HashTag> snapshot) {
    return Expanded(
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return HashTagComponent(hashTag: snapshot.data!);
            }
        )
    );
  }

  Widget buildEmptyResult() {
    return const Text(
      'No hashtags found ....',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  Future<HashTag> _findHashTag() async {
    HashTagEntity hashTagEntity = await HashTagRepository.getHashTag(widget.hashTagId);
    return HashTag.buildFrom(hashTagEntity);
  }

  Future<int> _save(List<String> tags) async {
    // save widget.hashTag to local DB.
    return HashTagRepository.save({
      'tags': tags.join(" ")
    });
  }
}