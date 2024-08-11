import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';

Future<List<Product>> fetchProducts() async {
  List<Product> allProducts = [];
  try {
    final QuerySnapshot shopsSnapshot = await FirebaseFirestore.instance.collection('shops').get();
    // print('Shops fetched: ${shopsSnapshot.docs.length}');

    for (var shopDoc in shopsSnapshot.docs) {
      final shopData = shopDoc.data() as Map<String, dynamic>;
      final List<dynamic> productsList = shopData['products'] ?? [];
      
      for (var productData in productsList) {
        // print('Product data: $productData');
        allProducts.add(Product.fromMap(productData as Map<String, dynamic>));
      }
    }
    // print('Total products fetched: ${allProducts.length}');
  } catch (e) {
    // print('Error fetching products: $e');
  }
  return allProducts;
}
