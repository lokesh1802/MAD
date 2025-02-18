import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  String _address = '';
  String _phoneNumber = '';
  String _paymentMethod = 'Credit Card';
  bool _saveInfo = false;
  bool _isLoading = false;

  final List<String> _paymentMethods = ['Credit Card', 'Cash on Delivery', 'PayPal'];

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _address = prefs.getString('lastDeliveryAddress') ?? '';
      _phoneNumber = prefs.getString('lastPhoneNumber') ?? '';
    });
  }

  Future<void> _saveDeliveryInfo() async {
    if (!_saveInfo) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastDeliveryAddress', _address);
    await prefs.setString('lastPhoneNumber', _phoneNumber);
  }

  Future<void> _processOrder() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    await _saveDeliveryInfo();
    setState(() => _isLoading = false);
    
    // Clear cart and navigate back
    context.read<Cart>().clear();
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 2) {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                _processOrder();
              }
            } else {
              setState(() => _currentStep++);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            Step(
              title: Text('Delivery Address'),
              content: Column(
                children: [
                  TextFormField(
                    initialValue: _address,
                    decoration: InputDecoration(
                      labelText: 'Delivery Address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter delivery address';
                      }
                      return null;
                    },
                    onSaved: (value) => _address = value ?? '',
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _phoneNumber,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                    onSaved: (value) => _phoneNumber = value ?? '',
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('Payment Method'),
              content: Column(
                children: _paymentMethods.map((method) {
                  return RadioListTile<String>(
                    title: Text(method),
                    value: method,
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() => _paymentMethod = value!);
                    },
                  );
                }).toList(),
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('Order Summary'),
              content: Column(
                children: [
                  Consumer<Cart>(
                    builder: (context, cart, child) {
                      return Column(
                        children: [
                          ...cart.foodItems.map((item) {
                            final quantity = cart.items[item.id] ?? 0;
                            return ListTile(
                              title: Text(item.name),
                              subtitle: Text('Quantity: $quantity'),
                              trailing: Text(
                                '\$${(item.price * quantity).toStringAsFixed(2)}',
                              ),
                            );
                          }).toList(),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Save delivery information'),
                    value: _saveInfo,
                    onChanged: (value) {
                      setState(() => _saveInfo = value ?? false);
                    },
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}