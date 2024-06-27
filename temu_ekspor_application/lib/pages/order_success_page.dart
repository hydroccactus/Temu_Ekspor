import 'package:flutter/material.dart';
import 'package:temu_ekspor_application/components/models/product.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String name = args['name'];
    final String phone = args['phone'];
    final String address = args['address'];
    final double totalPrice = args['totalPrice'];
    final List<Product> items = args['items'];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 58, 169),
      appBar: AppBar(title: const Text('Order Success')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Transaction Successful!',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  'Name: $name',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Phone: $phone',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Address: $address',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(
                      'Order Details:',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        final product = items[index];
                        print('Image URL for ${product.name}: ${product.imageUrl}'); // Debugging output
                        return Card(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          child: ListTile(
                            leading: product.imageUrl.isNotEmpty
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(product.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.image, color: Colors.white), // Placeholder for empty URL
                            title: Text(
                              product.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              product.description,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              'Total: \$${product.price}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
