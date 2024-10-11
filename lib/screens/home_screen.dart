import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resume_pdf_app/data/pastprojects.dart';

import 'package:resume_pdf_app/screens/add_new_resume.dart';
import 'package:resume_pdf_app/screens/pdf_preview_page.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';

class HomeScreen extends StatefulWidget {
  
   HomeScreen({ super.key});
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock list of resume data


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes')),
      body: pastResumes.isEmpty
          ? const Center(child: Text('No resumes found.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: pastResumes.length,
                itemBuilder: (context, index) {
                  final resumeData = pastResumes[index];
                  final modifiedDate = DateFormat('yyyy-MM-dd HH:mm')
                      .format(DateTime.now()); // Placeholder for modified date
                  final fileName = resumeData.name;

                  return _buildResumeCard(
                    fileName: fileName,
                    modifiedDate: modifiedDate,
                    resumeData: resumeData,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewResume(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResumeCard({
    required String fileName,
    required String modifiedDate,
    required ResumeData resumeData,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFPreviewPage(
              resumeData: resumeData,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Modified: $modifiedDate',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
