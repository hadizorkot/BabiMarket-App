import 'package:flutter/material.dart';
import 'package:babi_market/services/remote_services.dart';
import 'package:babi_market/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:babi_market/models/ProductCategory.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  List<ProductCategory>? productCategories;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final remoteServices = RemoteServices();
    productCategories = await remoteServices.getProductCategories();
    if (productCategories != null) {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BabiMarket"),
        centerTitle: true,
        backgroundColor: Colors.redAccent, // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner (like 'Get your special sale up to 40%')
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Get your special sale up to 40%",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
            Container(
              height: 60,
              child: isLoading
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productCategories?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              // Implement the logic when a category is tapped
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors
                                    .redAccent, // Background color of the box
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  productCategories![index].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Larger font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          // Handle the navigation logic here
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signout,
        child: const Icon(Icons.login_rounded),
      ),
    );
  }
}
