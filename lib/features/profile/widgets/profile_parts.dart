import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasassy/constants/assets.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/features/edit_profile/edit_profile.dart';
import 'package:kasassy/features/post_screen/post_screen.dart';
import 'package:kasassy/features/post_widget/post_widget.dart';
import 'package:kasassy/features/profile/cubit/profile_cubit.dart';

part 'profile_footer.dart';
part 'profile_header.dart';

class ProfileParts extends StatelessWidget {
  const ProfileParts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ProfileHeader(),
        SizedBox(height: 20),
        ProfileFooter(),
      ],
    );
  }
}
