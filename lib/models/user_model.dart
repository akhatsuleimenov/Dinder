import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final int age;
  final String gender;
  final List<dynamic> imageUrls;
  // final List<dynamic> interests;
  final String bio;
  final String major;
  final bool giver;
  final List<String>? swipeLeft;
  final List<String>? swipeRight;
  final List<Map<String, dynamic>>? matches;
  final List<String>? genderPreference;
  final List<int>? ageRangePreference;

  const User({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.imageUrls,
    required this.bio,
    // required this.interests,
    required this.major,
    required this.giver,
    this.swipeLeft,
    this.swipeRight,
    this.matches,
    this.genderPreference,
    this.ageRangePreference,
  });

  static const User empty = User(
    id: '',
    name: '',
    age: 0,
    gender: '',
    imageUrls: [],
    major: '',
    // interests: [],
    bio: '',
    giver: false,
    swipeLeft: [],
    swipeRight: [],
    matches: [],
    ageRangePreference: [18, 24],
    genderPreference: ['Female'],
  );

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        imageUrls,
        bio,
        major,
        // interests,
        giver,
        swipeLeft,
        swipeRight,
        matches,
        genderPreference,
        ageRangePreference,
      ];

  static User fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>?;
    List<String> userGenderPreference = [''];
    List<int> userAgeRangePreference = [];

    if (data != null) {
      userGenderPreference = (data['genderPreference'] == null)
          ? ['Male']
          : (data['genderPreference'] as List)
              .map((gender) => gender as String)
              .toList();
      userAgeRangePreference = (data['ageRangePreference'] == null)
          ? [18, 24]
          : (data['ageRangePreference'] as List)
              .map((age) => age as int)
              .toList();
    }
    User user = User(
      id: snap.id,
      name: snap['name'],
      age: snap['age'],
      gender: snap['gender'],
      imageUrls: snap['imageUrls'],
      bio: snap['bio'],
      // interests: snap['interests'],
      major: snap['major'],
      giver: snap['giver'],
      swipeLeft: ((snap['swipeLeft'] ?? []) as List)
          .map((swipeLeft) => swipeLeft as String)
          .toList(),
      swipeRight: ((snap['swipeRight'] ?? []) as List)
          .map((swipeRight) => swipeRight as String)
          .toList(),
      matches: ((snap['matches'] ?? []) as List)
          .map((matches) => matches as Map<String, dynamic>)
          .toList(),
      genderPreference: userGenderPreference,
      ageRangePreference: userAgeRangePreference,
    );
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'imageUrls': imageUrls,
      // 'interests': interests,
      'bio': bio,
      'major': major,
      'giver': giver,
      'swipeLeft': swipeLeft,
      'swipeRight': swipeRight,
      'matches': matches,
      'genderPreference': genderPreference,
      'ageRangePreference': ageRangePreference,
    };
  }

  User copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    List<dynamic>? imageUrls,
    // List<dynamic>? interests,
    String? bio,
    String? major,
    bool? giver,
    List<String>? swipeLeft,
    List<String>? swipeRight,
    List<Map<String, dynamic>>? matches,
    List<String>? genderPreference,
    List<int>? ageRangePreference,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imageUrls: imageUrls ?? this.imageUrls,
      // interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      major: major ?? this.major,
      giver: giver ?? this.giver,
      genderPreference: genderPreference ?? this.genderPreference,
      ageRangePreference: ageRangePreference ?? this.ageRangePreference,
    );
  }
}
