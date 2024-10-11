import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class PastProjectsScreen extends StatelessWidget {
  final List<String> pdfPaths;

  const PastProjectsScreen({super.key, required this.pdfPaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Projects'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pdfPaths.isEmpty
            ? const Center(child: Text('No projects found.'))
            : ListView.builder(
                itemCount: pdfPaths.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Project ${index + 1}'),
                      subtitle: Text(pdfPaths[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () async {
                          _openPDF(pdfPaths[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _openPDF(String filePath) {
    OpenFile.open(filePath);
  }
}
