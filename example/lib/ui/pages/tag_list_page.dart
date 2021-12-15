import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/ad/banner_ad_widget.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/common/util/time_utils.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';
import 'package:screen_capture_event_example/ui/components/uneditable_hashtag_component.dart';
import 'package:screen_capture_event_example/widgets/center_indicator.dart';
import 'package:screen_capture_event_example/widgets/dismissible_background.dart';
import 'package:screen_capture_event_example/widgets/list_expandable_widget.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({Key? key}) : super(key: key);

  @override
  _TagListPageState createState() => _TagListPageState();
}
class _TagListPageState extends LifecycleWatcherState<TagListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HashTag>>(
        future: _getHashTagList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CenterIndicator();
          }
          if (snapshot.data!.isEmpty) {
            return Container(
                alignment: Alignment.center,
                child: Column(children: [
                  const SizedBox(height: 10,),
                  const BannerAdWidget(),
                  const SizedBox(height: 10,),
                  EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'No hash tags',
                    subTitle: 'Grab hash tags from Instagram!',
                    titleTextStyle: const TextStyle(
                      fontSize: 22,
                      color: Color(0xff9da9c7),
                      fontWeight: FontWeight.w500,
                    ),
                    subtitleTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffabb8d6),
                    ),
                  )
                ])
            );
           // return const Text('해시 태그 목록이 없습니다.');
          }
          return _getBody(snapshot.data!);
        }
    );
  }

  Widget _getBody(List<HashTag> data) {
    return RefreshIndicator(
      onRefresh: () =>
        Future.sync(
          () => setState(() => {}),
        ),
        child: Center(
          child: Column(
            children: getWidgets(data)
          ),
        )
    );
  }

  List<Widget> getWidgets(data) {
    List<Widget> widgets = [];

    if (!PaymentService.instance.isPro()) {
      widgets.add(const BannerAdWidget());
    }
    widgets.add(
      Expanded(
        child: ListView.separated(
            itemCount: data.length,
            shrinkWrap: true,
            //padding: EdgeInsets.only(top: 16),
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    return await _deleteItem(data[index].id);
                  },
                  onDismissed: (direction) {
                    setState(() {});
                  },
                  background: DismissBackground(message: "Good bye~ "),
                  child: ListExpandableWidget(
                    isExpanded: index == 0 ? true : false,
                    collapsedIcon: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white, size: 14),
                    expandedIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white, size: 14),
                    header: _header(TimeUtils.toFormattedString(data[index].dateTime, 'yyyy-MM-dd hh:mm')),
                    items: _buildItems(context, data[index]),
                  )
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                  thickness: 1.0
              );
            }
        ),
      )
    );
    return widgets;
  }

  Widget _header(String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
              fontSize: 10,
              color: Colors.grey
          )
        ),
        const SizedBox(height: 5,),
        const Text(
            'copied from Instagram',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white
            )
        )
      ]
    );
  }

  List<ListTile> _buildItems(BuildContext context, HashTag hashTag) {
    return [
      ListTile(
          title: UneditableHashTagComponent(hashTag: hashTag)
      )
    ];
  }

  Future<List<HashTag>> _getHashTagList() async {
    final List<HashTagEntity> hashTagEntities = await HashTagRepository.getHashTags();
    return hashTagEntities.map((e) => HashTag.buildFrom(e)).toList();

  }

  Future<bool> _deleteItem(int hashtagId) async {
    int affected = await HashTagRepository.delete(hashtagId);
    return affected > 0;
  }
}