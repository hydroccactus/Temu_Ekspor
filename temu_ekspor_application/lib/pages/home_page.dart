import 'package:flutter/material.dart';
import 'package:temu_ekspor_application/components/drawer.dart';
import 'package:temu_ekspor_application/components/models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Product> cartItems = [];
  Map<String, int> quantities = {};

  final List<Product> products = const [
    Product(
      id: '1',
      name: 'Macro Organic Fairtrade Coffee Beans Medium 200g',
      description: '"Smooth and sweet with chocolate and vanilla tones made from organic Fairtrade Peruvian coffee supporting farmers and the environment"',
      price: 15.0,
      imageUrl: 'lib/images/kopi1.png',
      isLocal: true,
    ),
    Product(
      id: '2',
      name: 'Macro Organic Fairtrade Ground Coffee Dark 200g',
      description: 'Handpicked, organic coffee from Peru\'s Andean Mountains grown without synthetic pesticides.',
      price: 20.0,
      imageUrl: 'lib/images/kopi2.png',
      isLocal: true,
    ),
    Product(
      id: '3',
      name: 'Pure Leaf Organic Black Tea with Vanilla flavor',
      description: 'Pure Leaf Organic Black Tea with Vanilla offers a rich vanilla-flavored, organic tea free from additives.',
      price: 15.0,
      imageUrl: 'lib/images/teh3.png',
      isLocal: true,
    ),
    Product(
      id: '4',
      name: 'Nature Clove',
      description: 'Nature Clove Product offers warm spicy flavor perfect for enhancing dishes and promoting wellness',
      price: 20.0,
      imageUrl: 'lib/images/cengkeh4.png',
      isLocal: true,
    ),
    Product(
      id: '5',
      name: 'Organic Cacao Beans',
      description: 'Organic Cacao Beans offer rich chocolate flavor packed with nutrients',
      price: 15.0,
      imageUrl: 'lib/images/coklat5.png',
      isLocal: true,
    ),
    Product(
      id: '6',
      name: 'Organic Sugar cane',
      description: 'Sugar cane provides a natural sweet flavor and is a versatile ingredient for various foods and beverages.',
      price: 20.0,
      imageUrl: 'lib/images/sugar6.png',  // Ensure this path is correct
      isLocal: true,
    ),
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 58, 169),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/cart',
                arguments: {
                  'cartItems': cartItems,
                  'quantities': quantities,
                },
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Image.asset(
            'lib/images/Banner.png', // Ensure this path is correct and the image is included in your assets
            fit: BoxFit.cover,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                final product = products[index];
                return ListTile(
                  leading: product.isLocal
                      ? Image.asset(product.imageUrl)
                      : Image.network(
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
                    product.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/product_detail',
                      arguments: product,
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      final addedProduct = result['product'] as Product;
                      final quantity = result['quantity'] as int;
                      setState(() {
                        if (quantities.containsKey(addedProduct.id)) {
                          quantities[addedProduct.id] =
                              quantities[addedProduct.id]! + quantity;
                        } else {
                          cartItems.add(addedProduct);
                          quantities[addedProduct.id] = quantity;
                        }
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
