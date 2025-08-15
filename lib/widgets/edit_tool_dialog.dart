import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tool_item.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';

class EditToolDialog extends StatefulWidget {
  final ToolItem tool;

  const EditToolDialog({super.key, required this.tool});

  @override
  State<EditToolDialog> createState() => _EditToolDialogState();
}

class _EditToolDialogState extends State<EditToolDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _statusController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tool.name);
    _quantityController = TextEditingController(text: widget.tool.quantity.toString());
    _statusController = TextEditingController(text: widget.tool.status);
    _locationController = TextEditingController(text: widget.tool.location);
    _descriptionController = TextEditingController(text: widget.tool.description);
  }

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
    final inventoryService = Provider.of<InventoryService>(context, listen: false);

    return AlertDialog(
      title: Text('Edit ${widget.tool.name}', style: Theme.of(context).textTheme.titleLarge),
      backgroundColor: AppColors.secondary,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListBody(
            children: <Widget>[
              _buildTextField('Tool Name', _nameController),
              const SizedBox(height: 12.0),
              _buildNumberField('Quantity', _quantityController),
              const SizedBox(height: 12.0),
              _buildTextField('Status', _statusController),
              const SizedBox(height: 12.0),
              _buildTextField('Location', _locationController),
              const SizedBox(height: 12.0),
              _buildTextField('Description', _descriptionController, maxLines: 3),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: TextStyle(color: AppColors.primary)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save', style: TextStyle(color: AppColors.secondary)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              inventoryService.updateTool(
                widget.tool.id,
                name: _nameController.text.trim(),
                quantity: int.parse(_quantityController.text.trim()),
                status: _statusController.text.trim(),
                location: _locationController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      maxLines: maxLines,
      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter $label.' : null,
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Please enter $label.';
        final int? parsed = int.tryParse(value.trim());
        if (parsed == null || parsed < 0) return 'Enter a valid non-negative number.';
        return null;
      },
    );
  }
} 