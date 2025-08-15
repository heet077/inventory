import 'package:flutter/material.dart';
import '../models/index.dart';

class InventoryService extends ChangeNotifier {
  final List<MaterialItem> _materials;
  final List<ToolItem> _tools;
  final List<IssuanceRecord> _issuanceRecords;

  InventoryService()
      : _materials = [
          MaterialItem(
            id: 'steel_rods_1',
            name: 'Steel Rods',
            unit: 'Pieces',
            quantity: 150,
            description: 'High-grade steel for construction',
          ),
          MaterialItem(
            id: 'cement_bags_1',
            name: 'Cement Bags',
            unit: 'Bags',
            quantity: 25,
            description: 'Portland cement 50kg bags',
          ),
          MaterialItem(
            id: 'wire_mesh_1',
            name: 'Wire Mesh',
            unit: 'Meters',
            quantity: 500,
            description: '6mm reinforcement mesh',
          ),
        ],
        _tools = [
          ToolItem(
            id: 'hammer_1',
            name: 'Claw Hammer',
            quantity: 10,
            status: 'Available',
            location: 'Tool Shed A',
            description: 'Standard claw hammer for general use',
          ),
          ToolItem(
            id: 'drill_2',
            name: 'Cordless Drill',
            quantity: 3,
            status: 'In Use',
            location: 'Job Site 1',
            description: '18V cordless drill with multiple bits',
          ),
          ToolItem(
            id: 'saw_3',
            name: 'Circular Saw',
            quantity: 2,
            status: 'Available',
            location: 'Tool Shed B',
            description: 'Heavy-duty circular saw for wood cutting',
          ),
        ],
        _issuanceRecords = [];

  List<MaterialItem> get materials => List.unmodifiable(_materials);
  List<ToolItem> get tools => List.unmodifiable(_tools);
  List<IssuanceRecord> get issuanceRecords => List.unmodifiable(_issuanceRecords);

  // Get current (active) records - items that are still issued
  List<IssuanceRecord> get currentRecords {
    return _issuanceRecords.where((record) {
      // Check if this item has been fully returned
      return !isItemFullyReturned(record.itemId, record.itemType);
    }).toList();
  }

  // Get past (completed) records - items that have been fully returned
  List<IssuanceRecord> get pastRecords {
    return _issuanceRecords.where((record) {
      // Check if this item has been fully returned
      return isItemFullyReturned(record.itemId, record.itemType);
    }).toList();
  }

  // Check if an item has been fully returned
  bool isItemFullyReturned(String itemId, String itemType) {
    final issuedRecords = _issuanceRecords.where((record) => 
      record.itemId == itemId && record.itemType == itemType && record.quantityIssued > 0
    ).toList();
    
    final returnedRecords = _issuanceRecords.where((record) => 
      record.itemId == itemId && record.itemType == itemType && record.quantityIssued < 0
    ).toList();

    int totalIssued = issuedRecords.fold(0, (sum, record) => sum + record.quantityIssued);
    int totalReturned = returnedRecords.fold(0, (sum, record) => sum + record.quantityIssued.abs());

    return totalReturned >= totalIssued;
  }

  // Get remaining quantity for an item
  int getRemainingQuantity(String itemId, String itemType) {
    final issuedRecords = _issuanceRecords.where((record) => 
      record.itemId == itemId && record.itemType == itemType && record.quantityIssued > 0
    ).toList();
    
    final returnedRecords = _issuanceRecords.where((record) => 
      record.itemId == itemId && record.itemType == itemType && record.quantityIssued < 0
    ).toList();

    int totalIssued = issuedRecords.fold(0, (sum, record) => sum + record.quantityIssued);
    int totalReturned = returnedRecords.fold(0, (sum, record) => sum + record.quantityIssued.abs());

    return totalIssued - totalReturned;
  }

  void addMaterial(MaterialItem newItem) {
    _materials.add(newItem);
    notifyListeners();
  }

