import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temu_ekspor_application/components/models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> cartItems = [];
  Map<String, int> quantities = {};

  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final cartSnapshot = await cartCollection.get();
      final items = cartSnapshot.docs.map((doc) {
        final data = doc.data();
        final product = Product.fromMap(data['product'] as Map<String, dynamic>);
        final quantity = data['quantity'] as int;
        return {'product': product, 'quantity': quantity};
      }).toList();

      setState(() {
        cartItems = items.map((item) => item['product'] as Product).toList();
        quantities = {
          for (var item in items) (item['product'] as Product).id: item['quantity'] as int
        };
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(
      0.0,
      (accumulator, item) => accumulator + (item.price * (quantities[item.id] ?? 1)),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 58, 169),
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (ctx, index) {
                  final product = cartItems[index];
                  return ListTile(
                    leading: Image.asset(
                      product.imageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('lib/images/Logo.PNG'); // Placeholder image
                      },
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Quantity: ${quantities[product.id]}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total: \$${product.price * (quantities[product.id] ?? 1)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                          onPressed: () async {
                            setState(() {
                              cartItems.removeAt(index);
                              quantities.remove(product.id);
                            });
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final cartCollection = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('cart');
                              await cartCollection.doc(product.id).delete();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text(
              'Total Price: \$$totalPrice',
              style: const TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    'cartItems': cartItems,
                    'quantities': quantities,
                    'totalPrice': totalPrice,
                  },
                );
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
