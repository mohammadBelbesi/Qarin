import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/offers.dart';
import '../../providers/user_provider.dart';

class CreateOfferDialog extends StatefulWidget {
  final String orderId;

  const CreateOfferDialog({Key? key, required this.orderId}) : super(key: key);

  @override
  _CreateOfferDialogState createState() => _CreateOfferDialogState();
}

class _CreateOfferDialogState extends State<CreateOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wholeSalePriceController =
      TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _refurbished = false;
  bool _clearance = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Offer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _wholeSalePriceController,
                  decoration:
                      const InputDecoration(labelText: 'Wholesale Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter wholesale price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(labelText: 'Cost'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter cost';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _retailPriceController,
                  decoration: const InputDecoration(labelText: 'Retail Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter retail price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter quantity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(labelText: 'Comment'),
                  keyboardType: TextInputType.text,
                ),
                SwitchListTile(
                  title: const Text('Refurbished'),
                  value: _refurbished,
                  onChanged: (value) {
                    setState(() {
                      _refurbished = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Clearance'),
                  value: _clearance,
                  onChanged: (value) {
                    setState(() {
                      _clearance = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createOffer(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createOffer(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userDetails?["_id"];

    if (userId == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('User ID not found. Please log in.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final offerData = {
      'userId': userId,
      'orderId': widget.orderId,
      'wholeSalePrice': _wholeSalePriceController.text,
      'cost': _costController.text,
      'retailPrice': _retailPriceController.text,
      'quantity': _quantityController.text,
      'comment': _commentController.text,
      'refurbished': _refurbished ? 'Yes' : 'No',
      'clearance': _clearance ? 'Yes' : 'No',
    };

    try {
      // Call the OffersService to create the offer
      final response = await OffersService.createOffer(offerData);
      print('Offer created successfully: $response');

      Navigator.of(context).pop(); // Close the dialog
    } catch (error) {
      print('Failed to create offer: $error');

      // Show an error dialog or message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to create offer: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
