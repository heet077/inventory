import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/material_item.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';

class EditMaterialDialog extends StatefulWidget {
  final MaterialItem material;

  const EditMaterialDialog({super.key, required this.material});

  @override
  State<EditMaterialDialog> createState() => _EditMaterialDialogState();
}

class _EditMaterialDialogState extends State<EditMaterialDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.material.name);
    _unitController = TextEditingController(text: widget.material.unit);
    _quantityController = TextEditingController(text: widget.material.quantity.toString());
    _descriptionController = TextEditingController(text: widget.material.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InventoryService inventoryService = Provider.of<InventoryService>(context, listen: false);

    return AlertDialog(
      title: Text('Edit ${widget.material.name}', style: Theme.of(context).textTheme.titleLarge),
      backgroundColor: AppColors.secondary, // Beige
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListBody(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Material Name',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a material name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a unit.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a quantity.';
                  }
                  final int? parsedQuantity = int.tryParse(value.trim());
                  if (parsedQuantity == null || parsedQuantity < 0) {
                    return 'Please enter a valid non-negative number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: TextStyle(color: AppColors.primary)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Save', style: TextStyle(color: AppColors.secondary)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final String name = _nameController.text.trim();
              final String unit = _unitController.text.trim();
              final int quantity = int.parse(_quantityController.text.trim());
              final String description = _descriptionController.text.trim();

              inventoryService.updateMaterial(
                widget.material.id,
                name: name,
                unit: unit,
                quantity: quantity,
                description: description,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
} 