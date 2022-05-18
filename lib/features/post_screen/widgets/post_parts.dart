import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/features/comment/comment.dart';
import 'package:kasassy/features/post_screen/cubit/post_screen_cubit.dart';
import 'package:kasassy/features/profile/profile_nav.dart';

part 'post_footer.dart';
part 'post_header.dart';
part 'post_image.dart';

class PostParts extends StatelessWidget {
  const PostParts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          PostHeader(),
          PostImage(),
          PostFooter(),
        ],
      ),
    );
  }
}
