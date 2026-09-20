import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import 'document_upload_screen.dart';

class SkillSelectionScreen extends StatefulWidget {
  const SkillSelectionScreen({super.key});

  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  final List<String> _availableSkills = [
    'Electrician', 'Plumber', 'Carpenter', 'Painter',
    'Cleaner', 'Driver', 'Gardener', 'Caregiver'
  ];
  final Set<String> _selectedSkills = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Skills')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What services do you provide?',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Select all that apply to receive relevant job requests.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurface),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            Expanded(
              child: Wrap(
                spacing: AppTheme.spacingMd,
                runSpacing: AppTheme.spacingMd,
                children: _availableSkills.map((skill) {
                  final isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _selectedSkills.isEmpty ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DocumentUploadScreen(skills: _selectedSkills.toList()),
                  ),
                );
              },
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
