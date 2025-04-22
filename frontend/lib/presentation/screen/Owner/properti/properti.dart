part of 'properti_import.dart';

class Properti extends StatefulWidget {
  final String? status;
  const Properti({super.key, this.status});

  @override
  State<Properti> createState() => _PropertiState();
}

class _PropertiState extends State<Properti> {
  late PropertiControllers controller;

  @override
  void initState() {
    controller = Get.put(PropertiControllers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo dan ikon notifikasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hommie',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.brown,
                    ),
                  ),
                  Icon(Icons.notifications_none_outlined, color: Colors.black),
                ],
              ),
              const SizedBox(height: 20),

              // Search Field
              TextField(
                decoration: InputDecoration(
                  hintText: "ingin cari apa?",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 24),

              // Judul section
              const Text(
                "Properti Milik Anda",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Tombol tambah properti
              ElevatedButton.icon(
                onPressed: () {
                  controller.tambahProperti();
                },
                icon: const Icon(Icons.add, color: Colors.green),
                label: const Text(
                  'Tambah Properti',
                  style: TextStyle(color: Colors.green),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 16),

              // Menampilkan daftar properti
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.propertiList.isEmpty) {
                  return const Text("Belum ada properti.");
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.propertiList.length,
                    itemBuilder: (context, index) {
                      final properti = controller.propertiList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1FAF9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              properti.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/kost_anthony.jpg');
                              },
                            ),
                          ),
                          title: Text(
                            properti.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: InkWell(
                            onTap: () => controller.lihatDetailProperti(properti),
                            child: const Text(
                              'Lihat Selengkapnya',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
