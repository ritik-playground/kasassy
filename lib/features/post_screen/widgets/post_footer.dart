part of 'post_parts.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostScreenCubit, PostScreenState>(
      builder: (context, state) {
        if (state is PostScreenUpdated) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (state.isLiked) {
                                context.read<PostScreenCubit>().postDislike(
                                      postData: state.postData,
                                      currentUserData: state.currentUserData,
                                    );
                              } else if (!state.isLiked) {
                                context.read<PostScreenCubit>().postLike(
                                      postData: state.postData,
                                      mediaURL: state.postData.mediaURL,
                                      currentUserData: state.currentUserData,
                                    );
                              }
                            },
                            child: Icon(
                              state.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 25,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push<void>(
                                Comment.route(
                                  postData: state.postData,
                                  currentUserData: state.currentUserData,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              size: 25,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        '${state.postData.likeCount} likes',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        state.postData.caption,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
