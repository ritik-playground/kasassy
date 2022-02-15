part of 'profile_parts.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Column(
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                backgroundImage:
                    CachedNetworkImageProvider(state.profileData.uploadPhoto),
              ),
              const SizedBox(height: 10),
              Text(
                '${state.profileData.name} (${state.profileData.username})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                state.profileData.bio,
              ),
              const SizedBox(height: 20),
              if (state.isProfileOwner)
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      EditProfile.route(
                        profileData: state.profileData,
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                OutlineButton(
                  onPressed: () {
                    context.read<ProfileCubit>().openMessage(
                          profileData: state.profileData,
                          currentUserData: state.currentUserData,
                        );
                  },
                  child: const Text('Message'),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          state.posts.length.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: const Text(
                            'posts',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }
        return Progress.circularProgress();
      },
    );
  }
}
