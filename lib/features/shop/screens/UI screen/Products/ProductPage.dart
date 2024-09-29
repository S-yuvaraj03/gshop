import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProductDetailPage.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:gshop/utils/formatters/starratings.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  final List<Shop>? shops;
  final List<Product> allProducts;

  ProductPage({
    Key? key,
    required this.product,
    this.shops, 
    required this.allProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offerPercent = ((product.product_price - product.product_offerprice) /
            product.product_price *
            100).round();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product, shops: shops, allProducts: allProducts,),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side:BorderSide(color: Colors.grey, width: 0.5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 135,
                width: 200,
                child: Image.network(
                  product.imageLink,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.product_name,
                    style: TextStyle(fontSize: TSizes.fontMd),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('₹${product.product_offerprice.round()}',
                      style: TextStyle(
                        fontSize: TSizes.fontLg,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      )),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('${product.product_price.round()}',
                      style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: TSizes.fontMd,
                      color: Colors.black,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text('${offerPercent}%off',
                      style: TextStyle(
                          fontSize: TSizes.fontMd,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      StarRating(rating: product.product_rating, color: Colors.yellow.shade800, starCount: 5, iconsize: TSizes.iconSm ),
                      Text(
                        ' ${product.product_rating} (ratings)',
                        style: TextStyle(fontSize: TSizes.fontSm),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
