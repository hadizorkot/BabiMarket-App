import 'package:flutter/material.dart';
import 'package:babi_market/models/Product.dart';
import 'package:babi_market/services/remote_services.dart';

class ProductCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductCategoryPage> createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  List<Product>? products;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    setState(() {
      isLoading = true;
    });
    final remoteServices = RemoteServices();
    products = await remoteServices.getProductsByCategory(widget.categoryId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Products'),
        backgroundColor: const Color.fromARGB(255, 94, 82, 255),
        elevation: 4, // Add shadow for a floating effect
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : products == null || products!.isEmpty
            ? const Center(child: Text('No products found in this category.'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75, // Adjust item aspect ratio
                ),
                itemCount: products?.length,
                itemBuilder: (context, index) {
                  final product = products![index];
                  return ProductCard(product: product);
                },
              ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // You can navigate to a detailed product page here
        print("Tapped on ${product.name}");
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6, // Card elevation
        shadowColor: Colors.grey.withOpacity(0.3), // Add shadow color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image part
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                product.image,
                height: 150, // Fixed height for image
                width: double.infinity,
                fit: BoxFit.cover, // Ensure image covers the whole area
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Description part
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.description,
                style: TextStyle(fontSize: 14, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Limit description to 2 lines to prevent overflow
              ),
            ),
            // Price part: Display at the bottom of the card
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "\$${product.price}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Make the price prominent
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
