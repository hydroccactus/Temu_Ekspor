import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temu_ekspor_application/components/models/product.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String deliveryAddress = '';
  String paymentMethod = 'Credit Card';
  String paypalEmail = '';
  String creditCardNumber = '';
  String creditCardExpiry = '';
  String creditCardCVV = '';
  String profileName = '';
  String profilePhone = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          profileName = userDoc.data()!['username'] ?? '';
          profilePhone = userDoc.data()!['phone'] ?? '';
          deliveryAddress = userDoc.data()!['address'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Product> cartItems = args['cartItems'];
    final Map<String, int> quantities = args['quantities'];
    final double totalPrice = args['totalPrice'];

    Future<void> saveOrder() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ordersCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders');

        final order = {
          'name': profileName,
          'phone': profilePhone,
          'address': deliveryAddress,
          'totalPrice': totalPrice,
          'items': cartItems.map((item) => item.toMap()).toList(),
          'quantities': quantities,
          'date': FieldValue.serverTimestamp(),
          'paymentMethod': paymentMethod,
        };

        await ordersCollection.add(order);
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 58, 169),
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (ctx, index) {
                    final product = cartItems[index];
                    return ListTile(
                      leading: product.isLocal
                          ? Image.asset(
                              product.imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/Logo.PNG'); // Placeholder image
                              },
                            )
                          : Image.network(
                              product.imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/Logo.PNG'); // Placeholder image
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
                      trailing: Text(
                        'Total: \$${product.price * (quantities[product.id] ?? 1)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Price: \$$totalPrice',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delivery Address',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: deliveryAddress,
                  decoration: const InputDecoration(
                    labelText: 'Enter Delivery Address',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(255, 42, 83, 204),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a delivery address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    deliveryAddress = value!;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Method',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 42, 83, 204),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color.fromARGB(255, 42, 83, 204),
                  items: const [
                    DropdownMenuItem(
                      value: 'Credit Card',
                      child: Text('Credit Card', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'PayPal',
                      child: Text('PayPal', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (paymentMethod == 'Credit Card') ...[
                  const Text(
                    'Credit Card Information',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color.fromARGB(255, 42, 83, 204),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      creditCardNumber = value!;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color.fromARGB(255, 42, 83, 204),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card\'s expiry date';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      creditCardExpiry = value!;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color.fromARGB(255, 42, 83, 204),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card\'s CVV';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      creditCardCVV = value!;
                    },
                  ),
                ] else if (paymentMethod == 'PayPal') ...[
                  const Text(
                    'PayPal Information',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'PayPal Email',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color.fromARGB(255, 42, 83, 204),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PayPal email';
                      }
                      return null;
                    },
                                        onSaved: (value) {
                      paypalEmail = value!;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      await saveOrder();
                      Navigator.pushNamedAndRemoveUntil(context, '/order_success', (route) => false, arguments: {
                        'name': profileName,
                        'phone': profilePhone,
                        'address': deliveryAddress,
                        'totalPrice': totalPrice,
                        'items': cartItems,
                      });
                    }
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Confirm Payment'),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20), // Add spacing at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}

