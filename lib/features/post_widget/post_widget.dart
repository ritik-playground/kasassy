import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';
import 'package:kasassy/features/comment/comment.dart';
import 'package:kasassy/features/post_widget/cubit/post_widget_cubit.dart';
import 'package:kasassy/features/profile/profile_nav.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.postData,
  }) : super(key: key);

  final PostData postData;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool showHeart = false;

  @override
  Widget build(BuildContext context) {
    final _currentUserData = context.read<AppBloc>().state.currentUserData;
    return BlocProvider(
      create: (context) => PostWidgetCubit(
        userDataRepository: context.read<DatabaseRepository>(),
      ),
      child: BlocBuilder<PostWidgetCubit, PostWidgetState>(
        builder: (context, state) {
          if (state is PostWidgetInitial) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        widget.postData.avatarURL,
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push<void>(
                          Profile.route(profileId: widget.postData.ownerId),
                        );
                      },
                      child: Text(
                        widget.postData.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: widget.postData.location != ''
                        ? Text(
                            widget.postData.location,
                          )
                        : null,
                    trailing: _currentUserData?.uid == widget.postData.ownerId
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
                                          context
                                              .read<PostWidgetCubit>()
                                              .postDelete(
                                                ownerId:
                                                    widget.postData.ownerId,
                                                postId: widget.postData.postId,
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
                                        onPressed: () =>
                                            Navigator.pop(contextNew),
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
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (widget.postData.likes[_currentUserData?.uid] ==
                          true) {
                        context.read<PostWidgetCubit>().postDislike(
                              postData: widget.postData,
                              currentUserData: _currentUserData!,
                            );
                      } else {
                        context.read<PostWidgetCubit>().postLike(
                              postData: widget.postData,
                              mediaURL: widget.postData.mediaURL,
                              currentUserData: _currentUserData!,
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
                          imageUrl: widget.postData.mediaURL,
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
                            builder: (buildContext, anim, child) =>
                                Transform.scale(
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
                  ),
                  Column(
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
                                      if (widget.postData
                                              .likes[_currentUserData?.uid] ==
                                          true) {
                                        context
                                            .read<PostWidgetCubit>()
                                            .postDislike(
                                              postData: widget.postData,
                                              currentUserData:
                                                  _currentUserData!,
                                            );
                                      } else {
                                        context
                                            .read<PostWidgetCubit>()
                                            .postLike(
                                              postData: widget.postData,
                                              mediaURL:
                                                  widget.postData.mediaURL,
                                              currentUserData:
                                                  _currentUserData!,
                                            );
                                      }
                                    },
                                    child: Icon(
                                      widget.postData.likes[
                                                  _currentUserData?.uid] ==
                                              true
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
                                          postData: widget.postData,
                                          currentUserData: _currentUserData!,
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
                                '${widget.postData.likeCount} likes',
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
                                widget.postData.caption,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Progress.circularProgress();
          }
        },
      ),
    );
  }
}
