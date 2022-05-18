part of 'profile_parts.dart';

enum PostOrientation { grid, list }

class ProfileFooter extends StatefulWidget {
  const ProfileFooter({Key? key}) : super(key: key);

  @override
  _ProfileFooterState createState() => _ProfileFooterState();
}

class _ProfileFooterState extends State<ProfileFooter> {
  PostOrientation postOrientation = PostOrientation.grid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          if (state.posts.isEmpty) {
            return const ProfileEmpty();
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          postOrientation = PostOrientation.grid;
                        });
                      },
                      icon: const Icon(Icons.check_box_outline_blank),
                      color: postOrientation == PostOrientation.grid
                          ? Theme.of(context).primaryColorLight
                          : Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          postOrientation = PostOrientation.list;
                        });
                      },
                      icon: const Icon(Icons.radio_button_unchecked),
                      color: postOrientation == PostOrientation.list
                          ? Theme.of(context).primaryColorLight
                          : Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (postOrientation == PostOrientation.grid)
                  GridProfile(posts: state.posts)
                else
                  ListProfile(posts: state.posts)
              ],
            );
          }
        }
        return Progress.circularProgress();
      },
    );
  }
}

class ProfileEmpty extends StatelessWidget {
  const ProfileEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          SVG.noContent,
          height: 260,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'No Posts',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class GridProfile extends StatelessWidget {
  const GridProfile({Key? key, required this.posts}) : super(key: key);

  final List<PostData> posts;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GridTile(
          child: PostTile(
            postData: posts[index],
          ),
        );
      },
      itemCount: posts.length,
    );
  }
}

class ListProfile extends StatelessWidget {
  const ListProfile({Key? key, required this.posts}) : super(key: key);

  final List<PostData> posts;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostWidget(
          postData: posts[index],
        );
      },
    );
  }
}

class PostTile extends StatelessWidget {
  const PostTile({
    Key? key,
    required this.postData,
  }) : super(key: key);

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push<void>(
          PostScreen.route(
            postId: postData.postId,
          ),
        );
      },
      child: CachedNetworkImage(
        imageUrl: postData.mediaURL,
        fit: BoxFit.cover,
        placeholder: (_, __) => const Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ),
        errorWidget: (_, __, dynamic error) => const Icon(
          Icons.error,
        ),
      ),
    );
  }
}
