part of 'home_import.dart';

class HomeController extends GetxController {
   final ThemeController themeController = Get.put(ThemeController());

   RxInt selectedButton = 0.obs;
   RxBool bookMark = false.obs;
   RxInt selectedItem = 0.obs;
   RxBool isLoading = true.obs;
   RxString passingStatus = 'Recommended'.obs;

   RxList<Detail> homeDetails = <Detail>[].obs;
   List<Detail> filterListView = <Detail>[].obs;
   RxList<RecentlyBook> recentlyBooked = <RecentlyBook>[].obs;

    @override
    void onInit() {
        getRecentlyBooked();
      super.onInit();
   }

   void filterList(String status) {
     filterListView.clear();
     filterListView.addAll(homeDetails.where((element) => element.status == status));
   }

   Future<List<Detail>> getHomeDetail() async {
     isLoading.value = true;
     try{
       String jsonData = await rootBundle.loadString("assets/data/homeDetails.json");
       dynamic data = json.decode(jsonData);
       List<dynamic> jsonArray = data['details'];
       homeDetails.clear();
       for (int i = 0; i < jsonArray.length; i++) {
         homeDetails.add(Detail.fromJson(jsonArray[i]));
       }
       filterList(passingStatus.value);
       isLoading.value = false;
       return homeDetails;
     } catch(e) {
       isLoading.value = false;
       return [];
     }
   }

   Future<List<RecentlyBook>> getRecentlyBooked() async {
      String jsonData = await rootBundle.loadString("assets/data/recentlyBookHotel.json");
      dynamic data = json.decode(jsonData);
      List<dynamic> jsonArray = data['recentlyBook'];
      for (int i = 0 ; i < jsonArray.length ; i++) {
         recentlyBooked.add(RecentlyBook.fromJson(jsonArray[i]));
      }
      return recentlyBooked;
   }
}