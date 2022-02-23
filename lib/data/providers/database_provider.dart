// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasassy/data/models/comment.dart';
import 'package:kasassy/data/models/conversation.dart';
import 'package:kasassy/data/models/message.dart';
import 'package:kasassy/data/models/notification.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/providers/_base_provider.dart';

class DatabaseProvider extends BaseDatabaseProvider {
  DatabaseProvider({
    FirebaseFirestore? firebaseFirestore,
  }) : _firestoreData = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestoreData;

  @override
  Future<void> saveUserDetails({
    required User currentUser,
    required String profileImageURL,
    required int age,
    required String username,
  }) async {
    try {
      final userData = {
        'uploadPhoto': profileImageURL,
        'age': age,
        'username': username,
        'uid': currentUser.uid,
        'name': currentUser.displayName,
        'email': currentUser.email,
        'googlePhoto': currentUser.photoURL,
        'bio': '',
      };
      final currentUserReference = _firestoreData.collection('users').doc(
            currentUser.uid,
          );
      final userEmpty = await currentUserReference.snapshots().isEmpty;
      if (!userEmpty) {
        await currentUserReference.set(
          userData,
          SetOptions(
            merge: true,
          ),
        );
      }
    } on Exception {
      throw SaveUserDetails();
    }
  }

  @override
  Future<UserData?> isProfileComplete({
    required User currentUser,
  }) async {
    try {
      final currentUserReference = _firestoreData.collection('users').doc(
            currentUser.uid,
          );
      final currentUserDocument = await currentUserReference.get();
      final isProfileComplete = currentUserDocument.exists &&
          currentUserDocument.data()!.containsKey('uid') &&
          currentUserDocument.data()!.containsKey('name') &&
          currentUserDocument.data()!.containsKey('email') &&
          currentUserDocument.data()!.containsKey('uploadPhoto') &&
          currentUserDocument.data()!.containsKey('username');
      if (isProfileComplete) {
        return UserData.fromFirestore(currentUserDocument);
      } else {
        return null;
      }
    } on Exception {
      throw IsProfileComplete();
    }
  }

  @override
  Future<bool> isUsernameExist({required String username}) async {
    try {
      final documentSnapshot = await _firestoreData
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      final isUsernameExist = documentSnapshot.docs.isNotEmpty;
      return isUsernameExist;
    } on Exception {
      throw IsUsernameExist();
    }
  }

  @override
  Future<void> saveUploadPost({
    required String mediaURL,
    required String currentLocation,
    required String caption,
    required String currentUserId,
    required String postId,
    required String avatarURL,
    required String username,
  }) async {
    try {
      final currentTimestamp = DateTime.now();
      final postsReference = _firestoreData.collection('posts');
      await postsReference.doc(postId).set(
        <String, dynamic>{
          'postId': postId,
          'ownerId': currentUserId,
          'mediaURL': mediaURL,
          'caption': caption,
          'avatarURL': avatarURL,
          'username': username,
          'location': currentLocation,
          'timestamp': currentTimestamp,
          'likes': <String, bool>{},
        },
      );
    } on Exception {
      throw UploadPostData();
    }
  }

  @override
  Stream<UserData> getProfileData({
    required String profileId,
  }) {
    try {
      final profileData =
          _firestoreData.collection('users').doc(profileId).snapshots().map(
                (event) => UserData.fromFirestore(event),
              );
      return profileData;
    } on Exception {
      throw GetProfileData();
    }
  }

