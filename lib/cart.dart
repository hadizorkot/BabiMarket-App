import 'package:flutter/material.dart';

// Cart class to manage cart items
class Cart {
  static List<Map<String, dynamic>> cartItems = [];

  // Add item to the cart
  static void addItem(Map<String, dynamic> item) {
    cartItems.add(item);
  }

  // Remove item from the cart
  static void removeItem(Map<String, dynamic> item) {
    cartItems.remove(item);
  }

  // Get the total price of the items in the cart
  static double getTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item['price'];
    }
    return total;
  }
}

// CartScreen to display cart items
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Cart.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: Cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = Cart.cartItems[index];
                      return ListTile(
                        leading: Image.asset(
                          product['image'],
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product['name']),
                        subtitle: Text("\$${product['price']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_shopping_cart),
                          onPressed: () {
                            setState(() {
                              Cart.removeItem(product);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product['name']} removed from cart',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Display total price
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${Cart.getTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// Sample product model and method to add to cart
class ProductItemDetail extends StatelessWidget {
  final Map<String, dynamic> product = {
    'name': 'Example Product',
    'price': 29.99,
    'image':
        'assets/images/example_product.jpg', // Replace with your image path
    'description': 'This is an example product description.',
  };

  ProductItemDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              product['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              product['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              "\$${product['price']}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              product['description'],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Cart.addItem(product); // Add the product to the cart
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['name']} added to cart')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 40.0,
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
