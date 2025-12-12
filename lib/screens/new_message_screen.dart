import 'package:flutter/material.dart';
import 'compose_message_screen.dart';
import '../../services/user_service.dart';

class NewMessageScreen extends StatefulWidget {
  final String currentUserId;
  const NewMessageScreen({super.key, required this.currentUserId});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await _userService.searchUsersByName(query.trim());
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _selectRecipient(String recipientId, String recipientName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeMessageScreen(
          recipientId: recipientId,
          currentUserId: widget.currentUserId,
          recipientName: recipientName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message'), backgroundColor: Colors.blueAccent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _isSearching
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); setState(() => _searchResults = []); }),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search, size: 64, color: Colors.grey[400]), const SizedBox(height: 16.0), Text(_searchController.text.isEmpty ? 'Search for a user by name' : 'No users found', style: const TextStyle(fontSize: 16.0, color: Colors.grey))]))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return Card(margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), child: ListTile(leading: CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.person, color: Colors.white)), title: Text(user['name'] ?? 'Unknown User'), subtitle: Text(user['role'] == 'company' ? 'Company' : 'Job Seeker', style: TextStyle(fontSize: 12)), onTap: () => _selectRecipient(user['userId']!, user['name']!)));
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}