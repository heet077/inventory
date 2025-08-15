import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tool_item.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';
import 'tool_card.dart';
import 'add_tool_dialog.dart';
import 'edit_tool_dialog.dart';
import 'issue_tool_dialog.dart';

class ToolsTabContent extends StatelessWidget {
  const ToolsTabContent({super.key});

  Future<void> _showAddToolDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return const AddToolDialog();
      },
    );
  }

  Future<void> _showEditToolDialog(BuildContext context, ToolItem tool) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditToolDialog(tool: tool);
      },
    );
  }

  Future<void> _showIssueToolDialog(BuildContext context, ToolItem tool) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return IssueToolDialog(tool: tool);
      },
    );
  }

  void _showMoreOptionsBottomSheet(BuildContext context, ToolItem tool) {
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
                title: Text('Edit Tool', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showEditToolDialog(context, tool);
                },
              ),
              ListTile(
                leading: Icon(Icons.outbox, color: AppColors.primary),
                title: Text('Issue Tool', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showIssueToolDialog(context, tool);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.primary),
                title: Text('Delete Tool', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  inventoryService.deleteTool(tool.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${tool.name} deleted.'),
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
              hintText: 'Search tools...',
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.secondary.withValues(alpha: 0.5), // Beige with opacity
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (String value) {
              // Search logic for tools can be implemented here
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: () => _showAddToolDialog(context),
            icon: Icon(Icons.add, color: AppColors.secondary),
            label: Text('Add Tool', style: TextStyle(color: AppColors.secondary)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Teal
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: inventoryService.tools.length,
              itemBuilder: (BuildContext context, int index) {
                final ToolItem tool = inventoryService.tools[index];
                return ToolCard(
                  tool: tool,
                  onEdit: () => _showEditToolDialog(context, tool),
                  onIssue: () => _showIssueToolDialog(context, tool),
                  onMoreOptions: () => _showMoreOptionsBottomSheet(context, tool),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 