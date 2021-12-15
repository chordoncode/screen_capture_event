import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/ad/banner_ad_widget.dart';
import 'package:screen_capture_event_example/common/detector/hashtag_detector.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:screen_capture_event_example/common/util/file_utils.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';
import 'package:screen_capture_event_example/ui/components/hashtag_component.dart';
import 'package:screen_capture_event_example/widgets/appbar/custom_app_bar.dart';
import 'package:screen_capture_event_example/widgets/center_indicator.dart';

class SnapShotPage extends StatefulWidget {
  const SnapShotPage({Key? key}) : super(key: key);

  @override
  _SnapShotPageState createState() => _SnapShotPageState();
}

class _SnapShotPageState extends LifecycleWatcherState<SnapShotPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(hasActions: false, fromOnBoardingPage: false),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const BannerAdWidget(),
            const SizedBox(height: 10,),
            FutureBuilder<HashTag>(
              future: _findHashTagFromScreenShot(),
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

  Future<HashTag> _findHashTagFromScreenShot() async {
    FileSystemEntity fileSystemEntity = FileUtils.getLastScreenShot();

    final List<String> tags = await HashTagDetector().extractHashtagFromFilepath(fileSystemEntity.path);
    final int id = await _save(tags);
    return HashTag.buildNew(id, tags);
  }

  Future<int> _save(List<String> tags) async {
    // save widget.hashTag to local DB.
    return HashTagRepository.save({
      'tags': tags.join(" ")
    });
  }
}