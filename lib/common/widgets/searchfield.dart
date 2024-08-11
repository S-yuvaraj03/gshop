import 'package:flutter/material.dart';
import 'package:gshop/data/repositories/fetch_data/fetchdata.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProductPage.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class Searchfield extends StatefulWidget {
  Searchfield({super.key});

  @override
  State<Searchfield> createState() => _SearchfieldState();
}

class _SearchfieldState extends State<Searchfield> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _sortOption = 'None';
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  SpeechToText _speechToText = SpeechToText();
  // ignore: unused_field
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _initSpeech();
    _requestMicrophonePermission();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
        _filterProducts();
      });
    });
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await fetchProducts();
      setState(() {
        _allProducts = products;
        _filterProducts();
      });
    } catch (error) {
      // Handle error
    }
  }

  void _filterProducts() {
    _filteredProducts = _allProducts
        .where((product) =>
            product.product_name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
    _sortProducts();
  }

  void _sortProducts() {
    switch (_sortOption) {
      case 'Price: Low to High':
        _filteredProducts.sort((a, b) => a.product_price.compareTo(b.product_price));
        break;
      case 'Price: High to Low':
        _filteredProducts.sort((a, b) => b.product_price.compareTo(a.product_price));
        break;
      case 'Rating':
        _filteredProducts
            .sort((a, b) => b.product_rating.compareTo(a.product_rating));
        break;
      default:
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('None'),
              value: 'None',
              groupValue: _sortOption,
              onChanged: (String? value) {
                setState(() {
                  _sortOption = value!;
                  _sortProducts();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Price: Low to High'),
              value: 'Price: Low to High',
              groupValue: _sortOption,
              onChanged: (String? value) {
                setState(() {
                  _sortOption = value!;
                  _sortProducts();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Price: High to Low'),
              value: 'Price: High to Low',
              groupValue: _sortOption,
              onChanged: (String? value) {
                setState(() {
                  _sortOption = value!;
                  _sortProducts();
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Rating'),
              value: 'Rating',
              groupValue: _sortOption,
              onChanged: (String? value) {
                setState(() {
                  _sortOption = value!;
                  _sortProducts();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchController.text = _lastWords;
    });
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      // Microphone access granted
      print("Access Granted");
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Permission denied
      await openAppSettings(); // Optional: Open app settings to allow permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                child: Icon(Icons.arrow_back_ios),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/Navigator');
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'What are you looking for?',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                            icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _showSortOptions,
              label: Text('Sort By'),
              iconAlignment: IconAlignment.end,
              icon: Icon(Icons.sort_rounded),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Flexible(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of products per row
                childAspectRatio: 2 / 3, // Adjust the aspect ratio as needed
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductPage(product: product, allProducts: _allProducts,);
              },
            ),
          ),
        ],
      ),
    );
  }
}
