/// User model
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final DateTime createdAt;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.createdAt,
    this.isVerified = false,
  });
}

/// Mood check-in data
class MoodCheckIn {
  final String id;
  final String userId;
  final int moodScore; // 1-5 atau emoji-based
  final String moodEmoji; // 😢😔😐😊😄
  final List<String> factors; // faktor yang mempengaruhi
  final String? notes;
  final DateTime timestamp;

  MoodCheckIn({
    required this.id,
    required this.userId,
    required this.moodScore,
    required this.moodEmoji,
    required this.factors,
    this.notes,
    required this.timestamp,
  });
}

/// Chat message
class ChatMessage {
  final String id;
  final String userId;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final String? messageType; // text, suggestion, exercise

  ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.messageType,
  });
}

/// BISINDO video entry
class BisindoVideo {
  final String id;
  final String title;
  final String description;
  final String category;
  final String videoUrl;
  final String? thumbnailUrl;
  final int durationSeconds;

  BisindoVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.durationSeconds,
  });
}

/// Taman Pikiran (virtual plant) state
class TamanPikiran {
  final String id;
  final String userId;
  final int growthLevel; // 0-4: Tunas, Bertumbuh, Bermekar, Rimbun
  final int totalActivities; // total check-ins/exercises
  final DateTime lastWateredAt;
  final List<String> achievements; // badges

  TamanPikiran({
    required this.id,
    required this.userId,
    this.growthLevel = 0,
    this.totalActivities = 0,
    DateTime? lastWateredAt,
    this.achievements = const [],
  }) : lastWateredAt = lastWateredAt ?? DateTime.now();

  String get growthStage {
    switch (growthLevel) {
      case 0:
        return 'Tunas';
      case 1:
        return 'Bertumbuh';
      case 2:
        return 'Bermekar';
      case 3:
        return 'Rimbun';
      default:
        return 'Tunas';
    }
  }
}
