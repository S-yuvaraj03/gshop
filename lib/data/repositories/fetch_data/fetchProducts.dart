import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';


Future<List<Shop>> fetchShops() async {
  List<Shop> allShops = [];
  try {
    final QuerySnapshot shopsSnapshot = await FirebaseFirestore.instance.collection('shops').get();

    for (var shopDoc in shopsSnapshot.docs) {
      final shopData = shopDoc.data() as Map<String, dynamic>;
      // ignore: unused_local_variable
      final List<dynamic> productsList = shopData['products'] ?? [];

      final shop = Shop.fromMap(shopData);
      allShops.add(shop);
    }
  } catch (e) {
    // print('Error fetching shops: $e');
  }
  return allShops;
}
