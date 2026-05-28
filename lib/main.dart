import 'package:flutter/material.dart';
import 'add_entry_screen.dart';
import 'entry_detail_screen.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> entries = [];

  void _addEntry(Map<String, String> entry) {
    setState(() {
      entries.insert(0, entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Journal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: entries.isEmpty
          ? const Center(child: Text('No journals yet. Tap + to add one!'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                // REPLACE the existing Card in ListView.builder
                return Dismissible(
                  key: Key(entry['date']! + index.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    setState(() {
                      entries.removeAt(index);
                    });
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
                      title: Text(entry['title']!),
                      subtitle: Text(entry['date']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EntryDetailScreen(entry: entry),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEntry = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );
          if (newEntry != null) {
            _addEntry(newEntry);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
