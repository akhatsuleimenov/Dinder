import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class Match extends Equatable {
  final String userId;
  final User matchedUser;
  final List<Chat>? chat;

  const Match({
    required this.userId,
    required this.matchedUser,
    this.chat,
  });

  static Match fromSnapshot(
    DocumentSnapshot snap,
    String userId,
  ) {
    Match match = Match(
      userId: userId,
      matchedUser: User.fromSnapshot(snap),
    );
    return match;
  }

  Match copyWith({
    String? userId,
    User? matchedUser,
    List<Chat>? chat,
  }) {
    return Match(
      userId: userId ?? this.userId,
      matchedUser: matchedUser ?? this.matchedUser,
      chat: chat ?? this.chat,
    );
  }

  @override
  List<Object?> get props => [userId, matchedUser, chat];
}
