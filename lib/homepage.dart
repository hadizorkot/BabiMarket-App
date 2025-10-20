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
  List<dynamic>? filteredProducts;
  var isLoading = true;
  late PageController _pageController; // Page controller for the carousel
  int _currentPage = 0; // Track current page for the carousel
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

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
      filteredProducts = data; // Initially show all products
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller when not needed
    _pageController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  // Search function to filter products by name
  void searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        filteredProducts =
            productCategories; // Show all products when query is empty
      });
    } else {
      setState(() {
        _searchResults = productCategories!
            .expand((category) => category["products"])
            .where(
              (product) =>
                  product["name"].toLowerCase().contains(query.toLowerCase()),
            )
            .map(
              (p) => Map<String, dynamic>.from(p as Map),
            ) // cast each item to Map<String, dynamic>
            .toList(); // Get all products that match the search query
        filteredProducts = productCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: (query) => searchProducts(query),
                onSubmitted: (query) {
                  // When user presses 'Enter', dismiss the keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                  searchProducts(query); // Perform search
                },
              )
            : const Text("BabiMarket"),
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
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchResults = [];
                  filteredProducts =
                      productCategories; // Show all products when search is cleared
                });
              } else {
                setState(() {
                  _isSearching = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
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
                              itemCount: filteredProducts?.length ?? 0,
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
                                                filteredProducts![index]["categoryId"],
                                            categoryName:
                                                filteredProducts![index]["categoryName"],
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
                                          filteredProducts![index]["categoryName"],
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

                    // Search Results Section (only shown when searching)
                    _isSearching
                        ? _buildSearchResultsSection()
                        : const SizedBox.shrink(),

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

  // Search Results Section
  Widget _buildSearchResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Search Results",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            var product = _searchResults[index];
            return ListTile(
              title: Text(product['name']),
              onTap: () {
                // Navigate to the product detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductItemDetail(
                      product: Product.fromJson(
                        product,
                      ), // Convert Map to Product object
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Build Product Section for displaying products
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
                    elevation: 8,
                    // ignore: deprecated_member_use
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            // ignore: deprecated_member_use
                            Colors.purple.withOpacity(0.2),
                            // ignore: deprecated_member_use
                            Colors.blueAccent.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
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
                                fontSize: 18,
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
