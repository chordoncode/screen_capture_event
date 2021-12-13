import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit_for_korean/google_ml_kit_for_korean.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(hasActions: false,),
      body: FutureBuilder<HashTag>(
          future: _findHashTagFromScreenShot(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CenterIndicator();
            }

            return snapshot.data == null
                ? const Center(
              child: Text(
                'No hashtags found ....',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
                : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return HashTagComponent(
                    hashTag: snapshot.data!);
              },
            );
          }
      )
    );
  }

  Future<HashTag> _findHashTagFromScreenShot() async {
    FileSystemEntity fileSystemEntity = FileUtils.getLastScreenShot();

    final inputImage = InputImage.fromFilePath(fileSystemEntity.path);
    RecognisedText recognisedText = await HashTagDetector().textDetector.processImage(inputImage);
    final List<String> tags = _resolveHashTags(recognisedText);
    final int id = await _save(tags);
    return HashTag.buildNew(id, tags);
  }

  List<String> _resolveHashTags(final RecognisedText recognisedText) {
    return ['#c2021a1', '#leonard', '#comet', '#경기도양평', '#redcat51', '#astro6d', '#toastpro2', '#lpro', '#starrynight', '#별이빛나는밤', '#astrophotography', '#천체사진', '#space', '#universe', '#cosmos', '#sky', '#하늘', '#nightsky', '#밤하늘'];
  }

  Future<int> _save(List<String> tags) async {
    // save widget.hashTag to local DB.
    return HashTagRepository.save({
      'tags': tags.join(" ")
    });
  }
}