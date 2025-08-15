import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/material_item.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';
import 'material_card.dart';
import 'add_material_dialog.dart';
import 'edit_material_dialog.dart';
import 'issue_material_dialog.dart';

class MaterialsTabContent extends StatelessWidget {
  const MaterialsTabContent({super.key});

  Future<void> _showAddMaterialDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return const AddMaterialDialog();
      },
    );
  }

  Future<void> _showEditMaterialDialog(BuildContext context, MaterialItem material) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditMaterialDialog(material: material);
      },
    );
  }

  Future<void> _showIssueMaterialDialog(BuildContext context, MaterialItem material) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return IssueMaterialDialog(material: material);
      },
    );
  }

  void _showMoreOptionsBottomSheet(BuildContext context, MaterialItem material) {
    final InventoryService inventoryService = Provider.of<InventoryService>(context, listen: false);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.secondary, // Beige
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit, color: AppColors.primary),
                title: Text('Edit Material', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showEditMaterialDialog(context, material);
                },
              ),
              ListTile(
                leading: Icon(Icons.outbox, color: AppColors.primary),
                title: Text('Issue Material', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showIssueMaterialDialog(context, material);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.primary),
                title: Text('Delete Material', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  inventoryService.deleteMaterial(material.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${material.name} deleted.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final InventoryService inventoryService = Provider.of<InventoryService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Search materials...',
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.secondary.withOpacity(0.5), // Beige with opacity
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (String value) {
              // Search logic can be implemented here
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: () => _showAddMaterialDialog(context),
            icon: Icon(Icons.add, color: AppColors.secondary),
            label: Text('Add Material', style: TextStyle(color: AppColors.secondary)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Teal
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: inventoryService.materials.length,
              itemBuilder: (BuildContext context, int index) {
                final MaterialItem material = inventoryService.materials[index];
                return MaterialCard(
                  material: material,
                  onEdit: () => _showEditMaterialDialog(context, material),
                  onIssue: () => _showIssueMaterialDialog(context, material),
                  onMoreOptions: () => _showMoreOptionsBottomSheet(context, material),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 