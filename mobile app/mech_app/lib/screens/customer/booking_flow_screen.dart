import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mechanic.dart';
import '../../providers/app_state.dart';
import 'tracking_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final Mechanic mechanic;

  const BookingFlowScreen({super.key, required this.mechanic});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final _addressController = TextEditingController();
  bool _isPaying = false;

  void _processPayment() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your address')),
      );
      return;
    }

    setState(() {
      _isPaying = true;
    });

    // Simulate payment delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Create job in state
    context.read<AppState>().createJob(widget.mechanic, _addressController.text);

    // Navigate to tracking
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TrackingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Service')),
      body: _isPaying
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing Payment...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Confirm details', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mechanic: ${widget.mechanic.name}'),
                          const SizedBox(height: 8),
                          Text('Homing Charge: ₹${widget.mechanic.basePrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Service Address',
                      hintText: 'Enter your full address with landmark',
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text('Online (UPI/Cards)'),
                    leading: const Icon(Icons.payment),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      child: Text('Pay ₹${widget.mechanic.basePrice} & Book'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
