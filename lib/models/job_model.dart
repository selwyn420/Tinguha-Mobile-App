import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String jobTitle;
  final String companyName;
  final String location;
  final String employmentType;
  final String jobDescription;
  final String requirements;
  final String status;
  final DateTime postedDate;
  final String companyId;

  JobModel({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.employmentType,
    required this.jobDescription,
    required this.requirements,
    required this.status,
    required this.postedDate,
    required this.companyId,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // ✅ Provide defaults for ALL fields to handle null values
    return JobModel(
      id: doc.id,
      jobTitle: data['jobTitle'] ?? '',
      companyName: data['companyName'] ?? '',
      location: data['location'] ?? '',
      employmentType: data['employmentType'] ?? '',
      jobDescription: data['jobDescription'] ?? '',
      requirements: data['requirements'] ?? '',
      status: data['status'] ?? 'active',
      postedDate: data['postedDate'] != null 
        ? (data['postedDate'] as Timestamp).toDate() 
        : DateTime.now(),
      companyId: data['companyId'] ?? '', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'employmentType': employmentType,
      'jobDescription': jobDescription,
      'requirements': requirements,
      'status': status,
      'postedDate': Timestamp.fromDate(postedDate),
      'companyId': companyId,
    };
  }
}