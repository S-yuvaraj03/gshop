import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/screens/Geminiai_Chat/AiChatscreen.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:gshop/utils/formatters/starratings.dart';

class CompareProductPage extends StatefulWidget {
  final Product product1;
  final List<Product> allProducts;

  const CompareProductPage({
    Key? key,
    required this.product1,
    required this.allProducts,
  }) : super(key: key);

  @override
  State<CompareProductPage> createState() => _CompareProductPageState();
}

class _CompareProductPageState extends State<CompareProductPage> {
  Product? product2;

  // Method to filter products based on description similarity
  List<Product> _getSimilarProducts() {
    Set<String> tokenize(String text) {
      final stopwords = {'and', 'the', 'with', 'of', 'in', 'for'};
      return text
          .toLowerCase()
          .split(RegExp(r'\W+'))
          .where((token) => !stopwords.contains(token) && token.isNotEmpty)
          .toSet();
    }

    Set<String> product1Tokens = tokenize(widget.product1.product_description);

    return widget.allProducts.where((product) {
      if (product == widget.product1) return false;
      Set<String> productTokens = tokenize(product.product_description);
      int commonTokens = product1Tokens.intersection(productTokens).length;
      return commonTokens >= 2; // Threshold for similarity
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;
    double kwidth = MediaQuery.of(context).size.width;
    List<Product> similarProducts = _getSimilarProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Compare Products"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              _buildProductColumn(widget.product1, widget.product1.product_name),
              VerticalDivider(color: Colors.black, width: 2),
              if (product2 != null)
                _buildProductColumn(product2!, product2!.product_name)
              else
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    height: kheight*0.2,
                    child: Center(
                      child: Text(
                        "Please select a product to compare from the options below.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: similarProducts.isEmpty
                ? Center(child: Text("No similar products found"))
                : ListView.builder(
                    itemCount: similarProducts.length,
                    itemBuilder: (context, index) {
                      Product product = similarProducts[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(
                            product.imageLink,
                            width: kwidth*0.12,
                            height: kheight*0.05,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product.product_name,
                            style: TextStyle(fontSize: TSizes.fontMd),
                          ),
                          subtitle: Text(
                            product.product_description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: TSizes.fontSm),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                product2 = product;
                              });
                            },
                            child: Text("Select"),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AichatScreen()));
        },
        child: Image.asset("assets/images/google-gemini-icon.png"),
      ),
    );
  }

  // Method to build the product column with padding and alignment
  Widget _buildProductColumn(Product product, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageLink,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                label,
                style: TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            _buildProductDetailRow("Price:", "₹${product.product_offerprice}"),
            SizedBox(height: 8),
            Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 4),
            Container(
              height: 100, // Adjusted height for description
              child: SingleChildScrollView(
                child: Text(
                  product.product_description,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 8),
            StarRating(
              rating: product.product_rating,
              color: Colors.yellow.shade800,
              starCount: 5,
              iconsize: TSizes.iconMd,
            ),
            SizedBox(height: 8),
            _buildProductDetailRow("Ratings:", product.product_rating.toString()),
          ],
        ),
      ),
    );
  }

  // Helper method to build a product detail row with padding
  Widget _buildProductDetailRow(String title, String value,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: TSizes.fontMd),
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
