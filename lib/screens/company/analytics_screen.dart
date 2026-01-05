import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/job_analytics_model.dart';
import '../../services/application_service.dart';
import '../../services/job_service.dart';

class CompanyAnalyticsScreen extends StatefulWidget {
  const CompanyAnalyticsScreen({super.key});

  @override
  State<CompanyAnalyticsScreen> createState() => _CompanyAnalyticsScreenState();
}

class _CompanyAnalyticsScreenState extends State<CompanyAnalyticsScreen> {
  final ApplicationService _applicationService = ApplicationService();
  final JobService _jobService = JobService();
  
  String get companyId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Analytics'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<JobAnalyticsModel>>(
        stream: _applicationService.getCompanyAnalytics(companyId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final analytics = snapshot.data ?? [];
          
          if (analytics.isEmpty) {
            return _buildEmptyState();
          }

          return _buildAnalyticsContent(analytics);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No analytics data available', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const Text('Post jobs to see performance metrics', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(List<JobAnalyticsModel> analytics) {
    // Calculate KPIs
    final totalJobs = analytics.length;
    final totalApplications = analytics.fold<int>(0, (sum, job) => sum + job.totalApplications);
    final avgApplications = totalJobs > 0 ? (totalApplications / totalJobs).toStringAsFixed(1) : '0';
    
    // Calculate overall response rate
    int respondedApps = 0;
    for (var job in analytics) {
      respondedApps += (job.statusDistribution['interview'] ?? 0) + 
                       (job.statusDistribution['accepted'] ?? 0) + 
                       (job.statusDistribution['rejected'] ?? 0);
    }
    final responseRate = totalApplications > 0 ? 
      '${((respondedApps / totalApplications) * 100).toStringAsFixed(1)}%' : '0%';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards
          Row(
            children: [
              _buildKPICard('Active Jobs', totalJobs.toString(), Icons.work),
              const SizedBox(width: 16),
              _buildKPICard('Total Applications', totalApplications.toString(), Icons.people),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildKPICard('Avg per Job', avgApplications, Icons.trending_up),
              const SizedBox(width: 16),
              _buildKPICard('Response Rate', responseRate, Icons.rate_review),
            ],
          ),
          const SizedBox(height: 24),

          // Applications per Job Chart
          _buildSectionTitle('Applications per Job Posting'),
          const SizedBox(height: 12),
          _buildApplicationsBarChart(analytics),
          const SizedBox(height: 24),

          // Status Distribution Chart
          _buildSectionTitle('Application Status Distribution'),
          const SizedBox(height: 12),
          _buildStatusPieChart(analytics),
          const SizedBox(height: 24),

          // Job Performance List
          _buildSectionTitle('Job Performance Details'),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analytics.length,
            itemBuilder: (context, index) => _buildJobPerformanceCard(analytics[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 32),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildApplicationsBarChart(List<JobAnalyticsModel> analytics) {
    final barGroups = analytics.asMap().entries.map((entry) {
      final index = entry.key;
      final job = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: job.totalApplications.toDouble(),
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < analytics.length) {
                        final job = analytics[value.toInt()];
                        return Text(
                          job.jobTitle,
                          style: const TextStyle(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPieChart(List<JobAnalyticsModel> analytics) {
    // Aggregate status across all jobs
    final Map<String, int> totalStatusDistribution = {};
    for (var job in analytics) {
      job.statusDistribution.forEach((status, count) {
        totalStatusDistribution[status] = (totalStatusDistribution[status] ?? 0) + count;
      });
    }

    final colors = {
      'pending': Colors.orange,
      'reviewing': Colors.blue,
      'interview': Colors.purple,
      'accepted': Colors.green,
      'rejected': Colors.red,
    };

    final sections = totalStatusDistribution.entries.map((entry) {
      final status = entry.key;
      final count = entry.value;
      final color = colors[status] ?? Colors.grey;
      return PieChartSectionData(
        value: count.toDouble(),
        title: '${status.toUpperCase()}\n$count',
        color: color,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: PieChart(PieChartData(
            sections: sections,
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          )),
        ),
      ),
    );
  }

  Widget _buildJobPerformanceCard(JobAnalyticsModel analytics) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              analytics.jobTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Applications: ${analytics.totalApplications}', style: const TextStyle(fontSize: 14)),
                _buildStatusChips(analytics),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Posted: ${analytics.postedDate.toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChips(JobAnalyticsModel analytics) {
    final statusOrder = ['pending', 'reviewing', 'interview', 'accepted', 'rejected'];
    final colors = {
      'pending': Colors.orange,
      'reviewing': Colors.blue,
      'interview': Colors.purple,
      'accepted': Colors.green,
      'rejected': Colors.red,
    };

    return Row(
      children: statusOrder.map((status) {
        final count = analytics.statusDistribution[status] ?? 0;
        if (count == 0) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colors[status],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
        );
      }).toList(),
    );
  }
}