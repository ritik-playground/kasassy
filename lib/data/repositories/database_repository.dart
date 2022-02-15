import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasassy/data/models/comment.dart';
import 'package:kasassy/data/models/conversation.dart';
import 'package:kasassy/data/models/message.dart';
import 'package:kasassy/data/models/notification.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/providers/_base_provider.dart';
import 'package:kasassy/data/providers/authentication_provider.dart';
import 'package:kasassy/data/providers/database_provider.dart';

class DatabaseRepository {
  DatabaseRepository({
    BaseAuthenticationProvider? baseAuthenticationProvider,
    BaseDatabaseProvider? baseDatabaseProvider,
  })  : _authenticationProvider =
            baseAuthenticationProvider ?? AuthenticationProvider(),
        _databaseProvider = baseDatabaseProvider ?? DatabaseProvider();

  final BaseAuthenticationProvider _authenticationProvider;
  final BaseDatabaseProvider _databaseProvider;

  Future<void> saveUserDetails({
    required User currentUser,
    required String profileImageURL,
    required int age,
    required String username,
  }) {
    return _databaseProvider.saveUserDetails(
      currentUser: currentUser,
      profileImageURL: profileImageURL,
      age: age,
      username: username,
    );
  }

  Future<UserData?> isProfileComplete(
    User currentUser,
  ) {
    return _databaseProvider.isProfileComplete(
      currentUser: currentUser,
    );
  }

  Future<void> uploadPostData({
    required String mediaUrl,
    required String location,
    required String description,
    required String currentUserId,
    required String postId,
    required String avatarURL,
    required String username,
  }) {
    return _databaseProvider.saveUploadPost(
      mediaURL: mediaUrl,
      currentLocation: location,
      caption: description,
      currentUserId: currentUserId,
      postId: postId,
      avatarURL: avatarURL,
      username: username,
    );
  }

  Stream<UserData> getProfile({
    required String profileId,
  }) {
    return _databaseProvider.getProfileData(profileId: profileId);
  }

  Stream<List<PostData>> getProfilePosts({
    required String profileId,
  }) {
    return _databaseProvider.getProfilePostList(profileId: profileId);
  }

  Future<void> updateProfileData({
    required String currentUserId,
    required String name,
    required String bio,
  }) {
    return _databaseProvider.updateProfileData(
      currentUserId: currentUserId,
      name: name,
      bio: bio,
    );
  }

  Future<List<UserData>> handleSearch(String nameQuery) {
    return _databaseProvider.getSearch(nameQuery: nameQuery);
  }

  Stream<List<ActivityFeedItemData>> getActivityFeed(String currentUserId) {
    return _databaseProvider.getActivityFeed(currentUserId: currentUserId);
  }

  Stream<PostData> getPostData(
    String postId,
  ) {
    return _databaseProvider.getPostData(
      postId: postId,
    );
  }

  Future<void> handleDeletePost({
    required String ownerId,
    required String postId,
  }) {
    return _databaseProvider.handleDeletePost(
      ownerId: ownerId,
      postId: postId,
    );
  }

  Future<void> handleLikePost({
    required String ownerId,
    required String postId,
    required String mediaURL,
    required UserData currentUserData,
  }) {
    return _databaseProvider.handleLikePost(
      ownerId: ownerId,
      postId: postId,
      mediaURL: mediaURL,
      currentUserData: currentUserData,
    );
  }

  Future<void> handleDislikePost({
    required String ownerId,
    required String postId,
    required UserData currentUserData,
  }) {
    return _databaseProvider.handleDislikePost(
      ownerId: ownerId,
      postId: postId,
      currentUserData: currentUserData,
    );
  }

  Stream<List<PostData>> getTimeline() {
    return _databaseProvider.getTimeline;
  }

  Stream<List<CommentData>> getComments(String postId) {
    return _databaseProvider.getComments(postId: postId);
  }

  Future<void> addComment({
    required UserData currentUserData,
    required PostData postData,
    required String textComment,
  }) {
    return _databaseProvider.addComment(
      currentUserData: currentUserData,
      textComment: textComment,
      postData: postData,
    );
  }

  Stream<List<ConversationData>> getConversationList(String currentUserId) {
    return _databaseProvider.getConversationsList(currentUserId);
  }

  Future<String> openMessageScreen({
    required UserData profileData,
    required UserData currentUserData,
  }) {
    return _databaseProvider.openMessage(
      currentUserData: currentUserData,
      profileData: profileData,
    );
  }

  Stream<List<MessageData>> getMessagesById(String chatId) {
    return _databaseProvider.getMessagesById(chatId);
  }

  Future<void> sendMessage({
    required String messageText,
    required UserData currentuserData,
    required String chatId,
  }) {
    return _databaseProvider.sendMessage(
      messageText: messageText,
      currentUserData: currentuserData,
      chatId: chatId,
    );
  }

  void dispose() {
    _authenticationProvider.dispose();
    _databaseProvider.dispose();
  }
}
