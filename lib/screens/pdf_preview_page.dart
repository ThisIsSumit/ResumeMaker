import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:resume_pdf_app/data/pdfpaths.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:resume_pdf_app/screens/home_screen.dart';

class PDFPreviewPage extends StatelessWidget {
  final ResumeData resumeData;


  const PDFPreviewPage(
      {super.key, required this.resumeData,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(pdfPaths: pdfPaths)));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: PdfPreview(
        build: (format) => _generateResumePdf(format),
      ),
    );
  }

  Future<Uint8List> _generateResumePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(resumeData.name, style: const pw.TextStyle(fontSize: 24)),
              pw.Text(resumeData.email),
              pw.Text(resumeData.phone),
              if (resumeData.github.isNotEmpty)
                pw.Text('GitHub: ${resumeData.github}'),
              pw.SizedBox(height: 16),
              pw.Text(resumeData.summary),
              pw.SizedBox(height: 16),
              if (resumeData.skills.isNotEmpty) _buildSkillsSection(),
              if (resumeData.projects.isNotEmpty) _buildProjectsSection(),
              if (resumeData.positionsOfResponsibility.isNotEmpty)
                _buildPoRSection(),
              if (resumeData.extracurriculars.isNotEmpty)
                _buildExtracurricularSection(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildSkillsSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Skills', style: const pw.TextStyle(fontSize: 18)),
        pw.Bullet(text: resumeData.skills.join(', ')),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildProjectsSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Projects', style: const pw.TextStyle(fontSize: 18)),
        for (final project in resumeData.projects)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(project.title ?? ''),
              if (project.githubLink!.isNotEmpty)
                pw.Text('GitHub: ${project.githubLink}',
                    style: const pw.TextStyle(fontSize: 12)),
              pw.Bullet(text: project.description ?? ''),
              for (final bullet in project.bullets) pw.Bullet(text: bullet),
              pw.SizedBox(height: 8),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildPoRSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Positions of Responsibility',
            style: const pw.TextStyle(fontSize: 18)),
        for (final por in resumeData.positionsOfResponsibility)
          pw.Bullet(text: por.title ?? ''),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildExtracurricularSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Extracurricular Activities',
            style: const pw.TextStyle(fontSize: 18)),
        for (final activity in resumeData.extracurriculars)
          pw.Bullet(text: activity.title ?? ''),
        pw.SizedBox(height: 8),
      ],
    );
  }
}