  void updateMaterial(String id, {String? name, String? unit, int? quantity, String? description}) {
    final index = _materials.indexWhere((item) => item.id == id);
    if (index != -1) {
      _materials[index] = _materials[index].copyWith(
        name: name,
        unit: unit,
        quantity: quantity,
        description: description,
      );
      notifyListeners();
    }
  }

  void issueMaterial(String id, int quantityToIssue, String issuedTo) {
    final index = _materials.indexWhere((item) => item.id == id);
    if (index != -1) {
      final currentItem = _materials[index];
      final newQuantity = currentItem.quantity - quantityToIssue;
      if (newQuantity >= 0) {
        _materials[index] = currentItem.copyWith(quantity: newQuantity);
        _addIssuanceRecord(
          itemId: currentItem.id,
          itemName: currentItem.name,
          itemType: 'Material',
          quantityIssued: quantityToIssue,
          issuedTo: issuedTo,
        );
        notifyListeners();
      }
    }
  }

  void deleteMaterial(String id) {
    _materials.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void addTool(ToolItem newItem) {
    _tools.add(newItem);
    notifyListeners();
  }

  void updateTool(String id,
      {String? name, int? quantity, String? status, String? location, String? description}) {
    final index = _tools.indexWhere((item) => item.id == id);
    if (index != -1) {
      _tools[index] = _tools[index].copyWith(
        name: name,
        quantity: quantity,
        status: status,
        location: location,
        description: description,
      );
      notifyListeners();
    }
  }

  void issueTool(String id, int quantityToIssue, String issuedTo) {
    final index = _tools.indexWhere((item) => item.id == id);
    if (index != -1) {
      final currentItem = _tools[index];
      final newQuantity = currentItem.quantity - quantityToIssue;
      if (newQuantity >= 0) {
        _tools[index] = currentItem.copyWith(quantity: newQuantity);
        _addIssuanceRecord(
          itemId: currentItem.id,
          itemName: currentItem.name,
          itemType: 'Tool',
          quantityIssued: quantityToIssue,
          issuedTo: issuedTo,
        );
        notifyListeners();
      }
    }
  }

  void deleteTool(String id) {
    _tools.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void returnItem(String itemId, String itemType, int quantityToReturn, String returnedBy) {
    if (quantityToReturn <= 0) return;
    
    // Check if we can return this quantity
    final remainingQuantity = getRemainingQuantity(itemId, itemType);
    if (quantityToReturn > remainingQuantity) {
      return; // Cannot return more than what was issued
    }

    if (itemType == 'Material') {
      final index = _materials.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final currentItem = _materials[index];
        _materials[index] = currentItem.copyWith(quantity: currentItem.quantity + quantityToReturn);
        _addIssuanceRecord(
          itemId: currentItem.id,
          itemName: currentItem.name,
          itemType: 'Material',
          quantityIssued: -quantityToReturn,
          issuedTo: returnedBy,
        );
        notifyListeners();
      }
    } else if (itemType == 'Tool') {
      final index = _tools.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final currentItem = _tools[index];
        _tools[index] = currentItem.copyWith(quantity: currentItem.quantity + quantityToReturn);
        _addIssuanceRecord(
          itemId: currentItem.id,
          itemName: currentItem.name,
          itemType: 'Tool',
          quantityIssued: -quantityToReturn,
          issuedTo: returnedBy,
        );
        notifyListeners();
      }
    }
  }

  void _addIssuanceRecord({
    required String itemId,
    required String itemName,
    required String itemType,
    required int quantityIssued,
    required String issuedTo,
  }) {
    _issuanceRecords.add(
      IssuanceRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        itemId: itemId,
        itemName: itemName,
        itemType: itemType,
        quantityIssued: quantityIssued,
        issuedTo: issuedTo,
        timestamp: DateTime.now(),
      ),
    );
  }
} 