// class CartSelectedItem {
//   final Product product;
//   final int quantity;

//   CartSelectedItem({required this.product, required this.quantity});

//   Map<String, dynamic> toMap() {
//     return {
//       'product': product.toMap(),
//       'quantity': quantity,
//     };
//   }

//   factory CartSelectedItem.fromMap(Map<String, dynamic> map) {
//     return CartSelectedItem(
//       product: Product.fromMap(map['product']),
//       quantity: map['quantity'],
//     );
//   }
// }

// class Product {
//   final String product_name;
//   final String imageLink;

//   Product({required this.product_name, required this.imageLink});

//   Map<String, dynamic> toMap() {
//     return {
//       'product_name': product_name,
//       'imageLink': imageLink,
//     };
//   }

//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       product_name: map['product_name'],
//       imageLink: map['imageLink'],
//     );
//   }
// }
