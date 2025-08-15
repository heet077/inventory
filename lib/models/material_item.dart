class MaterialItem {
  final String id;
  final String name;
  final String unit;
  final int quantity;
  final String description;

  MaterialItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.description,
  });

  MaterialItem copyWith({
    String? id,
    String? name,
    String? unit,
    int? quantity,
    String? description,
  }) {
    return MaterialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }
} 