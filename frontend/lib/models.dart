class WardrobeItem {
  final int id;
  final String name;
  final String category;
  final String color;
  final String style;
  final String status;
  final bool favorite;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.style,
    required this.status,
    required this.favorite,
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      color: json['color'] ?? 'unknown',
      style: json['style'] ?? 'casual',
      status: json['status'] ?? 'clean',
      favorite: json['favorite'] ?? false,
    );
  }
}

class OutfitSuggestion {
  final String title;
  final List<int> itemIds;
  final double score;
  final String reason;

  OutfitSuggestion({
    required this.title,
    required this.itemIds,
    required this.score,
    required this.reason,
  });

  factory OutfitSuggestion.fromJson(Map<String, dynamic> json) {
    return OutfitSuggestion(
      title: json['title'] ?? 'Outfit',
      itemIds: List<int>.from(json['item_ids'] ?? []),
      score: (json['score'] ?? 0.0).toDouble(),
      reason: json['reason'] ?? 'Gut passend',
    );
  }
}
