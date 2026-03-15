import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/job.dart';

class JobDetailScreen extends StatefulWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final _otpController = TextEditingController();
  final _partsController = TextEditingController();
  final _serviceController = TextEditingController();

  void _verifyOTP(AppState appState) {
    if (_otpController.text == widget.job.otp) {
      appState.updateJobStatus(JobStatus.inProgress);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please ask the customer.')),
      );
    }
  }

  void _completeJob(AppState appState) {
    final parts = double.tryParse(_partsController.text) ?? 0;
    final service = double.tryParse(_serviceController.text) ?? 0;
    
    appState.completeJob(parts, service);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job Completed. Bill generated.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    // refresh job instance from state to reflect changes
    final currentJob = appState.currentJob;

    if (currentJob == null || currentJob.id != widget.job.id) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Not Found')),
        body: const Center(child: Text('This job is no longer active.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Address:', style: Theme.of(context).textTheme.titleLarge),
            Text(currentJob.address, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            const Divider(),
            
            if (currentJob.status == JobStatus.pending) ...[
              const SizedBox(height: 16),
              const Text('Do you want to accept this job?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      appState.cancelJob();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                    child: const Text('Reject'),
                  ),
                  ElevatedButton(
                    onPressed: () => appState.updateJobStatus(JobStatus.accepted),
                    child: const Text('Accept Job'),
                  ),
                ],
              )
            ] else if (currentJob.status == JobStatus.accepted || currentJob.status == JobStatus.mechanicArrived) ...[
              const SizedBox(height: 16),
              const Text('Enter the Customer OTP to start work:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '4-Digit OTP',
                  hintText: 'e.g., 1234',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _verifyOTP(appState),
                  child: const Text('Verify OTP & Start Job'),
                ),
              ),
            ] else if (currentJob.status == JobStatus.inProgress) ...[
              const SizedBox(height: 16),
              Text('Repair in Progress', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green)),
              const SizedBox(height: 32),
              const Text('Generate Final Bill:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _partsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Parts Cost (₹)',
                  prefixIcon: Icon(Icons.build),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _serviceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Additional Service Charge (₹)',
                  prefixIcon: Icon(Icons.handyman),
                ),
              ),
              const SizedBox(height: 16),
              Text('Note: Homing charge of ₹${currentJob.homingCharge} is already collected.', style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _completeJob(appState),
                  child: const Text('Complete Job & Bill'),
                ),
              ),
            ] else ...[
              const Center(child: Text('Job Completed.')),
            ]
          ],
        ),
      ),
    );
  }
}
