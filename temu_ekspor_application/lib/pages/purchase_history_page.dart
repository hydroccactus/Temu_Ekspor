import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temu_ekspor_application/components/models/product.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  Future<List<Map<String, dynamic>>> fetchPurchaseHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ordersCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders');

      final ordersSnapshot = await ordersCollection.orderBy('date', descending: true).get();
      return ordersSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final items = (data['items'] as List)
            .map((item) => Product.fromMap(item as Map<String, dynamic>))
            .toList();
        return {
          'date': (data['date'] as Timestamp).toDate(),
          'items': items,
          'totalPrice': data['totalPrice'],
        };
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 58, 169),
      appBar: AppBar(title: const Text('Purchase History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPurchaseHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading purchase history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No purchase history found'));
          } else {
            final purchaseHistory = snapshot.data!;
            return ListView.builder(
              itemCount: purchaseHistory.length,
              itemBuilder: (ctx, index) {
                final history = purchaseHistory[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: const Icon(Icons.history, color: Color.fromARGB(255, 21, 58, 169)),
                    title: Text(
                      'Date: ${history['date']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Total Price: \$${history['totalPrice']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    children: <Widget>[
                      Column(
                        children: (history['items'] as List<Product>).map((item) {
                          return ListTile(
                            leading: Image.network(item.imageUrl),
                            title: Text(
                              item.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              item.description,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              '\$${item.price}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

extension on Product {
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}