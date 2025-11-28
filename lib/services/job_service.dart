import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'jobs';

  Stream<List<JobModel>> getActiveJobs() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JobModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> publishJob(JobModel job) async {
    await _firestore.collection(_collection).doc(job.id).set(job.toJson());
  }
}