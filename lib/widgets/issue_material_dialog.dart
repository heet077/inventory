import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/material_item.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';

class IssueMaterialDialog extends StatefulWidget {
  final MaterialItem material;

  const IssueMaterialDialog({super.key, required this.material});

  @override
  State<IssueMaterialDialog> createState() => _IssueMaterialDialogState();
}

class _IssueMaterialDialogState extends State<IssueMaterialDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantityController;
  late final TextEditingController _issuedToController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _issuedToController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _issuedToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InventoryService inventoryService = Provider.of<InventoryService>(context, listen: false);

    return AlertDialog(
      title: Text('Issue ${widget.material.name}', style: Theme.of(context).textTheme.titleLarge),
      backgroundColor: AppColors.secondary, // Beige
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity to issue',
                  hintText: 'Current: ${widget.material.quantity}',
                  border: const OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a quantity to issue.';
                  }
                  final int? parsedQuantity = int.tryParse(value.trim());
                  if (parsedQuantity == null || parsedQuantity <= 0) {
                    return 'Please enter a valid positive number.';
                  }
                  if (parsedQuantity > widget.material.quantity) {
                    return 'Cannot issue more than available (${widget.material.quantity}).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _issuedToController,
                decoration: const InputDecoration(
                  labelText: 'Issued To (Name/Department)',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter who the material is issued to.';
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
          child: Text('Issue', style: TextStyle(color: AppColors.secondary)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final int quantityToIssue = int.parse(_quantityController.text.trim());
              final String issuedTo = _issuedToController.text.trim();
              inventoryService.issueMaterial(widget.material.id, quantityToIssue, issuedTo);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
} 