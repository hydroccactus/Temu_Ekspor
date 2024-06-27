import 'package:flutter/material.dart';
import 'package:temu_ekspor_application/components/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  Future<void> addToCart(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final cartItemDoc = await cartCollection.doc(product.id).get();

      if (cartItemDoc.exists) {
        // Update the quantity if the item already exists in the cart
        await cartCollection.doc(product.id).update({
          'quantity': FieldValue.increment(quantity),
        });
      } else {
        // Add the item to the cart if it doesn't exist
        await cartCollection.doc(product.id).set({
          'product': product.toMap(),
          'quantity': quantity,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                product.imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('lib/images/Logo.PNG'); // Placeholder image
                },
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleLarge, // Use headline6 for the product name
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.headlineSmall, // Use headline5 for the price
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyLarge, // Use bodyText1 for the description
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the quantity controls
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center( // Center the "Add to Cart" button
                child: ElevatedButton(
                  onPressed: () async {
                    await addToCart(product);
                    Navigator.pop(context, {'product': product, 'quantity': quantity}); // Pass the quantity
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(height: 20), // Add spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
