part of 'post_parts.dart';

class PostImage extends StatefulWidget {
  const PostImage({Key? key}) : super(key: key);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  bool showHeart = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostScreenCubit, PostScreenState>(
      builder: (context, state) {
        if (state is PostScreenUpdated) {
          return GestureDetector(
            onDoubleTap: () {
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
                setState(
                  () {
                    showHeart = true;
                  },
                );
                Timer(
                  const Duration(milliseconds: 250),
                  () {
                    setState(
                      () {
                        showHeart = false;
                      },
                    );
                  },
                );
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: state.postData.mediaURL,
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
                if (showHeart)
                  Animator(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 0.8, end: 1.4),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (buildContext, anim, child) => Transform.scale(
                      scale: anim.value as double,
                      child: const Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.red,
                      ),
                    ),
                  )
                else
                  const Text(''),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
