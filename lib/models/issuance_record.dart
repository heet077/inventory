class IssuanceRecord {
  final String id;
  final String itemId;
  final String itemName;
  final String itemType;
  final int quantityIssued;
  final String issuedTo;
  final DateTime timestamp;

  IssuanceRecord({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemType,
    required this.quantityIssued,
    required this.issuedTo,
    required this.timestamp,
  });
} 