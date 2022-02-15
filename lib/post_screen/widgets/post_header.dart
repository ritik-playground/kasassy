part of 'post_parts.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostScreenCubit, PostScreenState>(
      builder: (context, state) {
        if (state is PostScreenUpdated) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                state.postData.avatarURL,
              ),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).push<void>(
                  Profile.route(profileId: state.postData.ownerId),
                );
              },
              child: Text(
                state.postData.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: state.postData.location != ''
                ? Text(
                    state.postData.location,
                  )
                : null,
            trailing: state.isPostOwner
                ? IconButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (contextNew) {
                          return SimpleDialog(
                            title: const Text('Remove this post?'),
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(contextNew);
                                  context.read<PostScreenCubit>().postDelete(
                                        ownerId: state.postData.ownerId,
                                        postId: state.postData.postId,
                                      );
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SimpleDialogOption(
                                onPressed: () => Navigator.pop(contextNew),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                : const Text(''),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
