import 'package:flutter/material.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';

class ExtraInputScreen extends StatefulWidget {
  final Function(Extracurricular) onSave;

  const ExtraInputScreen({super.key, required this.onSave});

  @override
  _ExtraInputScreenState createState() => _ExtraInputScreenState();
}

class _ExtraInputScreenState extends State<ExtraInputScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Extracurricular'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final extracurricular = Extracurricular(
                title: _titleController.text,
              );
              widget.onSave(extracurricular);
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
              decoration: const InputDecoration(labelText: 'Activity Title'),
            ),
          ],
        ),
      ),
    );
  }
}
