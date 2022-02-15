import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasassy/data/models/notification.dart';
import 'package:kasassy/post_screen/post_screen.dart';
import 'package:kasassy/profile/profile_nav.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedItems extends StatelessWidget {
  const ActivityFeedItems({
    Key? key,
    required this.activityFeedItemsData,
  }) : super(key: key);

  final List<ActivityFeedItemData> activityFeedItemsData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activityFeedItemsData.length,
      itemBuilder: (context, index) {
        return ActivityFeedItem(
          activityFeedItemData: activityFeedItemsData[index],
        );
      },
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  const ActivityFeedItem({
    Key? key,
    required this.activityFeedItemData,
  }) : super(key: key);

  final ActivityFeedItemData activityFeedItemData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push<void>(
              Profile.route(profileId: activityFeedItemData.userId),
            );
          },
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.pink,
              ),
              children: [
                TextSpan(
                  text: activityFeedItemData.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: activityItemText(),
                ),
              ],
            ),
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            activityFeedItemData.userProfileImage,
          ),
        ),
        subtitle: Text(
          timeago.format(activityFeedItemData.timestamp.toDate()),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: activityFeedItemData.typeActivity == 'like' ||
                activityFeedItemData.typeActivity == 'comment'
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push<void>(
                    PostScreen.route(
                      postId: activityFeedItemData.postId,
                    ),
                  );
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            activityFeedItemData.mediaURL,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const Text(''),
      ),
    );
  }

  String activityItemText() {
    String activityItemText;
    if (activityFeedItemData.typeActivity == 'like') {
      activityItemText = ' liked your post';
    } else if (activityFeedItemData.typeActivity == 'follow') {
      activityItemText = ' is following you';
    } else if (activityFeedItemData.typeActivity == 'comment') {
      activityItemText = ' replied: ${activityFeedItemData.commentData}';
    } else {
      activityItemText =
          "Error: Unknown type '${activityFeedItemData.typeActivity}'";
    }
    return activityItemText;
  }
}
