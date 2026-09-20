import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import 'verification_pending_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  final List<String> skills;
  
  const DocumentUploadScreen({super.key, required this.skills});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  bool _idUploaded = false;
  bool _certUploaded = false;

  void _uploadDoc(String type) async {
    // Mock image picker / upload delay
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading $type...')));
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (type == 'ID') _idUploaded = true;
      if (type == 'Cert') _certUploaded = true;
    });
  }

  void _submitProfile() async {
    // TODO: Send data to backend /worker/profile
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile submitted!')));
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VerificationPendingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Documents')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify Your Identity',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Please provide clear photos of your documents to get verified by your cooperative.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurface),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            
            _buildUploadCard('Government ID', 'Aadhaar, PAN, or Voter ID', _idUploaded, () => _uploadDoc('ID')),
            const SizedBox(height: AppTheme.spacingMd),
            _buildUploadCard('Certifications (Optional)', 'Trade licenses or diplomas', _certUploaded, () => _uploadDoc('Cert')),
            
            const Spacer(),
            ElevatedButton(
              onPressed: _idUploaded ? _submitProfile : null,
              child: const Text('Submit for Verification'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(String title, String subtitle, bool isUploaded, VoidCallback onTap) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppTheme.spacingMd),
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.upload_file,
          color: isUploaded ? AppTheme.success : AppTheme.primary,
          size: 40,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: isUploaded 
            ? const Text('Uploaded', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold))
            : OutlinedButton(
                onPressed: onTap,
                child: const Text('Upload'),
              ),
      ),
    );
  }
}
