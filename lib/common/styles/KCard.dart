import 'package:flutter/material.dart';
import 'package:gshop/utils/constant/sizes.dart';

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  ProductCard(
      {super.key,
      required this.KImage,
      required this.Kcategory,
      required this.Ktitle,
      required this.KText1,
      required this.KText2,
      required this.KText3, 
      this.KColor
      });

  final String KImage;
  final String Kcategory;
  final String Ktitle;
  final String KText1;
  String KText2;
  final String KText3;
  final KColor;

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: KColor,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: kheight*0.2,
                      width: double.infinity,
                      child: Image.network(
                        KImage, // Replace with your image URL
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 8.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'OFFERS AVAILABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: TSizes.fontSm,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      Kcategory,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: TSizes.fontSm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Ktitle.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: TSizes.fontLg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      Text(
                        KText1,
                        style: TextStyle(
                          fontSize: TSizes.fontMd,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: KText2 == 'Open' ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              KText2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: TSizes.fontMd,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: TSizes.iconSm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    KText3,
                    style: TextStyle(
                      fontSize: TSizes.fontMd,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
