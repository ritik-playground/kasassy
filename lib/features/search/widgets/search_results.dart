import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasassy/constants/palette.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/features/profile/profile_nav.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.searchUserResults,
  }) : super(key: key);

  final List<UserData> searchUserResults;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchUserResults.length,
      itemBuilder: (context, index) {
        return _SearchResult(
          searchUserResult: searchUserResults[index],
        );
      },
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    Key? key,
    required this.searchUserResult,
  }) : super(key: key);

  final UserData searchUserResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.secondaryColor.withOpacity(0.1),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push<void>(
                Profile.route(
                  profileId: searchUserResult.uid,
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                  searchUserResult.uploadPhoto,
                ),
              ),
              title: Text(
                searchUserResult.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                searchUserResult.username,
              ),
            ),
          ),
          const Divider(
            height: 2,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
