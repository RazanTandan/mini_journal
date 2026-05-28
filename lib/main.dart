import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'add_entry_screen.dart';
import 'entry_detail_screen.dart';
import 'journal_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before any async work
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(61, 23, 10, 168),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // The JournalService stream is our state now.
  final _service = JournalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Journal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // StreamBuilder listens to the stream and rebuilds whenever data changes
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.getEntries(),
        builder: (context, snapshot) {
          // While waiting for first data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If something went wrong
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return const Center(
              child: Text('No journals yet. Tap + to add one!'),
            );
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Dismissible(
                key: Key(entry['id']), // use Firestore document ID as key
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  // Delete from Firestore
                  await _service.deleteEntry(entry['id']);
                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(entry['title']),
                    subtitle: Text(entry['date']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryDetailScreen(entry: entry),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // No need for async/await here anymore
          // AddEntryScreen saves directly to Firestore itself
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
