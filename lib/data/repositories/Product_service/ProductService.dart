import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProductAvailability(String productId, int purchasedQuantity) async {
    try {
      final QuerySnapshot shopsSnapshot = await _firestore.collection('shops').get();
      
      for (var shopDoc in shopsSnapshot.docs) {
        final shopData = shopDoc.data() as Map<String, dynamic>;
        final List<dynamic> productsList = shopData['products'] ?? [];

        // Find the product in the embedded list
        for (var productData in productsList) {
          if (productData['product_id'] == productId) {
            int availableCount = productData['Available_count'];
            int updatedCount = availableCount - purchasedQuantity;

            // Ensure available count doesn't go negative
            if (updatedCount < 0) {
              updatedCount = 0;
            }

            // Update the product's available count
            productData['Available_count'] = updatedCount;

            // Break after finding the product
            break;
          }
        }

        // Update the entire product list back to Firestore
        await _firestore.collection('shops').doc(shopDoc.id).update({
          'products': productsList,
        });

        print('Product availability updated successfully');
      }
    } catch (e) {
      print('Failed to update product availability: $e');
    }
  }
}
