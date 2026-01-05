import 'package:cloud_firestore/cloud_firestore.dart';

class JobAnalyticsModel {
  final String jobId;
  final String jobTitle;
  final int totalApplications;
  final Map<String, int> statusDistribution;
  final DateTime postedDate;
  final String status;

  JobAnalyticsModel({
    required this.jobId,
    required this.jobTitle,
    required this.totalApplications,
    required this.statusDistribution,
    required this.postedDate,
    required this.status,
  });

  factory JobAnalyticsModel.fromFirestore(
    DocumentSnapshot jobDoc,
    List<QueryDocumentSnapshot> applications,
  ) {
    final jobData = jobDoc.data() as Map<String, dynamic>;
    
    final statusCount = <String, int>{};
    for (var app in applications) {
      final data = app.data() as Map<String, dynamic>;
      final status = data['status'] ?? 'pending';
      statusCount[status] = (statusCount[status] ?? 0) + 1;
    }

    const allStatuses = ['pending', 'reviewing', 'interview', 'accepted', 'rejected'];
    for (var status in allStatuses) {
      statusCount.putIfAbsent(status, () => 0);
    }

    return JobAnalyticsModel(
      jobId: jobDoc.id,
      jobTitle: jobData['jobTitle'] ?? 'Untitled Job',
      totalApplications: applications.length,
      statusDistribution: statusCount,
      postedDate: (jobData['postedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: jobData['status'] ?? 'active',
    );
  }
}