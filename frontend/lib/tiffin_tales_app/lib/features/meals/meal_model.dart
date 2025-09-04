class Meal {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String homemakerName;
  final String type; // e.g., Daily, Combo, Homemaker
  final String cuisine;
  final String vegType;
  final double price;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.homemakerName,
    required this.type,
    required this.cuisine,
    required this.vegType,
    required this.price,
  });

  factory Meal.fromMap(String id, Map<String, dynamic> data) {
    return Meal(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      homemakerName: data['homemakerName'] ?? '',
      type: data['type'] ?? '',
      cuisine: data['cuisine'] ?? '',
      vegType: data['vegType'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
} 