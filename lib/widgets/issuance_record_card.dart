import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/issuance_record.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';

class IssuanceRecordCard extends StatelessWidget {
  final IssuanceRecord record;

  const IssuanceRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final inventoryService = Provider.of<InventoryService>(context, listen: false);
    int? quantityToReturn;
    String returnedBy = '';

    // Get remaining quantity for this item
    final remainingQuantity = inventoryService.getRemainingQuantity(record.itemId, record.itemType);
    final isFullyReturned = inventoryService.isItemFullyReturned(record.itemId, record.itemType);

    return Card(
      color: AppColors.secondary, // Beige
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: ListTile(
        title: Text(
          record.itemName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${record.itemType}'),
            if (record.quantityIssued > 0) ...[
              Text('Quantity Issued: +${record.quantityIssued}'),
              Text('Remaining: $remainingQuantity'),
            ] else ...[
              Text('Quantity Returned: ${record.quantityIssued.abs()}'),
            ],
            Text('To/From: ${record.issuedTo}'),
            Text('Time: ${record.timestamp.toLocal().toString().split('.')[0]}'),
            if (remainingQuantity > 0 && !isFullyReturned)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Active - $remainingQuantity remaining',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isFullyReturned)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: remainingQuantity > 0 && !isFullyReturned
            ? ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Return Item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Remaining quantity: $remainingQuantity'),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Quantity to Return'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        quantityToReturn = int.tryParse(value) ?? 0;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Returned By'),
                      onChanged: (value) => returnedBy = value,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (quantityToReturn != null && 
                          quantityToReturn! > 0 && 
                          quantityToReturn! <= remainingQuantity && 
                          returnedBy.isNotEmpty) {
                        inventoryService.returnItem(record.itemId, record.itemType, quantityToReturn!, returnedBy);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter valid quantity (1-$remainingQuantity) and returned by name'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Return'),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // Teal
            foregroundColor: AppColors.secondary, // Beige
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Return'),
        )
            : null, // No return button for fully returned items
      ),
    );
  }
} 