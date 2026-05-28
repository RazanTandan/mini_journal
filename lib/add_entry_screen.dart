import 'package:flutter/material.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  int _wordCount = 0;

  void _onBodyChanged(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    setState(() {
      _wordCount = value.trim().isEmpty ? 0 : words.length;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverLimit = _wordCount > 250;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              onChanged: _onBodyChanged,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: 'Write your thoughts...',
                border: const OutlineInputBorder(),
                errorText: isOverLimit ? 'Exceeded 250 word limit' : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_wordCount / 250 words',
              style: TextStyle(color: isOverLimit ? Colors.red : Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isOverLimit
            ? null
            : () {
                final now = DateTime.now();
                final entry = {
                  'title': _titleController.text.trim().isEmpty
                      ? 'Untitled'
                      : _titleController.text.trim(),
                  'body': _bodyController.text.trim(),
                  'date': '${now.day}/${now.month}/${now.year}',
                };
                Navigator.pop(context, entry);
              },
        child: const Icon(Icons.check),
      ),
    );
  }
}
