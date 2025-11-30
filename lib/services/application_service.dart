import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';
import '../models/job_model.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'applications';

  // Get all applications for a user
  Stream<List<ApplicationModel>> getUserApplications(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('appliedDate', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => ApplicationModel.fromFirestore(doc)).toList());
  }

  // Check if user already applied
  Future<bool> hasUserApplied(String userId, String jobId) async {
    final querySnapshot = await _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('jobId', isEqualTo: jobId)
        .limit(1)
        .get();
    
    return querySnapshot.docs.isNotEmpty;
  }

  // Apply for a job
  Future<void> applyForJob(String userId, JobModel job) async {
    final hasApplied = await hasUserApplied(userId, job.id);
    if (hasApplied) {
      throw Exception('You have already applied for this job');
    }

    final application = ApplicationModel(
      id: _firestore.collection(collection).doc().id,
      userId: userId,
      jobId: job.id,
      status: 'pending',
      appliedDate: DateTime.now(),
      jobTitle: job.jobTitle,
      companyName: job.companyName,
    );

    await _firestore
        .collection(collection)
        .doc(application.id)
        .set(application.toMap());
  }

  // Get application count for a job
  Stream<int> getJobApplicationCount(String jobId) {
    return _firestore
        .collection(collection)
        .where('jobId', isEqualTo: jobId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}