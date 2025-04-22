import 'package:flutter/material.dart';
import 'package:front/core/utils/constants.dart';

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback? onTap;

  const PropertyCard({
    Key? key,
    required this.property,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bagian Gambar
            SizedBox(
              width: double.infinity,
              height: 150.0,
              child: property['image'] != null && property['image'].isNotEmpty
                  ? Image.network(
                      '${Constants.baseUrl}/storage/${property['image']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Gambar Gagal Dimuat'));
                      },
                    )
                  : const Center(child: Text('Tidak Ada Gambar')),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    property['name'] ?? 'Nama Properti',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    property['address'] ?? 'Alamat Properti',
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Rp ${property['price']?.toString() ?? 'Harga'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.home_outlined, color: Colors.grey, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        property['property_type'] != null && property['property_type']['name'] != null
                            ? (property['property_type']['name'] as String)
                            : 'Tipe',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(width: 16.0),
                      if (property['capacity'] != null) ...[
                        const Icon(Icons.people_outline, color: Colors.grey, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text('${property['capacity']} Orang', style: const TextStyle(fontSize: 14.0)),
                      ],
                      if (property['total_rooms'] != null) ...[
                        const SizedBox(width: 16.0),
                        const Icon(Icons.king_bed_outlined, color: Colors.grey, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text('${property['total_rooms']} Kamar', style: const TextStyle(fontSize: 14.0)),
                      ],
                      if (property['total_units'] != null) ...[
                        const SizedBox(width: 16.0),
                        const Icon(Icons.holiday_village_outlined, color: Colors.grey, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text('${property['total_units']} Unit', style: const TextStyle(fontSize: 14.0)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}