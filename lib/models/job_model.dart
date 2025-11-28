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
  final String? companyId;

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
    this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'employmentType': employmentType,
      'jobDescription': jobDescription,
      'requirements': requirements,
      'status': status,
      'postedDate': postedDate,
      'companyId': companyId,
    };
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
      location: json['location'],
      employmentType: json['employmentType'],
      jobDescription: json['jobDescription'],
      requirements: json['requirements'],
      status: json['status'],
      postedDate: (json['postedDate'] as Timestamp).toDate(),
      companyId: json['companyId'],
    );
  }
}