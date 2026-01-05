import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'jobs';

  Stream<List<JobModel>> getActiveJobs() {
    return _firestore
        .collection(collection)
        .where('status', isEqualTo: 'active')
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => JobModel.fromFirestore(doc)).toList());
  }

  // Get jobs by company
  Stream<List<JobModel>> getJobsByCompany(String companyId) {
    return _firestore
        .collection(collection)
        .where('companyId', isEqualTo: companyId)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => JobModel.fromFirestore(doc)).toList());
  }

  Future<void> publishJob(JobModel job) async {
    await _firestore.collection(collection).doc(job.id).set(job.toMap());
  }
}