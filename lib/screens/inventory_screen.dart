import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/index.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Teal
        foregroundColor: AppColors.secondary, // Beige
        title: const Text('Inventory'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to MyHomePage
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondary, // Beige
          labelColor: AppColors.secondary, // Beige
          unselectedLabelColor: AppColors.secondary.withOpacity(0.6), // Beige with opacity
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const <Widget>[
            Tab(text: 'Materials'),
            Tab(text: 'Tools'),
            Tab(text: 'Issuance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          MaterialsTabContent(),
          ToolsTabContent(),
          IssuanceTabContent(),
        ],
      ),
    );
  }
} 