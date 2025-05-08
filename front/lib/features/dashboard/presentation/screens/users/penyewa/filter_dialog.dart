import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final String initialPropertyType;
  final String initialPriceRange;
  final String initialLocation;

  const FilterDialog({
    Key? key,
    this.initialPropertyType = 'Semua',
    this.initialPriceRange = 'Semua',
    this.initialLocation = 'Semua',
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String _selectedPropertyType;
  late String _selectedPriceRange;
  late String _selectedLocation;

  final List<String> _propertyTypes = ['Semua', 'Kost', 'Homestay'];
  final List<String> _priceRanges = [
    'Semua',
    '< Rp1jt',
    'Rp1jt - Rp3jt',
    'Rp3jt - Rp5jt',
    '> Rp5jt'
  ];
  final List<String> _locations = [
    'Semua',
    'Terdekat',
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Yogyakarta',
    'Bali'
  ];

  @override
  void initState() {
    super.initState();
    _selectedPropertyType = widget.initialPropertyType;
    _selectedPriceRange = widget.initialPriceRange;
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Pencarian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tipe Properti
            const Text(
              'Tipe Properti',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _propertyTypes.map((type) {
                return _buildFilterChip(
                  type,
                  _selectedPropertyType == type,
                  () {
                    setState(() {
                      _selectedPropertyType = type;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // Rentang Harga
            const Text(
              'Rentang Harga',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _priceRanges.map((price) {
                return _buildFilterChip(
                  price,
                  _selectedPriceRange == price,
                  () {
                    setState(() {
                      _selectedPriceRange = price;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // Lokasi
            const Text(
              'Lokasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _locations.map((location) {
                return _buildFilterChip(
                  location,
                  _selectedLocation == location,
                  () {
                    setState(() {
                      _selectedLocation = location;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Tombol Terapkan dan Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedPropertyType = 'Semua';
                      _selectedPriceRange = 'Semua';
                      _selectedLocation = 'Semua';
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'propertyType': _selectedPropertyType,
                      'priceRange': _selectedPriceRange,
                      'location': _selectedLocation,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Terapkan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
