import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProuctGridview.dart';
import 'package:gshop/features/shop/screens/UI%20screen/shoppage/shopsearchscreen.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailScreen extends StatelessWidget {
  final Shop shop;

  const ShopDetailScreen({Key? key, required this.shop}) : super(key: key);

  void _launchMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$query&travelmode=driving");
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _launchShopUrl() async {
    String url = shop.locationLink;

    // Check if the URL starts with 'http://' or 'https://'
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final parsedUrl = Uri.parse(url);

    if (await canLaunchUrl(parsedUrl)) {
      await launchUrl(parsedUrl);
    } else {
      throw 'Could not open the shop URL.';
    }
  }

  void _launchCall(String contactNo) async {
    final telUrl = Uri.parse('tel:$contactNo');
    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    } else {
      throw 'Could not place the call.';
    }
  }

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;

    print("Shop data: ${shop}");
    print("Is Online: ${shop.isOnline}");
    return Scaffold(
      appBar: AppBar(
        title: Text(shop.shopename),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShopSearchScreen(products: shop.products),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: kheight*0.3,
                child: Image.network(
                  shop.shopeimages.first,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
              ),
            ),
            shop.isOnline != true
                ? Card(
                    elevation: 0, // Remove the default elevation
                    margin: EdgeInsets.all(16),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(5, 5),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.store_rounded,
                                size: TSizes.iconLg,
                                color: Colors.grey.shade800,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                shop.shopename,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: TSizes.Lg,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Shop Timings: ( ${shop.openingtime} -- ${shop.closingtime})',
                            style: TextStyle(
                              fontSize: TSizes.fontMd,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Address: ${shop.shopaddress}',
                            style: TextStyle(
                              fontSize: TSizes.fontMd,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _launchMap(shop.shopaddress);
                                },
                                label: Text(
                                  "Directions",
                                  style: TextStyle(color: Colors.blue.shade800),
                                ),
                                icon: Icon(
                                  Icons.directions,
                                  color: Colors.blue.shade800,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _launchCall(shop.shopcontactno);
                                },
                                label: Text(
                                  "Call",
                                  style: TextStyle(color: Colors.blue.shade800),
                                ),
                                icon: Icon(
                                  Icons.phone_rounded,
                                  color: Colors.blue.shade800,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Card(
                  elevation: 0,
                  margin: EdgeInsets.all(16),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: Offset(5, 5),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              CupertinoIcons.globe,
                              color: Colors.grey.shade800,
                              size: TSizes.iconMd,
                            ),
                            SizedBox(width: 8), // Add some spacing between icon and text
                            Text(
                              shop.shopename.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: TSizes.Lg,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(width: 4), // Add some spacing between icon and text
                            Text(
                              'Online Delivery Available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'To know more about their offers & deals, please visit their official website...',
                                style: TextStyle(
                                  fontSize: TSizes.fontSm,
                                  color: Colors.grey.shade800,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                _launchShopUrl();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.transparent, // Remove shadow
                              ),
                              child: Text(
                                'Visit site',
                                style: TextStyle(
                                  fontSize: TSizes.fontMd,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

            KGridview(products: shop.products, shops: [],),
          ],
        ),
      ),
    );
  }
}
