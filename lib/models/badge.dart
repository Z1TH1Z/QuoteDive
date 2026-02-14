class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final BadgeType type;
  final int requirement;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.requirement,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      type: BadgeType.values.firstWhere(
        (e) => e.toString() == 'BadgeType.${json['type']}',
        orElse: () => BadgeType.streak,
      ),
      requirement: json['requirement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.toString().split('.').last,
      'requirement': requirement,
    };
  }
}

enum BadgeType {
  streak,
  quotes,
  philosophers,
  points,
  category,
}

// Predefined badges
class BadgeDefinitions {
  static final List<Badge> allBadges = [
    // Beginner badges
    Badge(
      id: 'first_quote',
      name: 'First Steps',
      description: 'Read your first quote',
      icon: '🌱',
      type: BadgeType.quotes,
      requirement: 1,
    ),
    Badge(
      id: 'quotes_5',
      name: 'Curious Mind',
      description: 'Read 5 quotes',
      icon: '🤔',
      type: BadgeType.quotes,
      requirement: 5,
    ),
    Badge(
      id: 'quotes_10',
      name: 'Knowledge Seeker',
      description: 'Read 10 quotes',
      icon: '📖',
      type: BadgeType.quotes,
      requirement: 10,
    ),
    Badge(
      id: 'quotes_20',
      name: 'Wisdom Collector',
      description: 'Read all 20 quotes',
      icon: '📚',
      type: BadgeType.quotes,
      requirement: 20,
    ),
    
    // Streak badges
    Badge(
      id: 'streak_3',
      name: 'Committed',
      description: 'Maintain a 3-day streak',
      icon: '🔥',
      type: BadgeType.streak,
      requirement: 3,
    ),
    Badge(
      id: 'streak_7',
      name: 'Disciplined',
      description: 'Maintain a 7-day streak',
      icon: '💪',
      type: BadgeType.streak,
      requirement: 7,
    ),
    Badge(
      id: 'streak_14',
      name: 'Dedicated',
      description: 'Maintain a 14-day streak',
      icon: '⚡',
      type: BadgeType.streak,
      requirement: 14,
    ),
    Badge(
      id: 'streak_30',
      name: 'Master of Habit',
      description: 'Maintain a 30-day streak',
      icon: '👑',
      type: BadgeType.streak,
      requirement: 30,
    ),
    
    // Philosopher badges
    Badge(
      id: 'philosopher_1',
      name: 'Student',
      description: 'Learn about your first philosopher',
      icon: '🎓',
      type: BadgeType.philosophers,
      requirement: 1,
    ),
    Badge(
      id: 'philosopher_3',
      name: 'Explorer',
      description: 'Learn about 3 different philosophers',
      icon: '🗺️',
      type: BadgeType.philosophers,
      requirement: 3,
    ),
    Badge(
      id: 'philosopher_5',
      name: 'Scholar',
      description: 'Learn about 5 different philosophers',
      icon: '📚',
      type: BadgeType.philosophers,
      requirement: 5,
    ),
    Badge(
      id: 'philosopher_7',
      name: 'Philosopher',
      description: 'Learn about all 7 philosophers',
      icon: '🧠',
      type: BadgeType.philosophers,
      requirement: 7,
    ),
    
    // Points badges
    Badge(
      id: 'points_50',
      name: 'Beginner',
      description: 'Earn 50 points',
      icon: '⭐',
      type: BadgeType.points,
      requirement: 50,
    ),
    Badge(
      id: 'points_100',
      name: 'Seeker',
      description: 'Earn 100 points',
      icon: '🌟',
      type: BadgeType.points,
      requirement: 100,
    ),
    Badge(
      id: 'points_500',
      name: 'Sage',
      description: 'Earn 500 points',
      icon: '🎖️',
      type: BadgeType.points,
      requirement: 500,
    ),
    Badge(
      id: 'points_1000',
      name: 'Master',
      description: 'Earn 1000 points',
      icon: '🏆',
      type: BadgeType.points,
      requirement: 1000,
    ),
    
    // Category badges
    Badge(
      id: 'stoic_5',
      name: 'Stoic Starter',
      description: 'Read 5 Stoic quotes',
      icon: '🛡️',
      type: BadgeType.category,
      requirement: 5,
    ),
    Badge(
      id: 'existentialist_5',
      name: 'Existentialist',
      description: 'Read 5 Existentialist quotes',
      icon: '🎭',
      type: BadgeType.category,
      requirement: 5,
    ),
    Badge(
      id: 'eastern_5',
      name: 'Eastern Wisdom',
      description: 'Read 5 Eastern Philosophy quotes',
      icon: '☯️',
      type: BadgeType.category,
      requirement: 5,
    ),
  ];
}
