import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Products/ProuctGridview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ShopSearchScreen extends StatefulWidget {
  final List<Product> products;

  const ShopSearchScreen({Key? key, required this.products}) : super(key: key);

  @override
  _ShopSearchScreenState createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  // ignore: unused_field
  String _searchQuery = '';
  SpeechToText _speechToText = SpeechToText();
  // ignore: unused_field
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _requestMicrophonePermission();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
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
    final filteredProducts = widget.products.where((product) {
      return product.product_name
          .toLowerCase()
          .contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                child: Icon(Icons.arrow_back_ios),
                onTap: () {
                  Navigator.pop(context);
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
                        // onChanged: (query) {
                        //   setState(() {
                        //     _searchQuery = query;
                        //   });
                        // },
                        decoration: InputDecoration(
                          hintText: 'What are you looking for?',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: _speechToText.isNotListening
                                ? _startListening
                                : _stopListening,
                            icon: Icon(_speechToText.isNotListening
                                ? Icons.mic_off
                                : Icons.mic),
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
      body: filteredProducts.isEmpty
          ? Center(child: Text('No products found'))
          : KGridview(products: filteredProducts),
    );
  }
}