  @override
  Stream<List<PostData>> getProfilePostList({
    required String profileId,
  }) {
    try {
      final profilePostsData = _firestoreData
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .where('ownerId', isEqualTo: profileId)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => PostData.fromFirestore(e),
                )
                .toList(),
          );
      return profilePostsData;
    } on Exception {
      throw GetProfilePostsData();
    }
  }

  @override
  Future<void> updateProfileData({
    required String currentUserId,
    required String name,
    required String bio,
  }) async {
    try {
      await _firestoreData.collection('users').doc(currentUserId).update(
        <String, String>{
          'name': name,
          'bio': bio,
        },
      );
    } on Exception {
      throw UpdateProfileData();
    }
  }

  @override
  Future<List<UserData>> getSearch({
    required String nameQuery,
  }) {
    try {
      final nameQueryFuture = _firestoreData
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: nameQuery)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (e) => UserData.fromFirestore(e),
                )
                .toList(),
          );
      return nameQueryFuture;
    } on Exception {
      throw HandleSearch();
    }
  }

  @override
  Stream<List<ActivityFeedItemData>> getActivityFeed({
    required String currentUserId,
  }) {
    try {
      final activityFeedItemSnapshot = _firestoreData
          .collection('feed')
          .doc(currentUserId)
          .collection('feedItems')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => ActivityFeedItemData.fromFirestore(e),
                )
                .toList(),
          );
      return activityFeedItemSnapshot;
    } on Exception {
      throw GetActivityFeed();
    }
  }

  @override
  Stream<PostData> getPostData({
    required String postId,
  }) {
    try {
      final postData =
          _firestoreData.collection('posts').doc(postId).snapshots().map(
                (event) => PostData.fromFirestore(event),
              );
      return postData;
    } on Exception {
      throw GetPostData();
    }
  }

  @override
  Future<void> handleDeletePost({
    required String ownerId,
    required String postId,
  }) async {
    try {
      await _firestoreData.collection('posts').doc(postId).get().then(
        (doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        },
      );

      await _firestoreData
          .collection('users')
          .doc(ownerId)
          .collection('feedItems')
          .where('postId', isEqualTo: postId)
          .get()
          .then(
            // ignore: avoid_function_literals_in_foreach_calls
            (value) => value.docs.forEach(
              (element) {
                if (element.exists) {
                  element.reference.delete();
                }
              },
            ),
          );

      await _firestoreData
          .collection('comments')
          .doc(postId)
          .collection('comments')
          .get()
          .then(
            // ignore: avoid_function_literals_in_foreach_calls
            (value) => value.docs.forEach(
              (element) {
                if (element.exists) {
                  element.reference.delete();
                }
              },
            ),
          );
    } on Exception {
      throw HandleDeletePost();
    }
  }

  @override
  Future<void> handleLikePost({
    required String ownerId,
    required String postId,
    required String mediaURL,
    required UserData currentUserData,
  }) async {
    try {
      final currentTimestamp = DateTime.now();
      await _firestoreData.collection('posts').doc(postId).update(
        <String, bool>{
          'likes.${currentUserData.uid}': true,
        },
      );

      /* if like made by other user */
      final isNotPostOwner = currentUserData.uid != ownerId;
      if (isNotPostOwner) {
        await _firestoreData
            .collection('users')
            .doc(ownerId)
            .collection('feedItems')
            .doc(postId)
            .set(
          <String, dynamic>{
            'type': 'like',
            'username': currentUserData.username,
            'userId': currentUserData.uid,
            'userProfileImg': currentUserData.uploadPhoto,
            'postId': postId,
            'mediaURL': mediaURL,
            'timestamp': currentTimestamp,
          },
        );
      }
    } on Exception {
      throw HandleLikePost();
    }
  }

  @override
  Future<void> handleDislikePost({
    required String ownerId,
    required String postId,
    required UserData currentUserData,
  }) async {
    try {
      await _firestoreData.collection('posts').doc(postId).update(
        <String, bool>{
          'likes.${currentUserData.uid}': false,
        },
      );
      final isNotPostOwner = currentUserData.uid != ownerId;
      if (isNotPostOwner) {
        await _firestoreData
            .collection('users')
            .doc(ownerId)
            .collection('feedItems')
            .doc(postId)
            .get()
            .then(
          (doc) {
            if (doc.exists) {
              doc.reference.delete();
            }
          },
        );
      }
    } on Exception {
      throw HandleDislikePost();
    }
  }

  @override
  Stream<List<PostData>> get getTimeline {
    try {
      final getPosts = _firestoreData
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots();
      final timelinePostsData = getPosts.map(
        (event) => event.docs
            .map(
              (e) => PostData.fromFirestore(e),
            )
            .toList(),
      );
      return timelinePostsData;
    } on Exception {
      throw GetTimeline();
    }
  }

  @override
  Stream<List<CommentData>> getComments({
    required String postId,
  }) {
    try {
      final getCommentsData = _firestoreData
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => CommentData.fromFirestore(e),
                )
                .toList(),
          );
      return getCommentsData;
    } on Exception {
      throw GetComments();
    }
  }

  @override
  Future<void> addComment({
    required UserData currentUserData,
    required PostData postData,
    required String textComment,
  }) async {
    try {
      final currentTimestamp = DateTime.now();
      await _firestoreData
          .collection('posts')
          .doc(postData.postId)
          .collection('comments')
          .add(
        <String, dynamic>{
          'username': currentUserData.username,
          'comment': textComment,
          'timestamp': currentTimestamp,
          'avatarURL': currentUserData.uploadPhoto,
          'userId': currentUserData.uid,
        },
      );
      final isNotPostOwner = postData.ownerId != currentUserData.uid;
      if (isNotPostOwner) {
        await _firestoreData
            .collection('users')
            .doc(postData.ownerId)
            .collection('feedItems')
            .add(
          <String, dynamic>{
            'type': 'comment',
            'commentData': textComment,
            'timestamp': currentTimestamp,
            'postId': postData.postId,
            'userId': currentUserData.uid,
            'username': currentUserData.username,
            'userProfileImage': currentUserData.uploadPhoto,
            'mediaURL': postData.mediaURL,
          },
        );
      }
    } on Exception {
      throw AddComment();
    }
  }

  @override
  Stream<List<ConversationData>> getConversationsList(String currentUserId) {
    final getConversationData = _firestoreData
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .orderBy('recentMessage.sentAt', descending: true)
        .snapshots();
    final conversationData = getConversationData.map(
      (event) => event.docs
          .map(
            (e) => ConversationData.fromFirestore(e),
          )
          .toList(),
    );
    return conversationData;
  }

  @override
  Future<String> openMessage({
    required UserData profileData,
    required UserData currentUserData,
  }) async {
    final userArray = <String>[(profileData.uid), (currentUserData.uid)]
      ..sort();
    final privateChatList = await _firestoreData
        .collection('chats')
        .where(
          'members',
          whereIn: [userArray],
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => e,
              )
              .toList(),
        );
    final isPrivateChatListEmpty = privateChatList.isEmpty;
    if (isPrivateChatListEmpty) {
      final currentTimestamp = DateTime.now();
      final chatId = await _firestoreData
          .collection('chats')
          .add(
            {
              'createdAt': currentTimestamp,
              'createdBy': currentUserData.uid,
              'id': '',
              'members': userArray,
              'membersData': {
                currentUserData.uid: {
                  'username': currentUserData.username,
                  'profilePicture': currentUserData.uploadPhoto,
                },
                profileData.uid: {
                  'username': profileData.username,
                  'profilePicture': profileData.uploadPhoto,
                }
              },
            } as Map<String, dynamic>,
          )
          .then(
        (value) async {
          await value.set(
            {'id': value.id} as Map<String, dynamic>,
            SetOptions(merge: true),
          );

          return value.id;
        },
      );
      return chatId;
    } else {
      return privateChatList.first.id;
    }
  }

  @override
  Stream<List<MessageData>> getMessagesById(String chatId) {
    final messagesRef = _firestoreData
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
    final messagesData = messagesRef.map(
      (event) => event.docs
          .map(
            (e) => MessageData.fromFirestore(e),
          )
          .toList(),
    );
    return messagesData;
  }

  @override
  Future<void> sendMessage({
    required String messageText,
    required String chatId,
    required UserData currentUserData,
  }) async {
    final currentTimestamp = DateTime.now();
    final newBatch = _firestoreData.batch()
      ..update(
        _firestoreData.collection('chats').doc(chatId),
        {
          'recentMessage': {
            'messageText': messageText,
            'sentAt': currentTimestamp,
            'sentBy': {
              'id': currentUserData.uid,
              'profile': currentUserData.uploadPhoto,
              'username': currentUserData.username,
            },
          },
        } as Map<String, dynamic>,
      )
      ..set(
        _firestoreData
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(),
        {
          'messageText': messageText,
          'sentAt': currentTimestamp,
          'sentBy': {
            'id': currentUserData.uid,
            'profile': currentUserData.uploadPhoto,
            'username': currentUserData.username,
          },
        },
      );
    await newBatch.commit();
  }

  @override
  void dispose() {}
}

class SaveDetailsFromAuthentication implements Exception {}

class SaveUserDetails implements Exception {}

class IsProfileComplete implements Exception {}

class UploadPostData implements Exception {}

class GetProfileData implements Exception {}

class GetProfilePostsData implements Exception {}

class UpdateProfileData implements Exception {}

class HandleSearch implements Exception {}

class GetActivityFeed implements Exception {}

class GetPostData implements Exception {}

class HandleDeletePost implements Exception {}

class HandleLikePost implements Exception {}

class HandleDislikePost implements Exception {}

class IsUsernameExist implements Exception {}

class GetTimeline implements Exception {}

class GetComments implements Exception {}

class AddComment implements Exception {}
