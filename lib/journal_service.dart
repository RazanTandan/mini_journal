import 'package:cloud_firestore/cloud_firestore.dart';

class JournalService {
  // This gives us a reference to the 'entries' collection in Firestore
  final CollectionReference _entries = FirebaseFirestore.instance.collection(
    'entries',
  );

  // ADD a new journal entry
  Future<void> addEntry(Map<String, dynamic> entry) async {
    await _entries.add({
      ...entry, // spread the map (title, body, date)
      'timestamp':
          FieldValue.serverTimestamp(), // Firestore adds the exact time
    });
  }

  // DELETE an entry by its Firestore document ID
  Future<void> deleteEntry(String id) async {
    await _entries.doc(id).delete();
  }

  // GET all entries as a real-time stream, newest first
  Stream<List<Map<String, dynamic>>> getEntries() {
    return _entries
        .orderBy('timestamp', descending: true)
        .snapshots() // snapshots() = live updates, fires every time data changes
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {
              'id': doc.id, // Firestore's auto-generated document ID
              ...doc.data() as Map<String, dynamic>,
            };
          }).toList();
        });
  }
}
