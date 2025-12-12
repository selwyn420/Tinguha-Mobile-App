import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Search across both collections (case-insensitive, single-letter enabled)
  Future<List<Map<String, String>>> searchUsersByName(String query) async {
    if (query.trim().isEmpty) return [];
    
    try {
      final jobSeekersSnapshot = await _firestore.collection('job_seekers').get();
      final companiesSnapshot = await _firestore.collection('companies').get();
      
      List<Map<String, String>> allUsers = [];
      
      allUsers.addAll(jobSeekersSnapshot.docs.map((doc) {
        final data = doc.data();
        final personalInfo = data['personal_info'] as Map<String, dynamic>?;
        final firstName = personalInfo?['first_name'] ?? '';
        final lastName = personalInfo?['last_name'] ?? '';
        return {
          'userId': doc.id,
          'name': '$firstName $lastName'.trim(),
          'role': 'job_seeker',
        };
      }));
      
      allUsers.addAll(companiesSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'name': data['company_name'] ?? 'Unknown Company',
          'role': 'company',
        };
      }));
      
      final searchLower = query.trim().toLowerCase();
      return allUsers.where((user) => 
        (user['name'] ?? '').toLowerCase().contains(searchLower)
      ).toList();
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  /// Get user from correct collection
  Future<Map<String, String>> getUser(String userId) async {
    try {
      final jobSeekerDoc = await _firestore.collection('job_seekers').doc(userId).get();
      if (jobSeekerDoc.exists) {
        final data = jobSeekerDoc.data();
        final personalInfo = data?['personal_info'] as Map<String, dynamic>?;
        final firstName = personalInfo?['first_name'] ?? '';
        final lastName = personalInfo?['last_name'] ?? '';
        return {
          'userId': userId,
          'name': '$firstName $lastName'.trim(),
        };
      }
      
      final companyDoc = await _firestore.collection('companies').doc(userId).get();
      if (companyDoc.exists) {
        return {
          'userId': userId,
          'name': companyDoc.data()?['company_name'] ?? 'Unknown Company',
        };
      }
      
      return {'userId': userId, 'name': 'Unknown User'};
    } catch (e) {
      print('Error fetching user: $e');
      return {'userId': userId, 'name': 'Unknown User'};
    }
  }

  /// Get the current user's display name from Firestore
  Future<String> getCurrentUserName(String userId) async {
    try {
      // Check job_seekers collection first
      final jobSeekerDoc = await _firestore.collection('job_seekers').doc(userId).get();
      if (jobSeekerDoc.exists) {
        final data = jobSeekerDoc.data();
        final personalInfo = data?['personal_info'] as Map<String, dynamic>?;
        final firstName = personalInfo?['first_name'] ?? '';
        final lastName = personalInfo?['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim();
        return fullName.isNotEmpty ? fullName : 'User';
      }
      
      // Check companies collection
      final companyDoc = await _firestore.collection('companies').doc(userId).get();
      if (companyDoc.exists) {
        return companyDoc.data()?['company_name'] ?? 'Company';
      }
      
      return 'User'; // Fallback
    } catch (e) {
      print('Error fetching user name: $e');
      return 'User'; // Error fallback
    }
  }
}