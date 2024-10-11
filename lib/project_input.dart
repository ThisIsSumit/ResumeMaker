import 'package:flutter/material.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';

class ProjectInputScreen extends StatefulWidget {
  final Function(Project) onSave;

  const ProjectInputScreen({super.key, required this.onSave});

  @override
  _ProjectInputScreenState createState() => _ProjectInputScreenState();
}

class _ProjectInputScreenState extends State<ProjectInputScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _bullets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final project = Project(
                title: _titleController.text,
                githubLink: _githubController.text,
                description: _descriptionController.text,
                bullets: _bullets,
              );
              widget.onSave(project);
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
              decoration: const InputDecoration(labelText: 'Project Title'),
            ),
            TextField(
              controller: _githubController,
              decoration: const InputDecoration(labelText: 'GitHub Link'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            const Text('Add Bullet Points'),
            TextField(
              onSubmitted: (value) {
                setState(() {
                  _bullets.add(value);
                });
              },
            ),
            Wrap(
              children: _bullets
                  .map((bullet) => Chip(
                        label: Text(bullet),
                        onDeleted: () {
                          setState(() {
                            _bullets.remove(bullet);
                          });
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
