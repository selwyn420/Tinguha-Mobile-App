import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> searchUsersByName(String query) async {
    if (query.trim().length < 2) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query.trim())
          .where('name', isLessThanOrEqualTo: '${query.trim()}\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return <String, String>{
          'userId': doc.id,
          'name': (data['name'] as String?) ?? 'Unknown User', // ✅ Cast to String?
        };
      }).toList();
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  // FIXED: Proper type casting
  Future<Map<String, String>> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return <String, String>{
          'userId': doc.id,
          'name': (data?['name'] as String?) ?? 'Unknown User', // ✅ Cast to String?
        };
      }
      return {'userId': userId, 'name': 'Unknown User'};
    } catch (e) {
      print('Error fetching user: $e');
      return {'userId': userId, 'name': 'Unknown User'};
    }
  }
}