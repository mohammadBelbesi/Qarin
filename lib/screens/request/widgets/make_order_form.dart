import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/order_service.dart'; // Update with actual path

class MakeOrderForm extends StatefulWidget {
  final Map<String, dynamic> order;
  final Map<String, dynamic> offer;

  const MakeOrderForm({Key? key, required this.order, required this.offer})
      : super(key: key);

  @override
  _MakeOrderFormState createState() => _MakeOrderFormState();
}

class _MakeOrderFormState extends State<MakeOrderForm> {
  final _formKey = GlobalKey<FormState>();

  int _quantity = 1;
  String _notes = '';
  String _paymentMethod = "Cash";
  String _deliveryMethod = "Pickup";
  DateTime? _expectedDeliveryDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      final orderData = {
        "offerId": widget.offer['_id'], // Backend requires offerId
        "requestId": widget.order['_id'], // Backend requires requestId
        "userId": widget.order['user'], // User ID from order object
        "storeId": widget.offer['storeId'], // Optional: may be null
        "quantity": _quantity,
        "additionalNote": _notes,
        "paymentMethod": _paymentMethod,
        "deliveryMethod": _deliveryMethod,
        "expectedDeliveryDate": _expectedDeliveryDate?.toIso8601String(),
      };

      final orderService = OrderService();

      try {
        final response = await orderService.createOrder(orderData);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Order placed successfully: ${response['_id']}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _pickDeliveryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null) {
      setState(() {
        _expectedDeliveryDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productName =
        widget.order['product']['name']['en'] ?? 'Unnamed Product';
    final wholesalePrice = widget.offer['wholeSalePrice'];
    final retailPrice = widget.offer['retailPrice']['\$numberDecimal'] ?? 'N/A';

    return AlertDialog(
      title: Text('Make Order - $productName'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Wholesale Price: $wholesalePrice'),
            Text('Retail Price: $retailPrice'),
            const SizedBox(height: 10),

            // Quantity Input
            TextFormField(
              initialValue: _quantity.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
              validator: (value) {
                if (value == null ||
                    int.tryParse(value) == null ||
                    int.parse(value) <= 0) {
                  return 'Enter a valid quantity';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? 1;
                });
              },
            ),

            const SizedBox(height: 10),

            // Payment Method Dropdown
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(labelText: 'Payment Method'),
              items: ["Card", "Cash", "Online Transfer"].map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),

            // Delivery Method Dropdown
            DropdownButtonFormField<String>(
              value: _deliveryMethod,
              decoration: const InputDecoration(labelText: 'Delivery Method'),
              items: ["Pickup", "Home Delivery"].map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _deliveryMethod = value!;
                });
              },
            ),

            // Expected Delivery Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _expectedDeliveryDate == null
                      ? 'Select Delivery Date'
                      : 'Delivery Date: ${DateFormat.yMMMd().format(_expectedDeliveryDate!)}',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDeliveryDate(context),
                ),
              ],
            ),

            // Additional Notes Input
            TextFormField(
              decoration: const InputDecoration(labelText: 'Additional Notes'),
              maxLines: 2,
              onSaved: (value) {
                _notes = value ?? '';
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitOrder,
          child: _isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Place Order'),
        ),
      ],
    );
  }
}
