import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import 'home_screen.dart';

class FinalBillingScreen extends StatelessWidget {
  const FinalBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final job = context.watch<AppState>().currentJob;
    final appState = context.read<AppState>();

    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invalid Status')),
        body: const Center(child: Text('No active job bill available.')),
      );
    }

    final totalValue = job.totalCost;

    return Scaffold(
      appBar: AppBar(title: const Text('Final Bill')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.receipt_long, size: 80, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text('Service Completed', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Please review and pay your final bill'),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildLineItem('Visit Charge', job.homingCharge, isPaid: true),
                    const Divider(),
                    if (job.partsCost != null && job.partsCost! > 0)
                      _buildLineItem('Spare Parts', job.partsCost!),
                    if (job.serviceCharge != null && job.serviceCharge! > 0)
                      _buildLineItem('Additional Service', job.serviceCharge!),
                    const Divider(thickness: 2),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Remaining Amount', style: Theme.of(context).textTheme.titleLarge),
                        Text('₹${totalValue - job.homingCharge}', 
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Pay Online (UPI/Cards)'),
              leading: const Icon(Icons.payment),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300)
              ),
              onTap: () {
                _simulatePayment(context, appState);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Pay Cash to Mechanic'),
              leading: const Icon(Icons.money),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300)
              ),
              onTap: () {
                _simulatePayment(context, appState);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(String label, double amount, {bool isPaid = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(label),
              if (isPaid)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                  child: const Text('PAID', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          Text('₹$amount', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _simulatePayment(BuildContext context, AppState appState) {
    appState.cancelJob(); // clear current job for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful! Redirecting to home...')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
      (route) => false,
    );
  }
}
