import 'package:gshop/features/shop/model/ProductModel.dart';

class Shop {
  final String shopid;
  final String shopename;
  final String shopaddress;
  final String shopcontactno;
  final List<String> shopeimages;
  final String openingtime;
  final String closingtime;
  final String locationLink;
  final bool isOnline;
  final bool? isDeliveryAvailable;
  final List<Product> products;

  Shop({
    required this.shopid,
    required this.shopename,
    required this.shopaddress,
    required this.shopcontactno,
    required this.shopeimages,
    required this.openingtime,
    required this.closingtime,
    required this.locationLink,
    required this.isOnline,
    this.isDeliveryAvailable,
    required this.products,
  });

  factory Shop.fromMap(Map<String, dynamic> data) {
    return Shop(
      shopid: data['shopid'] ?? '',
      shopename: data['shopename'] ?? '',
      shopaddress: data['shopaddress'] ?? '',
      shopcontactno: data['shopcontactno'] ?? '',
      shopeimages: List<String>.from(data['shopeimages'] ?? []),
      openingtime: data['openingtime'] ?? '',
      closingtime: data['closingtime'] ?? '',
      locationLink: data['googleMapLink'] ?? '',
      isOnline: data['isOnline'] ?? false,
      isDeliveryAvailable: data['deliveryAvailable'],
      products: (data['products'] as List)
          .map((item) => Product.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopid': shopid,
      'shopename': shopename,
      'shopaddress': shopaddress,
      'shopcontactno': shopcontactno,
      'shopeimages': shopeimages,
      'openingtime': openingtime,
      'closingtime': closingtime,
      'googleMapLink': locationLink,
      'isOnline': isOnline,
      'deliveryAvailable': isDeliveryAvailable,
      'products': products.map((item) => item.toMap()).toList(),
    };
  }
}