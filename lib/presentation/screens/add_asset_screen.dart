import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/entities/asset_type.dart';
import 'package:fin_track/presentation/providers/asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  final Asset? assetToEdit;
  final AssetType? initialType; // New: For adding from category

  const AddAssetScreen({super.key, this.assetToEdit, this.initialType});

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  late AssetType _selectedType;
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _currentPriceController; // New
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final asset = widget.assetToEdit;
    _selectedType = asset?.type ?? widget.initialType ?? AssetType.stock;
    _nameController = TextEditingController(text: asset?.name);
    _quantityController = TextEditingController(text: asset?.quantity.toString());
    _purchasePriceController = TextEditingController(text: asset?.purchasePrice.toString());
    _currentPriceController = TextEditingController(text: asset?.currentPrice.toString());
    _selectedDate = asset?.purchaseDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _currentPriceController.dispose();
    super.dispose();
  }

  Future<void> _saveAsset() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final quantity = double.parse(_quantityController.text);
      final purchasePrice = double.parse(_purchasePriceController.text);
      final currentPrice = _currentPriceController.text.isNotEmpty 
          ? double.parse(_currentPriceController.text) 
          : purchasePrice; // Default to purchase price if empty

      final id = widget.assetToEdit?.id ?? const Uuid().v4();

      final newAsset = Asset(
        id: id,
        name: name,
        type: _selectedType,
        quantity: quantity,
        purchasePrice: purchasePrice,
        currentPrice: currentPrice,
        purchaseDate: _selectedDate,
      );

      await ref.read(assetRepositoryProvider).addAsset(newAsset);

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assetToEdit == null ? 'Add Investment' : 'Edit Investment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<AssetType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Asset Type',
                  border: OutlineInputBorder(),
                ),
                items: AssetType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Asset Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(
                    child: TextFormField(
                      controller: _purchasePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Buy Price (Per Unit)',
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _currentPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Current Price (Per Unit)',
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                        hintText: 'Optional',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Purchase Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saveAsset,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.assetToEdit == null ? 'Save Investment' : 'Update Investment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
