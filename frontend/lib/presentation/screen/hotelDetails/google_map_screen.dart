part of 'hotel_detail_import.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late HomeDetailController controller;

  @override
  void initState() {
    controller = Get.put(HomeDetailController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(
        title: MyString.hotelLocation,
      ),
      body: FutureBuilder<BitmapDescriptor>(
        future: BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          MyImages.markerIcon,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Placeholder while loading the marker icon
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error handling
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.detail.lat, controller.detail.lng),
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("1"),
                position: LatLng(controller.detail.lat, controller.detail.lng),
                infoWindow:
                    InfoWindow(title: controller.detail.location.toString()),
                icon: snapshot.data!,
              ),
            },
            onMapCreated: (GoogleMapController googleMapController) {},
          );
        },
      ),
    );
  }
}
