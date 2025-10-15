import 'package:flutter/material.dart';
import 'cart.dart'; // Assuming CartScreen is named as CartScreen
import 'models/Product.dart';
import 'package:badges/badges.dart'
    as badges; // Alias the 'Badge' widget from the 'badges' package

class ProductItemDetail extends StatefulWidget {
  final Product product;

  const ProductItemDetail({super.key, required this.product});

  @override
  _ProductItemDetailState createState() => _ProductItemDetailState();
}

class _ProductItemDetailState extends State<ProductItemDetail> {
  int quantity = 1;
  bool itemAdded = false;

  // Mock cart items count (you will use your actual cart data)
  int cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.product.price * quantity;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${widget.product.name} Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.blueGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          badges.Badge(
            badgeContent: Text(
              '$cartItemCount', // Displays the current number of items in the cart
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
            showBadge: cartItemCount > 0,
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
            position: badges.BadgePosition.topEnd(),
            badgeAnimation: badges.BadgeAnimation.scale(
              animationDuration: Duration(milliseconds: 300),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Hero(
                  tag: widget.product.image,
                  transitionOnUserGestures: true,
                  child: Image.asset(
                    widget.product.image,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                widget.product.name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                "\$${widget.product.price}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.product.description,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24.0),
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
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                    color: Colors.deepOrangeAccent,
                    iconSize: 28,
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
                    color: Colors.deepOrangeAccent,
                    iconSize: 28,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      itemAdded = true;
                      cartItemCount++; // Increment the cart item count
                    });
                    // ignore: avoid_print
                    print(
                      'Added ${widget.product.name} to cart. Quantity: $quantity, Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 40.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black45,
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
              if (itemAdded)
                Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      'Item added to cart!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Continue shopping
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 28.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            'Continue Shopping',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 28.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            'Go to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
