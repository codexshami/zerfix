import 'package:flutter/material.dart';

class MechanicVerificationScreen extends StatefulWidget {
  const MechanicVerificationScreen({super.key});

  @override
  State<MechanicVerificationScreen> createState() => _MechanicVerificationScreenState();
}

class _MechanicVerificationScreenState extends State<MechanicVerificationScreen> {
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mechanic Verification')),
      body: _isSubmitted
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, size: 80, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'Verification Details Submitted!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Our team will review your ID, address, and bank details. You will be notified once approved.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Please provide your details below to get verified and start receiving jobs.'),
                  const SizedBox(height: 24),
                  _buildUploadField('ID Proof (Aadhar/PAN)'),
                  const SizedBox(height: 16),
                  _buildUploadField('Address Proof'),
                  const SizedBox(height: 16),
                  _buildUploadField('Vehicle Registration (Optional)'),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Bank Account Number',
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'IFSC Code',
                      prefixIcon: Icon(Icons.code),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSubmitted = true;
                        });
                      },
                      child: const Text('Submit Details'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildUploadField(String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file, size: 16),
            label: const Text('Upload'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
        ],
      ),
    );
  }
}
