class ToolItem {
  final String id;
  final String name;
  final int quantity;
  final String status; // e.g., 'Available', 'In Use', 'Under Maintenance'
  final String location;
  final String description;

  ToolItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.status,
    required this.location,
    required this.description,
  });

  ToolItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? status,
    String? location,
    String? description,
  }) {
    return ToolItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
} 