import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NearbyResultPage extends StatelessWidget {
  const NearbyResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi sekitar saya sekarang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Kategori
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryChip(label: "Semua", isSelected: true),
                  SizedBox(width: 8),
                  _CategoryChip(label: "Kost"),
                  SizedBox(width: 8),
                  _CategoryChip(label: "Homestay"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Daftar Kost
            _LocationItem(
              title: "Kost Races",
              address: "Sikolusma, Tagulacid",
              rating: 5.0,
              price: "Rp 400.000 / bulan",
              imagePath: "assets/images/samplekost.png",
            ),

            const Divider(height: 24),

            _LocationItem(
              title: "Kost Anthony",
              address: "Naphurokki, Balige",
              rating: 5.0,
              price: "Rp 400.000 / bulan",
              imagePath: "assets/images/samplekost.png",
            ),

            const Divider(height: 24),

            _LocationItem(
              title: "Kost Tarigan",
              address: "Sikolusma, Tagulacid",
              price: "Rp 500.000 / bulan",
              imagePath: "assets/images/hotelDetail/image1.png",
            ),

            const Divider(height: 24),

            _LocationItem(
              title: "Kost Dialog",
              address: "Soposaurus, Balige",
              price: "Rp 800.000 / bulan",
              imagePath: "assets/images/samplekost.png",
            ),

            const Divider(height: 24),

            // Daftar Homestay
            _LocationItem(
              title: "Aylina Homestay",
              address: "Lumbon (Bilibri), Balige",
              imagePath: "assets/images/samplekost.png",
            ),

            const Divider(height: 24),

            _LocationItem(
              title: "Homestay Martahan",
              address: "Lumbon (Bilibri), Balige",
              imagePath: "assets/images/samplekost.png",
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk kategori chip
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.2)
          : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// Widget untuk item lokasi
class _LocationItem extends StatelessWidget {
  final String title;
  final String address;
  final double? rating;
  final String? price;
  final String imagePath;

  const _LocationItem({
    required this.title,
    required this.address,
    required this.imagePath,
    this.rating,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        if (rating != null || price != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (rating != null) ...[
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating!.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 12),
              ],
              if (price != null)
                Text(
                  price!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
