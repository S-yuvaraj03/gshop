import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProductDetailPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Wishlist_bloc/wishlist_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';

class WishlistPage extends StatelessWidget {
  final List<Product>? allProducts;
  final Shop? shop;

  const WishlistPage({
    Key? key,
    this.allProducts,
    this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.wishlist.isEmpty) {
            return Center(child: Text('No items in wishlist'));
          }

          return ListView.builder(
            itemCount: state.wishlist.length,
            itemBuilder: (context, index) {
              final product = state.wishlist[index];

              return ListTile(
                leading: Image.network(product.imageLink, width: kwidth*0.2),
                title: Text(product.product_name),
                subtitle: Text('₹${product.product_offerprice.round()}'),
                trailing: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red, size: TSizes.iconLg),
                  onPressed: () {
                    context.read<WishlistBloc>().add(RemoveProductFromWishlist(product));
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        product: product,
                        shop: shop, // Pass null or shop if available
                        allProducts: allProducts ?? [], // Pass an empty list or allProducts if available
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
