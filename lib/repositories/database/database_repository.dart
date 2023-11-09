import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '/widgets/widgets.dart';
import '/repositories/repositories.dart';
import '/models/models.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    logger.i('Getting user images from DB');
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Stream<Chat> getChat(String chatId) {
    logger.i('Calling getChat');
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) {
      return Chat.fromJson(
        doc.data() as Map<String, dynamic>,
        id: doc.id,
      );
    });
  }

  @override
  Stream<List<Chat>> getChats(String userId) {
    logger.i('Calling getChats');
    return _firebaseFirestore
        .collection('chats')
        .where('userIds', arrayContains: userId)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => Chat.fromJson(doc.data(), id: doc.id))
          .toList();
    });
  }

  @override
  Stream<List<User>> getUsers(User user) {
    logger.i("Calling getUsers");
    logger.i(_firebaseFirestore
        .collection('users')
        .where('giver', isEqualTo: user.giver == false ? true : false)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    }).first);
    return _firebaseFirestore
        .collection('users')
        .where('giver', isEqualTo: user.giver == false ? true : false)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<User>> getAllUsers(User user) {
    return _firebaseFirestore.collection('users').snapshots().map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> updateUserSwipe(
    String userId,
    String matchId,
    bool isSwipeRight,
  ) async {
    logger.i('Calling UpdateUserSwipe');
    if (isSwipeRight) {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeRight': FieldValue.arrayUnion([matchId])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeLeft': FieldValue.arrayUnion([matchId])
      });
    }
  }

  @override
  Future<void> updateUserMatch(
    String userId,
    String matchId,
  ) async {
    logger.i('Calling updateUserMatch');
    // Create a document in the chat collection to store the messages.
    String chatId = await _firebaseFirestore.collection('chats').add({
      'userIds': [userId, matchId],
      'messages': [],
    }).then((value) => value.id);

    // Add the match into the current user document.
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayUnion([
        {
          'matchId': matchId,
          'chatId': chatId,
        }
      ])
    });
    // Add the match into the other user document.
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayUnion([
        {
          'matchId': userId,
          'chatId': chatId,
        }
      ])
    });
  }

  @override
  Future<void> createUser(User user) async {
    logger.i('Calling CreateUSer');
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) async {
    logger.i('Calling UpdateUser');
    logger.i('HERE USER: $user');
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then(
          (value) => logger.i('User document updated with $user'),
        );
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    logger.i('Calling UpdateUserPictures');
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }

  @override
  Stream<List<Match>> getMatches(User user) {
    logger.i('Calling getMatches');
    return Rx.combineLatest3(
      getUser(user.id!),
      getChats(user.id!),
      getAllUsers(user),
      (
        User user,
        List<Chat> userChats,
        List<User> otherUsers,
      ) {
        return otherUsers.where(
          (otherUser) {
            List<String> matches = user.matches!
                .map((match) => match['matchId'] as String)
                .toList();
            return matches.contains(otherUser.id);
          },
        ).map(
          (matchUser) {
            Chat chat = userChats.where(
              (chat) {
                return chat.userIds.contains(matchUser.id) &
                    chat.userIds.contains(user.id);
              },
            ).first;

            return Match(
              userId: user.id!,
              matchUser: matchUser,
              chat: chat,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Stream<List<User>> getUsersToSwipe(User user) {
    logger.i('Calling getUsersToSwipe');
    return Rx.combineLatest2(
      getUser(user.id!),
      getUsers(user),
      (
        User currentUser,
        List<User> users,
      ) {
        // logger.i("USERS RETURNED: ${users.where(
        //   (user) {
        //     bool isCurrentUser = user.id == currentUser.id;
        //     bool wasSwipedLeft = currentUser.swipeLeft!.contains(user.id);
        //     bool wasSwipedRight = currentUser.swipeRight!.contains(user.id);
        //     bool isMatch = currentUser.matches!.contains(user.id);
        //     bool isWithinAgeRange =
        //         user.age >= currentUser.ageRangePreference![0] &&
        //             user.age <= currentUser.ageRangePreference![1];
        //     bool isGenderPreferred =
        //         currentUser.genderPreference!.contains(user.gender);
        //     logger.i("CURRENT $isCurrentUser");
        //     logger.i("LEFT $wasSwipedLeft");
        //     logger.i("RIGHT $wasSwipedRight");
        //     logger.i("MATCH $isMatch");
        //     logger.i("AGE $isWithinAgeRange");
        //     logger.i("GENDER $isGenderPreferred");
        //     if (isCurrentUser ||
        //         wasSwipedLeft ||
        //         wasSwipedRight ||
        //         isMatch ||
        //         !isWithinAgeRange ||
        //         !isGenderPreferred) return false;
        //     return true;
        //   },
        // ).toList()}");
        logger.i("Almost Finished getUsersToSwipe");
        return users.where(
          (user) {
            bool isCurrentUser = user.id == currentUser.id;
            bool wasSwipedLeft = currentUser.swipeLeft!.contains(user.id);
            bool wasSwipedRight = currentUser.swipeRight!.contains(user.id);
            bool isMatch = currentUser.matches!
                .any((match) => match['matchId'] == user.id);
            bool isWithinAgeRange =
                user.age >= currentUser.ageRangePreference![0] &&
                    user.age <= currentUser.ageRangePreference![1];
            bool isGenderPreferred =
                currentUser.genderPreference!.contains(user.gender);

            if (isCurrentUser ||
                wasSwipedLeft ||
                wasSwipedRight ||
                isMatch ||
                !isWithinAgeRange ||
                !isGenderPreferred) return false;
            return true;
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> addMessage(String chatId, Message message) {
    logger.i('Calling addMessage');
    return _firebaseFirestore.collection('chats').doc(chatId).update({
      'messages': FieldValue.arrayUnion(
        [
          Message(
            senderId: message.senderId,
            receiverId: message.receiverId,
            message: message.message,
            dateTime: message.dateTime,
            timeString: message.timeString,
          ).toJson()
        ],
      )
    });
  }

  @override
  Future<void> deleteMatch(String chatId, String userId, String matchId) async {
    logger.i('Calling deleteMatch');
    // Remove the match from the user document
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayRemove([
        {'matchId': matchId, 'chatId': chatId}
      ])
    });

    // Remove the match from the user document
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayRemove([
        {'matchId': userId, 'chatId': chatId}
      ])
    });

    // Delete the chat document
    await _firebaseFirestore.collection('chats').doc(chatId).delete();
  }
}
