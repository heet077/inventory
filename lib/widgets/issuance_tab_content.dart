import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_service.dart';
import '../utils/app_colors.dart';
import 'issuance_record_card.dart';

class IssuanceTabContent extends StatefulWidget {
  const IssuanceTabContent({super.key});

  @override
  State<IssuanceTabContent> createState() => _IssuanceTabContentState();
}

class _IssuanceTabContentState extends State<IssuanceTabContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryService = Provider.of<InventoryService>(context);

    // Get current and past records using service methods
    final currentRecords = inventoryService.currentRecords;
    final pastRecords = inventoryService.pastRecords;

    return Column(
      children: [
        Container(
          color: AppColors.primary,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.secondary.withOpacity(0.6),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Current'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Current Tab
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: currentRecords.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No active records',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Issued items will appear here',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: currentRecords.length,
                        itemBuilder: (context, index) {
                          final record = currentRecords[index];
                          return IssuanceRecordCard(record: record);
                        },
                      ),
              ),
              // Past Tab
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: pastRecords.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No past records',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Returned items will appear here',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: pastRecords.length,
                        itemBuilder: (context, index) {
                          final record = pastRecords[index];
                          return IssuanceRecordCard(record: record);
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 