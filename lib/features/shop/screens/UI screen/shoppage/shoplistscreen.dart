import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gshop/common/styles/KCard.dart';
import 'package:gshop/common/widgets/appDrawer.dart';
import 'package:gshop/common/widgets/appbar.dart';
import 'package:gshop/data/repositories/fetch_data/fetchProducts.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/shop_bloc/shop_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/shoppage/shopdetailscreen.dart';

class ShopListScreen extends StatefulWidget {
  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  String? scannedShopId;

  // Method to scan QR code and update the scannedShopId state
  Future<void> scanQRCode(BuildContext context) async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', // Color of the scanning line
        'Cancel', // Text for the cancel button
        true, // Show the flash icon
        ScanMode.QR, // Set scan mode to QR
      );

      if (result != '-1') {
        print('Scanned QR Code: $result');

        setState(() {
          scannedShopId = result;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning QR code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopBloc(fetchShops)..add(FetchShops()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GshopAppbar(),
        drawer: Appdrawer(),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ShopListBody(scannedShopId: scannedShopId),
                ),
              ],
            ),
            Positioned(
              top: 2.0,
              right: 16.0,
              child: ElevatedButton.icon(
                icon: Icon(Icons.qr_code_scanner),
                label: Text("Scan QR"),
                onPressed: () => scanQRCode(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ShopListBody extends StatelessWidget {
  final String? scannedShopId;

  const ShopListBody({Key? key, this.scannedShopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ShopError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ShopLoaded) {
          List<Shop> shops = state.shops;

          // Filter shops based on scannedShopId if it is not null
          if (scannedShopId != null && scannedShopId!.isNotEmpty) {
            shops = shops.where((shop) => shop.shopid == scannedShopId).toList();
          }

          return shops.isEmpty
              ? Center(child: Text('No shops found for this QR code'))
              : ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    Shop shop = shops[index];
                    return GestureDetector(
                      child: ProductCard(
                        KColor: Colors.white,
                        KImage: shop.shopeimages.first,
                        Kcategory: "shopid: ${shop.shopid}",
                        Ktitle: shop.shopename,
                        KText1: shop.isDeliveryAvailable == true
                            ? 'Online shopping'
                            : 'In-store shopping',
                        KText2: shop.isOnline == true ? 'Open' : 'Close',
                        KText3: "${shop.openingtime}--${shop.closingtime}",
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailScreen(shop: shop),
                          ),
                        );
                      },
                    );
                  },
                );
        }
        return Center(child: Text('No shops found'));
      },
    );
  }
}
