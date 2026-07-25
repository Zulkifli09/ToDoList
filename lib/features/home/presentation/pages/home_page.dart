import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_flow/features/task/presentation/providers/task_provider.dart';
import 'package:task_flow/features/task/presentation/widgets/task_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final taskState = ref.watch(taskListProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                title: Text(
                  'Good Morning, Alex',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    child: Icon(Icons.person, color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
            taskState.when(
              data: (tasks) {
                final todayTasks = tasks
                    .where((t) => _isToday(t.date))
                    .toList();
                final upcomingTasks = tasks
                    .where((t) => _isUpcoming(t.date))
                    .toList();

                final completedToday = todayTasks
                    .where((t) => t.isCompleted)
                    .length;
                final totalToday = todayTasks.length;
                final progress = totalToday == 0
                    ? 0.0
                    : completedToday / totalToday;

                return SliverList.list(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgressCard(
                            theme,
                            completedToday,
                            totalToday,
                            progress,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Today\'s Tasks',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    if (todayTasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16.0,
                        ),
                        child: Text('No tasks for today. Enjoy your day!'),
                      )
                    else
                      ...todayTasks.map(
                        (t) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TaskListItem(task: t),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Text(
                        'Upcoming',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    if (upcomingTasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16.0,
                        ),
                        child: Text('No upcoming tasks.'),
                      )
                    else
                      ...upcomingTasks.map(
                        (t) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TaskListItem(task: t),
                        ),
                      ),

                    const SizedBox(height: 100), // padding for FAB
                  ],
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) =>
                  SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isUpcoming(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return date.isAfter(today);
  }

  Widget _buildProgressCard(
    ThemeData theme,
    int completed,
    int total,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completed/$total Tasks',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  progress == 1.0 && total > 0 ? 'All done!' : 'Keep it up!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
