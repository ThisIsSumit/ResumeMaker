import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:resume_pdf_app/data/pastprojects.dart';
import 'package:resume_pdf_app/models/resume_secrions.dart';
import 'package:resume_pdf_app/screens/add_new_resume.dart';
import 'package:resume_pdf_app/screens/pdf_preview_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Resumes')),
      body: pastResumes.isEmpty
          ? const Center(child: Text('No resumes found.'))
          : Swiper(
              itemCount: pastResumes.length,
              itemBuilder: (BuildContext context, int index) {
                final resumeData = pastResumes[index];
                return _buildResumeCard(resumeData: resumeData);
              },
              viewportFraction: 0.85,
              scale: 0.9,
              autoplay: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewResume(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResumeCard({required ResumeData resumeData}) {
    return Card(
      elevation: 4,
      surfaceTintColor: Colors.grey,
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resumeData.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Modified: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildContactInfo(resumeData),
              if (resumeData.summary.isNotEmpty)
                _buildSection('Summary', [resumeData.summary]),
              if (resumeData.skills.isNotEmpty)
                _buildSection('Skills', resumeData.skills),
              if (resumeData.projects.isNotEmpty)
                _buildProjectsSection(resumeData.projects),
              if (resumeData.positionsOfResponsibility.isNotEmpty)
                _buildPoRSection(resumeData.positionsOfResponsibility),
              if (resumeData.extracurriculars.isNotEmpty)
                _buildExtracurricularSection(resumeData.extracurriculars),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PDFPreviewPage(resumeData: resumeData),
                      ),
                    );
                  },
                  child: const Text('View Resume'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(ResumeData resumeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email: ${resumeData.email}'),
        Text('Phone: ${resumeData.phone}'),
        Text('GitHub: ${resumeData.github}'),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProjectsSection(List<Project> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Projects',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...projects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (project.githubLink != null)
                    Text('GitHub: ${project.githubLink}'),
                  if (project.description != null) Text(project.description!),
                  ...project.bullets.map((bullet) => Padding(
                        padding: const EdgeInsets.only(left: 16, top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(bullet)),
                          ],
                        ),
                      )),
                ],
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPoRSection(List<PoR> positionsOfResponsibility) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Positions of Responsibility',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...positionsOfResponsibility.map((por) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(por.title ?? ''),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExtracurricularSection(List<Extracurricular> extracurriculars) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Extracurricular Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...extracurriculars.map((extra) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(extra.title ?? ''),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
