import 'package:flutter/material.dart';
import 'package:babi_market/models/Product.dart';

class ProductItemDetail extends StatefulWidget {
  final Product product;

  const ProductItemDetail({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductItemDetailState createState() => _ProductItemDetailState();
}

class _ProductItemDetailState extends State<ProductItemDetail> {
  int quantity = 1; // Default quantity

  @override
  Widget build(BuildContext context) {
    // Calculate total price
    double totalPrice = widget.product.price * quantity;

    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Light grey background for a modern feel
      appBar: AppBar(
        title: Text('${widget.product.name} Details'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image of the product
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  24,
                ), // Rounded image corners
                child: Image.asset(
                  widget.product.image,
                  height: 300, // Larger image height for impact
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),
              // Product name
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              // Product price
              Text(
                "\$${widget.product.price}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16.0),
              // Product description
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24.0),
              // Quantity Selection Section
              Row(
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                    color: Colors.orange,
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Display total price
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}', // Two decimal places
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24.0),
              // Add to Cart Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your logic for adding the product to the cart with quantity
                    // ignore: avoid_print
                    print(
                      'Added ${widget.product.name} to cart. Quantity: $quantity, Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button color
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 40.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
