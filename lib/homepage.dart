import 'dart:async'; // For Timer
import 'dart:convert'; // For json decoding
import 'package:flutter/material.dart';
import 'package:babi_market/models/Product.dart';
import 'package:babi_market/product_item_detail.dart';
import 'package:babi_market/product_category_page.dart'; // Import the ProductCategoryPage widget
import 'package:flutter/services.dart'; // For rootBundle

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic>? productCategories;
  var isLoading = true;
  late PageController _pageController; // Page controller for the carousel
  int _currentPage = 0; // Track current page for the carousel

  @override
  void initState() {
    super.initState();
    loadData(); // Load the data from the JSON file
    _pageController = PageController(
      initialPage: _currentPage,
    ); // Initialize the page controller

    // Auto-scroll the images every 3 seconds
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Load JSON data from the assets
  Future<void> loadData() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      productCategories = data;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BabiMarket"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner with automatic image carousel
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 3, // 3 images for the carousel
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/advertisement${index + 1}.jpg', // Assuming the images are named advertisement1.jpg, advertisement2.jpg, etc.
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories Section
                    const Text(
                      "Our Products",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Horizontal scrollable categories (styled like buttons)
                    SizedBox(
                      height: 60,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productCategories?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductCategoryPage(
                                            categoryId:
                                                productCategories![index]["categoryId"],
                                            categoryName:
                                                productCategories![index]["categoryName"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.purple.shade300,
                                            Colors.blueAccent,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            // ignore: deprecated_member_use
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          productCategories![index]["categoryName"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Recommended Items Section
                    _buildProductSection(
                      title: "Recommended For You",
                      products: _getProductsByCategory(
                        "Food",
                      ).take(3).toList(), // Get only the first 3 items
                    ),
                    const SizedBox(height: 16),

                    // New Items Section
                    _buildProductSection(
                      title: "New Items",
                      products: _getProductsByCategory(
                        "Beverages",
                      ).take(3).toList(), // Get only the first 3 items
                    ),
                    const SizedBox(height: 16),

                    // Top Items Section
                    _buildProductSection(
                      title: "Top Items",
                      products: _getProductsByCategory(
                        "Snacks",
                      ).take(3).toList(), // Get only the first 3 items
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProductSection({
    required String title,
    required List<Map<String, dynamic>> products,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductItemDetail(
                          product: Product.fromJson(
                            products[index],
                          ), // Convert Map to Product object
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    // ignore: deprecated_member_use
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.asset(
                            products[index]['image'],
                            height: 140,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            products[index]['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "\$${products[index]['price']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getProductsByCategory(String categoryName) {
    if (productCategories == null) return [];

    for (var category in productCategories!) {
      if (category["categoryName"] == categoryName) {
        return List<Map<String, dynamic>>.from(category["products"]);
      }
    }
    return [];
  }
}
