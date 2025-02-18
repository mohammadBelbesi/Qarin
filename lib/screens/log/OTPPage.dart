import 'package:flutter/material.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // Flag to check if OTP is sent
  bool _isOTPSent = false;

  void _sendOTP() {
    final phone = _phoneController.text;

    if (phone.isNotEmpty) {
      // Logic to send OTP (replace with your API logic)
      setState(() {
        _isOTPSent = true; // OTP sent, switch to OTP verification
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your phone number')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  void _verifyOTP() {
    final otp = _otpController.text;

    if (otp.isNotEmpty) {
      // Logic to verify OTP (replace with your API logic)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified! Logging you in...')),
      );
      // Navigate to Home Page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Phone Number Input, shown only if OTP is not sent
            if (!_isOTPSent)
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            const SizedBox(height: 16),

            // Send OTP Button, shown only if OTP is not sent
            if (!_isOTPSent)
              ElevatedButton(
                onPressed: _sendOTP,
                child: const Text('Send OTP'),
              ),
            const SizedBox(height: 24),

            // OTP Input, shown only if OTP is sent
            if (_isOTPSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 24),

            // Verify OTP Button, shown only if OTP is sent
            if (_isOTPSent)
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text('Verify OTP'),
              ),
            const SizedBox(height: 24),

            // Register Option (Text link)
            if (!_isOTPSent) // Only show register option if OTP is not sent
              TextButton(
                onPressed: () {
                  // Navigate to Registration Page
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Don’t have an account? Register here'),
              ),
          ],
        ),
      ),
    );
  }
}
