import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProductPage.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:gshop/utils/formatters/Changecase.dart';

class KGridview extends StatelessWidget {
  final List<Product> products;
  final Shop? shop;

  const KGridview({Key? key, required this.products, this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kwidth = MediaQuery.of(context).size.width;
    final categories = _groupByCategory(products);

    // Determine the number of products per row based on screen width
    int kcrossAxisCount;
    double kchildAspectRatio;

    if (kwidth >= 1200) {
      kcrossAxisCount = 4; // Large screens
      kchildAspectRatio = 3 / 4; // Adjust ratio as needed
    } else if (kwidth >= 800) {
      kcrossAxisCount = 3; // Medium screens
      kchildAspectRatio = 2.5 / 3; // Adjust ratio as needed
    } else {
      kcrossAxisCount = 2; // Small screens
      kchildAspectRatio = 2 / 3; // Adjust ratio as needed
    }

    return SingleChildScrollView(
      child: Column(
        children: categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key.capitalize(),
                  style: TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kcrossAxisCount, // Number of products per row
                  childAspectRatio: kchildAspectRatio, // Adjust the aspect ratio as needed
                ),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final product = entry.value[index];
                  return ProductPage(product: product, shop: shop, allProducts: products);
                },
                shrinkWrap: true, // To prevent scrolling issues
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the grid view
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Map<String, List<Product>> _groupByCategory(List<Product> products) {
    final Map<String, List<Product>> categories = {};
    for (var product in products) {
      categories.putIfAbsent(product.product_cateogory, () => []).add(product);
    }
    return categories;
  }
}
