import 'package:badges/badges.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:icon_animator/icon_animator.dart';
import 'package:neon/neon.dart';
import 'package:screen_capture_event_example/common/ad/banner_ad_widget.dart';
import 'package:screen_capture_event_example/common/ad/interstitial_ad_widget.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/common/util/time_utils.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';
import 'package:screen_capture_event_example/ui/components/uneditable_hashtag_component.dart';
import 'package:screen_capture_event_example/ui/pages/main/layout.dart';
import 'package:screen_capture_event_example/widgets/center_indicator.dart';
import 'package:screen_capture_event_example/widgets/dismissible_background.dart';
import 'package:screen_capture_event_example/widgets/list_expandable_widget.dart';
import 'package:screen_capture_event_example/widgets/subscribe_promotion.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({Key? key}) : super(key: key);

  @override
  _TagListPageState createState() => _TagListPageState();
}
class _TagListPageState extends LifecycleWatcherState<TagListPage> {
  int? _updatedFavoriteHashTagId;
  final Set<int> _expandId = {};
  int _listSize = 0;

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
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _getWidgetsForEmpty()
                )
            );
           // return const Text('해시 태그 목록이 없습니다.');
          }
          return _getBody(snapshot.data!);
        }
    );
  }

  List<Widget> _getWidgetsForEmpty() {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 10,));

    if (!PaymentService.instance.isPro()) {
      widgets.add(const BannerAdWidget());
      widgets.add(const SizedBox(height: 20,));
      widgets.add(const SubscribePromotion(clickable: true));
      widgets.add(const SizedBox(height: 20,));
    }
    widgets.add(
      SizedBox(
        height: 250,
        child: EmptyWidget(
          image: null,
          packageImage: PackageImage.Image_1,
          title: 'No hash tags',
          subTitle: 'Grab hash tags!',
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Color(0xff9da9c7),
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xffabb8d6),
          ),
        )
      )
    );
    return widgets;
  }

  Widget _getBody(List<HashTag> data) {
    return RefreshIndicator(
      onRefresh: () =>
        Future.sync(
          () => setState(() => {}),
        ),
        child: Center(
          child: Column(
            children: _getWidgets(data)
          ),
        )
    );
  }

  List<Widget> _getWidgets(data) {
    List<Widget> widgets = [];

    if (!PaymentService.instance.isPro()) {
      widgets.add(const BannerAdWidget());
      widgets.add(const SizedBox(height: 20,));
      widgets.add(const SubscribePromotion(clickable: true));
      widgets.add(const SizedBox(height: 20,));
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
                background: const DismissBackground(message: "Good bye~ "),
                child: ListExpandableWidget(
                  isExpanded: isExpanded(data[index].id, index),
                  collapsedIcon: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white, size: 14),
                  expandedIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white, size: 14),
                  header: _header(data[index]),
                  items: _buildItems(context, data[index], index),
                  onExpanded: () {
                    _expandId.add(data[index].id);
                  },
                  onCollapsed: () {
                    _expandId.remove(data[index].id);
                  },
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

  Widget _header(HashTag hashTag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            _updatedFavoriteHashTagId = hashTag.id;

            await HashTagRepository.update({
              'favorite': hashTag.favorite ? 0 : 1
            }, hashTag.id, false);

            setState(() {});
          },
          child: _updatedFavoriteHashTagId == hashTag.id && hashTag.favorite ?
            SizedBox(
              width: 25,
              height: 25,
              child: IconAnimator(
                icon: Icons.favorite,
                finish: Icon(Icons.favorite, color: Colors.amber[600]),
                loop: 1,
                children: [
                  AnimationFrame(size: 0, duration: 80),
                  AnimationFrame(size: 4, color: Colors.amber[100], duration: 80),
                  AnimationFrame(size: 8, color: Colors.amber[200], duration: 80),
                  AnimationFrame(size: 16, color: Colors.amber[300], duration: 80),
                  AnimationFrame(size: 20, color: Colors.amber[400], duration: 80),
                  AnimationFrame(size: 24, color: Colors.amber[500], duration: 80),
                  AnimationFrame(size: 28, color: Colors.amber[600], duration: 80),
                ],
              ),
            ) :
            Icon(
              hashTag.favorite ? Icons.favorite : Icons.favorite_border,
              color: hashTag.favorite ? Colors.amber[600] : Colors.blueGrey,
              size: 25
            )
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  TimeUtils.toFormattedString(hashTag.modifiedDateTime, 'yyyy-MM-dd HH:mm'),
                  style: const TextStyle(fontSize: 10, color: Colors.grey)
              ),
              const SizedBox(height: 5,),
              Text(
                  hashTag.title,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 12, color: Colors.white)
              )
            ]
          )
        )
      ],
    );
  }

  List<ListTile> _buildItems(BuildContext context, HashTag hashTag, int index) {
    return [
      ListTile(
        title: UneditableHashTagComponent(hashTag: hashTag, callback: (){
          setState(() {
          });
      }, index: index))
    ];
  }

  Future<List<HashTag>> _getHashTagList() async {
    List<HashTagEntity> hashTagEntities = await HashTagRepository.getHashTags();
    return hashTagEntities.map((e) => HashTag.buildFrom(e)).toList();

  }

  Future<bool> _deleteItem(int hashtagId) async {
    _expandId.remove(hashtagId);
    int affected = await HashTagRepository.delete(hashtagId);
    return affected > 0;
  }

  bool isExpanded(int id, int index) {
    return _expandId.contains(id) || index == 0;
  }
}