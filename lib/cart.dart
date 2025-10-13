import 'package:flutter/material.dart';

class Cart {
  static List<Map<String, dynamic>> cartItems = [];

  static void addItem(Map<String, dynamic> item) {
    cartItems.add(item);
  }

  static void removeItem(Map<String, dynamic> item) {
    cartItems.remove(item);
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Cart.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: Cart.cartItems.length,
              itemBuilder: (context, index) {
                final product = Cart.cartItems[index];
                return ListTile(
                  leading: Image.asset(product['image'], width: 50, height: 50),
                  title: Text(product['name']),
                  subtitle: Text("\$${product['price']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      Cart.removeItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} removed from cart'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
