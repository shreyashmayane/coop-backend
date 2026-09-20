import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/worker_provider.dart';
import '../../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIdx = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkerProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final worker = context.watch<WorkerProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── App Bar ────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacingMd, AppTheme.spacingMd,
                      AppTheme.spacingMd, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${auth.user?.name.split(' ').first ?? 'there'} 👋',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'What service do you need today?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.profile),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.surfaceLight,
                          child: Text(
                            (auth.user?.name[0] ?? 'U').toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Search Bar ────────────────────────────────────────────────
              // ── Guest banner (shown only in guest mode) ───────────────────
              if (auth.isGuest)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacingMd, AppTheme.spacingMd,
                        AppTheme.spacingMd, 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(
                            color: const Color(0xFFF59E0B).withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: Color(0xFFF59E0B), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Browsing as Guest — sign in to book services',
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 12,
                                        color: const Color(0xFFF59E0B),
                                      ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              final nav = Navigator.of(context);
                              await context.read<AuthProvider>().logout();
                              nav.pushReplacementNamed(AppRoutes.login);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xFFF59E0B),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // ── Search Bar ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppTheme.onSurface),
                        const SizedBox(width: 10),
                        Text(
                          'Search for a service...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ── Banner ────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacingMd, 0,
                      AppTheme.spacingMd, AppTheme.spacingLg),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.primaryShadow,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Emergency Service?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Get a worker in under 30 mins',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(AppRoutes.workerList),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Book Now',
                                    style: TextStyle(fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.electric_bolt_rounded,
                            size: 60, color: Colors.white24),
                      ],
                    ),
                  ),
                ),
              ),
              // ── Category heading ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd),
                  child: Text(
                    'Services',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              // ── Grid ──────────────────────────────────────────────────────
              worker.loading
                  ? const SliverToBoxAdapter(
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            color: AppTheme.primary),
                      )),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final cat = worker.categories[i];
                            return ServiceCard(
                              category: cat,
                              onTap: () async {
                                final nav = Navigator.of(context);
                                await context
                                    .read<WorkerProvider>()
                                    .loadNearbyWorkers(cat);
                                nav.pushNamed(AppRoutes.workerList);
                              },
                            );
                          },
                          childCount: worker.categories.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.85,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
      // ── Bottom Nav ─────────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.divider)),
        ),
        child: BottomNavigationBar(
          currentIndex: _navIdx,
          onTap: (i) {
            setState(() => _navIdx = i);
            if (i == 1) Navigator.of(context).pushNamed(AppRoutes.history);
            if (i == 2) Navigator.of(context).pushNamed(AppRoutes.profile);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
