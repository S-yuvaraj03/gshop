import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/CompareProductPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Wishlist_bloc/wishlist_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/CartPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProuctGridview.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:gshop/utils/formatters/starratings.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Shop? shop;
  final List<Product> allProducts;

  const ProductDetailPage({
    Key? key,
    required this.product,
    this.shop,
    required this.allProducts,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Product> selectedProducts = []; // Track selected products for comparison
  bool isWishlisted = false; // Track if the product is wishlisted
  String locationMessage = 'Current location of the user';
  late String lat;
  late String long;
  TextEditingController _addressController = TextEditingController();

  late GoogleMapController _googleMapController;
  Marker? _selectedLocationMarker;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission userlocationpermission =
        await Geolocator.checkPermission();
    if (userlocationpermission == LocationPermission.denied) {
      userlocationpermission = await Geolocator.requestPermission();
      if (userlocationpermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (userlocationpermission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied permanently');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 100);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Location: $lat, $long';
        _getAddressFromLatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<void> _getAddressFromLatLng(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _addressController.text =
              '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final wishlistBloc = context.read<WishlistBloc>();
    isWishlisted = wishlistBloc.state.wishlist.contains(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;
    int offerPercent =
        ((widget.product.product_price - widget.product.product_offerprice) /
                widget.product.product_price *
                100)
            .round();

    List<Product> similarProducts = widget.allProducts
        .where((p) =>
            p.product_cateogory == widget.product.product_cateogory &&
            p != widget.product)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.product.product_name,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              isWishlisted = state.wishlist.contains(widget.product);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.grey,
                  size: TSizes.iconLg,
                ),
                onPressed: () {
                  if (isWishlisted) {
                    context
                        .read<WishlistBloc>()
                        .add(RemoveProductFromWishlist(widget.product));
                  } else {
                    context
                        .read<WishlistBloc>()
                        .add(AddProductToWishlist(widget.product));
                  }
                },
              );
            },
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: kheight*0.4,
              child: Image.network(
                widget.product.imageLink,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.product.product_name,
                      style:
                          TextStyle(fontSize: TSizes.Lg, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text('${offerPercent}% off',
                            style: TextStyle(
                                fontSize: TSizes.fontLg,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text('${widget.product.product_price.round()}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: TSizes.fontLg,
                              color: Colors.black,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                            '₹${widget.product.product_offerprice.round()}',
                            style: TextStyle(
                                fontSize: TSizes.fontLg,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.product.product_description,
                      style: TextStyle(fontSize: TSizes.Lg)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      StarRating(
                        rating: widget.product.product_rating,
                        color: Colors.yellow.shade800,
                        starCount: 5,
                        iconsize: TSizes.iconMd,
                      ),
                      Text(
                        ' ${widget.product.product_rating} (ratings)',
                        style: TextStyle(fontSize: TSizes.fontLg),
                      ),
                    ],
                  ),
                ),
                if (widget.shop != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.shop!.shopename,
                        style: TextStyle(fontSize: TSizes.Lg)),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    if(_addressController.text != ''){
                      context.read<CartBloc>().add(AddItem(widget.product));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage(deliveryAddress: _addressController.text)),
                      );
                    };
                  }, 
                  child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, kheight*0.054),
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompareProductPage(
                          product1: widget.product,
                          allProducts: widget.allProducts,
                        ),
                      ),
                    );
                  }, 
                  child: Text('Compare Product',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, kheight*0.054),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: kheight*0.3,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(13.1143234, 80.2090789),
                    zoom: 11.5,
                  ),
                  onMapCreated: (controller) async {
                    _googleMapController = controller;

                    Position position = await _getCurrentLocation();
                    lat = position.latitude.toString();
                    long = position.longitude.toString();

                    setState(() {
                      _selectedLocationMarker = Marker(
                        markerId: MarkerId('current_location'),
                        infoWindow: InfoWindow(title: 'Current Location'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        position: LatLng(position.latitude, position.longitude),
                      );
                      locationMessage = 'Current Location: $lat, $long';
                    });

                    _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 15,
                        ),
                      ),
                    );

                    // Update address for current location
                    await _getAddressFromLatLng(position.latitude, position.longitude);
                  },
                  markers: {
                    if (_selectedLocationMarker != null) _selectedLocationMarker!,
                  },
                  onTap: (pos) async {
                    setState(() {
                      _selectedLocationMarker = Marker(
                        markerId: MarkerId('selected_location'),
                        infoWindow: InfoWindow(title: 'Selected Location'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        position: pos,
                      );
                      lat = pos.latitude.toString();
                      long = pos.longitude.toString();
                      locationMessage = 'Selected Location: $lat, $long';
                    });
                    // Update address for selected location
                    await _getAddressFromLatLng(pos.latitude, pos.longitude);
                  },
                ),
              ),
            ),
            Text(locationMessage, textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    _getCurrentLocation().then((value) {
                      lat = '${value.latitude}';
                      long = '${value.longitude}';
                      setState(() {
                        locationMessage = 'Location: $lat, $long';
                      });
                      _liveLocation();
                    });
                  },
                  child: Text("Get Current Location",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, kheight*0.054),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Address saved: ${_addressController.text}')),
                );
              }, 
              child: Text('Save Address',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, kheight*0.054),
                  backgroundColor: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (similarProducts.isNotEmpty) ...[
              Container(
                width: double.infinity,
                height: kheight*0.054,
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.grey)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Similar ',
                      style:
                          TextStyle(fontSize: TSizes.Lg, fontStyle: FontStyle.italic),
                    ),
                    Icon(Icons.add_box_outlined),
                  ],
                ),
              ),
              KGridview(products:similarProducts), // Use the KGridview widget to display similar products
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
