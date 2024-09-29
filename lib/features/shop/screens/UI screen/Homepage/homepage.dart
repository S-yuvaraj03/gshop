import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/common/widgets/appDrawer.dart';
import 'package:gshop/common/widgets/appbar.dart';
import 'package:gshop/data/repositories/fetch_data/fetchProducts.dart';
import 'package:gshop/data/repositories/fetch_data/fetchdata.dart';
// import 'package:gshop/features/shop/model/ProductModel.dart';
// import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Product_bloc/product_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProuctGridview.dart';
import 'package:gshop/features/shop/screens/UI%20screen/shop_bloc/shop_bloc.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GshopAppbar(),
      drawer: Appdrawer(),
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductBloc(fetchProducts)..add(FetchProducts()),
          ),
          BlocProvider(
            create: (context) => ShopBloc(fetchShops)..add(FetchShops()),
          ),
        ],
        child: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double kwidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: kwidth*0.5,
            child: Image.asset("assets/images/GshopAd.png"),
          ),
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, shopState) {
              if (shopState is ShopLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (shopState is ShopError) {
                return Center(child: Text('Error: ${shopState.message}'));
              } else if (shopState is ShopLoaded) {
                final shop = shopState.shops.isNotEmpty ? shopState.shops : null;
                return BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, productState) {
                    if (productState is ProductLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (productState is ProductError) {
                      return Center(child: Text('Error: ${productState.message}'));
                    } else if (productState is ProductLoaded) {
                      final products = productState.products;
                      return KGridview(products: products, shops: shop);
                    }
                    return Center(child: Text('No products available'));
                  },
                );
              }
              return Center(child: Text('No shops available'));
            },
          ),
        ],
      ),
    );
  }
}
