import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasassy/data/models/comment.dart';
import 'package:kasassy/data/models/conversation.dart';
import 'package:kasassy/data/models/message.dart';
import 'package:kasassy/data/models/notification.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';

// Base Provider
abstract class BaseProvider {
  void dispose() {}
}

// Base Authentication Provider
abstract class BaseAuthenticationProvider extends BaseProvider {
  Future<void> signInWithGoogle();
  Future<void> signOutUser();
  User? currentUser;
  Stream<User?> user();
}

// Base Database Provider
abstract class BaseDatabaseProvider extends BaseProvider {
  Future<void> saveUserDetails({
    required User currentUser,
    required String profileImageURL,
    required String username,
    required int age,
  });
  Future<UserData?> isProfileComplete({
    required User currentUser,
  });

  Future<bool> isUsernameExist({
    required String username,
  });

  Future<void> saveUploadPost({
    required String mediaURL,
    required String currentLocation,
    required String caption,
    required String currentUserId,
    required String postId,
    required String username,
    required String avatarURL,
  });

  Stream<UserData> getProfileData({
    required String profileId,
  });
  Stream<List<PostData>> getProfilePostList({
    required String profileId,
  });

  Future<void> updateProfileData({
    required String currentUserId,
    required String name,
    required String bio,
  });

  Future<List<UserData>> getSearch({
    required String nameQuery,
  });

  Stream<List<ActivityFeedItemData>> getActivityFeed({
    required String currentUserId,
  });

  Stream<PostData> getPostData({
    required String postId,
  });

  Future<void> handleDeletePost({
    required String ownerId,
    required String postId,
  });

  Future<void> handleLikePost({
    required String ownerId,
    required String postId,
    required String mediaURL,
    required UserData currentUserData,
  });

  Future<void> handleDislikePost({
    required String ownerId,
    required String postId,
    required UserData currentUserData,
  });

  Stream<List<PostData>> get getTimeline;

  Stream<List<CommentData>> getComments({
    required String postId,
  });

  Future<void> addComment({
    required UserData currentUserData,
    required String textComment,
    required PostData postData,
  });

  Stream<List<ConversationData>> getConversationsList(String currentUserId);

  Future<String> openMessage({
    required UserData profileData,
    required UserData currentUserData,
  });

  Stream<List<MessageData>> getMessagesById(String chatId);

  Future<void> sendMessage({
    required String messageText,
    required String chatId,
    required UserData currentUserData,
  });
}

// Base Storage Provider
abstract class BaseStorageProvider extends BaseProvider {
  Future<String> uploadProfileImage({
    required File profileImage,
    required String usernamePath,
  });

  Future<String> uploadPostImage({
    required XFile postImage,
    required String usernamePath,
    required String postId,
  });
}

// Base Device Provider
abstract class BaseDeviceProvider extends BaseProvider {
  Future<String> getUserLocation();
}
