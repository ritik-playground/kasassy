import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/data/repositories/device_repository.dart';
import 'package:kasassy/data/repositories/storage_repository.dart';
import 'package:kasassy/features/activity/cubit/activity_feed_cubit.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';
import 'package:kasassy/features/profile/profile_nav.dart';
import 'package:kasassy/features/search/cubit/search_cubit.dart';
import 'package:kasassy/features/timeline/cubit/timeline_cubit.dart';
import 'package:kasassy/features/timeline/timeline_nav.dart';
import 'package:kasassy/features/upload/cubit/upload_cubit.dart';
import 'package:kasassy/features/upload/upload_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage._({Key? key}) : super(key: key);

  static Page page() {
    return MaterialPage<void>(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TimelineCubit>(
            create: (context) => TimelineCubit(
              userDataRepository: context.read<DatabaseRepository>(),
            )..launchTimeline(),
          ),
          BlocProvider<ActivityFeedCubit>(
            create: (context) => ActivityFeedCubit(
              userDataRepository: context.read<DatabaseRepository>(),
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            )..activityLaunch(),
          ),
          BlocProvider<UploadCubit>(
            create: (context) => UploadCubit(
              userDataRepository: context.read<DatabaseRepository>(),
              storageRepository: context.read<StorageRepository>(),
              deviceRepository: context.read<DeviceRepository>(),
            ),
          ),
          BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(
              userDataRepository: context.read<DatabaseRepository>(),
            ),
          ),
        ],
        child: const HomePage._(),
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData =
        context.select((AppBloc bloc) => bloc.state.currentUserData)!;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const Timeline(),
          const Upload(),
          Profile(profileId: currentUserData.uid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera,
              size: 35,
            ),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void onPageChanged(int pageIndex) {
    setState(
      () {
        this.pageIndex = pageIndex;
      },
    );
  }

  void onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeInOut,
    );
  }
}
