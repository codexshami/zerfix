import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/job.dart';
import 'final_billing_screen.dart';
import 'chat_screen.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final job = context.watch<AppState>().currentJob;
    final appState = context.read<AppState>();

    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No active job')),
        body: const Center(child: Text('You have no active repair requests.')),
      );
    }

    final mechanic = appState.mechanics.firstWhere((m) => m.id == job.mechanicId);

    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: Column(
        children: [
          // Simulated Map Area
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 60, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Map view (simulated)'),
                  ],
                ),
              ),
            ),
          ),
          // Job Status Info
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getStatusText(job.status),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (job.status == JobStatus.pending || job.status == JobStatus.accepted)
                        Text('ETA: 15 mins', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  const Divider(height: 32),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundImage: NetworkImage(mechanic.imageUrl)),
                    title: Text(mechanic.name),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(' ${mechanic.rating}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(mechanicName: mechanic.name),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 32),
                  if (job.status == JobStatus.pending || job.status == JobStatus.accepted)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Share OTP when mechanic arrives:', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(job.otp, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ],
                      ),
                    ),
                  if (job.status == JobStatus.inProgress)
                    const Text('Repair in progress. Discuss any parts required with your mechanic.'),
                  
                  const Spacer(),
                  // Developer helper buttons to mock the mechanic workflow from customer side for testing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (job.status == JobStatus.pending)
                        ElevatedButton(
                          onPressed: () => appState.updateJobStatus(JobStatus.accepted),
                          child: const Text('Dev: Accept Job'),
                        ),
                      if (job.status == JobStatus.accepted)
                        ElevatedButton(
                          onPressed: () => appState.updateJobStatus(JobStatus.inProgress),
                          child: const Text('Dev: Arrive & OTP'),
                        ),
                      if (job.status == JobStatus.inProgress || job.status == JobStatus.completed)
                        ElevatedButton(
                          onPressed: () {
                            if(job.status != JobStatus.completed) {
                              appState.completeJob(500, 300); // Dev complete jobs with $500 parts, $300 service
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const FinalBillingScreen()),
                            );
                          },
                          child: const Text('View Bill'),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.pending: return 'Finding mechanic...';
      case JobStatus.accepted: return 'Mechanic is on the way';
      case JobStatus.mechanicArrived: return 'Mechanic arrived';
      case JobStatus.inProgress: return 'Repair in Progress';
      case JobStatus.completed: return 'Job Completed';
      case JobStatus.cancelled: return 'Cancelled';
    }
  }
}
