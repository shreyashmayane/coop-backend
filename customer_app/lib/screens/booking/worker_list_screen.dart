import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/worker_provider.dart';
import '../../widgets/worker_card.dart';

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerProvider>();
    final category = provider.selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Workers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              // TODO: Sort/filter sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter coming soon')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: provider.loading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primary))
            : provider.workers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_search_rounded,
                            size: 64, color: AppTheme.onSurface),
                        const SizedBox(height: 16),
                        Text(
                          'No workers found nearby',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different service or location',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    itemCount: provider.workers.length,
                    itemBuilder: (ctx, i) {
                      final w = provider.workers[i];
                      return WorkerCard(
                        worker: w,
                        onTap: () async {
                          await context
                              .read<WorkerProvider>()
                              .selectWorker(w.id);
                          if (!context.mounted) return;
                          Navigator.of(context)
                              .pushNamed(AppRoutes.workerProfile);
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
