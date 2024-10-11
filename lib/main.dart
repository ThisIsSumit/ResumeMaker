import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';

import 'package:resume_pdf_app/past_projects.dart';
import 'package:resume_pdf_app/pdf_preview_page.dart';
import 'package:resume_pdf_app/project_input.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Resume PDF',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;

  // Controllers for each input field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  final ResumeData _resumeData = ResumeData(
    name: '',
    email: '',
    phone: '',
    github: '',
    summary: '',
    skills: [],
    experiences: [],
    education: [],
    projects: [],
    extracurriculars: [],
    positionsOfResponsibility: [],
  );

  List<String> _pdfPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resume'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableField('Name', _nameController,
                  (value) => setState(() => _resumeData.name = value)),
              _buildEditableField('Email', _emailController,
                  (value) => setState(() => _resumeData.email = value)),
              _buildEditableField('Phone', _phoneController,
                  (value) => setState(() => _resumeData.phone = value)),
              _buildEditableField('GitHub', _githubController,
                  (value) => setState(() => _resumeData.github = value)),
              _buildEditableField('Summary', _summaryController,
                  (value) => setState(() => _resumeData.summary = value),
                  maxLines: 5),
              const SizedBox(height: 20),
              Text('Skills', style: Theme.of(context).textTheme.titleLarge),
              Wrap(
                spacing: 8,
                children: _resumeData.skills
                    .map((skill) => Chip(
                          label: Text(skill),
                          onDeleted: () {
                            setState(() {
                              _resumeData.skills.remove(skill);
                            });
                          },
                        ))
                    .toList(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Add Skill'),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _resumeData.skills.add(value);
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildSectionButton(context, 'Add Project', _addProjectSection,
                  _resumeData.projects),
              _buildSectionButton(context, 'Add Position of Responsibility',
                  _addPoRSection, _resumeData.positionsOfResponsibility),
              _buildSectionButton(context, 'Add Extracurricular',
                  _addExtracurricularSection, _resumeData.extracurriculars),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Generate PDF'),
                onPressed: () async {
                  String pdfPath = await _generatePdf();
                  setState(() {
                    _pdfPaths.add(pdfPath);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFPreviewPage(
                          resumeData: _resumeData, isDarkMode: _isDarkMode),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('View Past Projects'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastProjectsScreen(pdfPaths: _pdfPaths),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Resume for ${_resumeData.name}'),
        ); // Replace with your resume content
      },
    ));

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${_resumeData.name}_resume.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Widget _buildEditableField(String label, TextEditingController controller, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildSectionButton(BuildContext context, String label,
      Function(BuildContext) addSectionFunction, List list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        Wrap(
          children: list
              .map((item) => Chip(
                    label: Text(item.title ?? ''),
                    onDeleted: () {
                      setState(() {
                        list.remove(item);
                      });
                    },
                  ))
              .toList(),
        ),
        ElevatedButton(
          onPressed: () => addSectionFunction(context),
          child: Text('Add $label'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _addProjectSection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectInputScreen(
          onSave: (project) {
            setState(() {
              _resumeData.projects.add(project);
            });
          },
        ),
      ),
    );
  }

  void _addPoRSection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoRInputScreen(
          onSave: (position) {
            setState(() {
              _resumeData.positionsOfResponsibility.add(position);
            });
          },
        ),
      ),
    );
  }

  void _addExtracurricularSection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExtraInputScreen(
          onSave: (activity) {
            setState(() {
              _resumeData.extracurriculars.add(activity);
            });
          },
        ),
      ),
    );
  }
}



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
