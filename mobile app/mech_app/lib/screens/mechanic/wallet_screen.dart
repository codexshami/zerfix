import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double currentBalance = 12450.0;
    const double payoutThreshold = 400.0;
    final bool canWithdraw = currentBalance >= payoutThreshold;

    return Scaffold(
      appBar: AppBar(title: const Text('My Wallet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('₹$currentBalance', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canWithdraw ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Withdrawal request submitted.')),
                      );
                    } : null,
                    icon: const Icon(Icons.account_balance),
                    label: const Text('Withdraw to Bank'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!canWithdraw)
              const Text(
                'Note: Minimum withdrawal amount is ₹$payoutThreshold',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 16),
            _buildTransaction('Ac Repair (job_124)', 250, true),
            _buildTransaction('Fridge Service (job_122)', 450, true),
            _buildTransaction('Withdrawal', -5000, false),
            _buildTransaction('AC Gas Fill (job_120)', 1200, true),
          ],
        ),
      ),
    );
  }

  Widget _buildTransaction(String title, double amount, bool isCredit) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCredit ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),
      title: Text(title),
      subtitle: const Text('Oct 24, 2023'),
      trailing: Text(
        '${isCredit ? '+' : ''}₹${amount.abs()}',
        style: TextStyle(
          color: isCredit ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
