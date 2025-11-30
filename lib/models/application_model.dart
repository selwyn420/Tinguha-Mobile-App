import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String id;
  final String userId;
  final String jobId;
  final String status;
  final DateTime appliedDate;
  final String? jobTitle;
  final String? companyName;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.status,
    required this.appliedDate,
    this.jobTitle,
    this.companyName,
  });

  factory ApplicationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ApplicationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      jobId: data['jobId'] ?? '',
      status: data['status'] ?? 'pending',
      appliedDate: (data['appliedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      jobTitle: data['jobTitle'],
      companyName: data['companyName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'jobId': jobId,
      'status': status,
      'appliedDate': Timestamp.fromDate(appliedDate),
      'jobTitle': jobTitle,
      'companyName': companyName,
    };
  }
}