import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/job.dart';
import 'verification_screen.dart';
import 'wallet_screen.dart';
import 'job_detail_screen.dart';

class MechanicDashboardScreen extends StatelessWidget {
  const MechanicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final job = appState.currentJob;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.verified_user),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MechanicVerificationScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Jobs\nCompleted', '42', Icons.task_alt, Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Monthly\nEarnings', '₹12,450', Icons.account_balance_wallet, Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Rating', '4.8', Icons.star, Colors.amber)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Distance\nCovered', '156 km', Icons.electric_rickshaw, Colors.blue)),
              ],
            ),
            const SizedBox(height: 32),
            Text('Active Job Requests', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            
            if (job == null || job.status == JobStatus.completed || job.status == JobStatus.cancelled)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No active requests right now. Stay online to receive jobs.'),
                ),
              )
            else
              Card(
                elevation: 4,
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('New Request!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                          Text(_getStatusText(job.status)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Customer: ${job.customerId}'),
                      Text('Address: ${job.address}'),
                      const SizedBox(height: 8),
                      Text('Visit Charge: ₹${job.homingCharge}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => appState.cancelJob(),
                            child: const Text('Reject'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                              );
                            },
                            child: const Text('View Job'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  String _getStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.pending: return 'Pending Action';
      case JobStatus.accepted: return 'Accepted - Travel';
      case JobStatus.inProgress: return 'In Progress';
      default: return status.toString().split('.').last;
    }
  }
}
