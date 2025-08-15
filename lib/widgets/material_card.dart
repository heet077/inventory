import 'package:flutter/material.dart';
import '../models/material_item.dart';
import '../utils/app_colors.dart';

class MaterialCard extends StatelessWidget {
  final MaterialItem material;
  final VoidCallback onEdit;
  final VoidCallback onIssue;
  final VoidCallback onMoreOptions;

  const MaterialCard({
    super.key,
    required this.material,
    required this.onEdit,
    required this.onIssue,
    required this.onMoreOptions,
  });

  Color _getQuantityColor(int quantity) {
    if (quantity < 50) {
      return Colors.redAccent; // Red for low quantity
    } else if (quantity < 200) {
      return AppColors.primary.withOpacity(0.7); // Teal with opacity for medium
    } else {
      return AppColors.primary; // Teal for high quantity
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      // Card color is set in ThemeData (AppColors.secondary)
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    material.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  'Qty: ${material.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: _getQuantityColor(material.quantity),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: AppColors.primary),
                  onPressed: onMoreOptions,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              'Unit: ${material.unit}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4.0),
            Text(
              material.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Teal
                      foregroundColor: AppColors.secondary, // Beige
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onIssue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.8), // Slightly lighter Teal
                      foregroundColor: AppColors.secondary, // Beige
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Issue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 