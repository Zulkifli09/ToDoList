import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/features/task/presentation/providers/task_provider.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final taskState = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics'), centerTitle: true),
      body: SafeArea(
        child: taskState.when(
          data: (tasks) {
            final completedTasks = tasks.where((t) => t.isCompleted).length;
            final totalTasks = tasks.length;
            final completionRate = totalTasks == 0
                ? 0.0
                : completedTasks / totalTasks;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompletionHeroCard(
                    theme,
                    completionRate,
                    completedTasks,
                    totalTasks,
                  ),
                  const SizedBox(height: 32),
                  Text('Weekly Overview', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildWeeklyBarChart(theme, tasks),
                  const SizedBox(height: 32),
                  Text('Category Focus', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildCategoryPieChart(theme, tasks),
                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildCompletionHeroCard(
    ThemeData theme,
    double rate,
    int completed,
    int total,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completion Rate',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(rate * 100).toInt()}%',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$completed of $total tasks completed',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBarChart(ThemeData theme, List<TaskModel> tasks) {
    // Generate dummy data based on actual tasks or just a nice visual for the dashboard
    // In a real app, this would calculate completed tasks per day for the last 7 days.
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt() % 7],
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _buildBar(0, 5, theme),
            _buildBar(1, 3, theme),
            _buildBar(2, 7, theme),
            _buildBar(3, 4, theme),
            _buildBar(4, 8, theme),
            _buildBar(5, 6, theme),
            _buildBar(6, 9, theme),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBar(int x, double y, ThemeData theme) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: theme.colorScheme.primary,
          width: 16,
          borderRadius: BorderRadius.circular(8),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPieChart(ThemeData theme, List<TaskModel> tasks) {
    // A simple pie chart mapping categories.
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(
              color: Colors.blue,
              value: 40,
              title: '40%',
              radius: 40,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              color: Colors.green,
              value: 30,
              title: '30%',
              radius: 40,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: 15,
              title: '15%',
              radius: 40,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              color: Colors.purple,
              value: 15,
              title: '15%',
              radius: 40,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
