import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tool_item.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';

class AddToolDialog extends StatefulWidget {
  const AddToolDialog({super.key});

  @override
  State<AddToolDialog> createState() => _AddToolDialogState();
}

class _AddToolDialogState extends State<AddToolDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _statusController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InventoryService inventoryService = Provider.of<InventoryService>(context, listen: false);

    return AlertDialog(
      title: Text('Add New Tool', style: Theme.of(context).textTheme.titleLarge),
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
                  labelText: 'Tool Name',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a tool name.';
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
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: 'Status (e.g., Available, In Use)',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a status.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location.';
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
          child: Text('Add', style: TextStyle(color: AppColors.secondary)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final String name = _nameController.text.trim();
              final int quantity = int.parse(_quantityController.text.trim());
              final String status = _statusController.text.trim();
              final String location = _locationController.text.trim();
              final String description = _descriptionController.text.trim();

              inventoryService.addTool(
                ToolItem(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: name,
                  quantity: quantity,
                  status: status,
                  location: location,
                  description: description,
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
} 