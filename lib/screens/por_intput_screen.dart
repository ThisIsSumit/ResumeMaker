import 'package:flutter/material.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';

class PoRInputScreen extends StatefulWidget {
  final Function(PoR) onSave;

  const PoRInputScreen({super.key, required this.onSave});

  @override
  _PoRInputScreenState createState() => _PoRInputScreenState();
}

class _PoRInputScreenState extends State<PoRInputScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Position of Responsibility'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final por = PoR(
                title: _titleController.text,
              );
              widget.onSave(por);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Position Title'),
            ),
          ],
        ),
      ),
    );
  }
}
