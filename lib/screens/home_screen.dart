import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:resume_pdf_app/screens/add_new_resume.dart';

class HomeScreen extends StatefulWidget {
  final List<String> pdfPaths;

  const HomeScreen({super.key, required this.pdfPaths});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes'), actions: []),
      body: widget.pdfPaths.isEmpty
          ? const Center(child: Text('No projects found.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: widget.pdfPaths.length,
                itemBuilder: (context, index) {
                  final filePath = widget.pdfPaths[index];
                  return FutureBuilder<FileStat>(
                    future: _getFileStat(filePath),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final fileStat = snapshot.data!;
                        final modifiedDate = DateFormat('yyyy-MM-dd HH:mm')
                            .format(fileStat.modified);
                        final fileName = filePath.split('/').last;

                        return _buildProjectCard(
                          fileName: fileName,
                          modifiedDate: modifiedDate,
                          filePath: filePath,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewResume(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<FileStat> _getFileStat(String filePath) async {
    final file = File(filePath);
    return await file.stat();
  }

  Widget _buildProjectCard({
    required String fileName,
    required String modifiedDate,
    required String filePath,
  }) {
    return GestureDetector(
      onTap: () => _openPDF(filePath),
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

  void _openPDF(String filePath) {
    OpenFile.open(filePath);
  }
}
