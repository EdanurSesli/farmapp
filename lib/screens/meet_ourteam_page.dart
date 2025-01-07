import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMember {
  final String name;
  final String title;
  final String skills;
  final String experience;
  final String imagePath;
  final Map<String, String> socialLinks;

  TeamMember({
    required this.name,
    required this.title,
    required this.skills,
    required this.experience,
    required this.imagePath,
    required this.socialLinks,
  });
}

class MeetOurTeamPage extends StatelessWidget {
  final List<TeamMember> profiles = [
    TeamMember(
      name: "Cem Taşkın",
      title: "Dr. Öğretim Üyesi",
      skills: "Project Manager",
      experience: "Çok yıllık deneyim",
      imagePath: 'assets/images/cemhoca.jpg',
      socialLinks: {
        "linkedin": "https://www.linkedin.com/in/cem-ta%C5%9Fkin-aa593b142/",
        "github": "https://github.com/cemtaskin",
      },
    ),
    TeamMember(
      name: "İrem Elif Gül",
      title: "Frontend Developer",
      skills: "ReactJS",
      experience: "1 yıla yakın deneyim",
      imagePath: 'assets/images/iremelif.jpg',
      socialLinks: {
        "instagram": "https://www.instagram.com/iremelfgl/",
        "linkedin": "https://www.linkedin.com/in/ielifgul/",
        "github": "https://github.com/iegul",
      },
    ),
    TeamMember(
      name: "Ecem Hatice Özkan",
      title: "Backend Developer",
      skills: "C#",
      experience: "1 yıla yakın deneyim",
      imagePath: 'assets/images/ecem.jpg',
      socialLinks: {
        "instagram": "https://www.instagram.com/ecemzkn_/",
        "linkedin": "https://www.linkedin.com/in/ecemhaticeozkan17/",
        "github": "https://github.com/ehatice",
      },
    ),
    TeamMember(
      name: "Elif Edanur Sesli",
      title: "Mobile Developer",
      skills: "Flutter",
      experience: "1 yıla yakın deneyim",
      imagePath: 'assets/images/eda.jpg',
      socialLinks: {
        "instagram": "https://www.instagram.com/edanurseslii/",
        "linkedin": "https://www.linkedin.com/in/elifedanursesli/",
        "github": "https://github.com/EdanurSesli",
      },
    ),
    TeamMember(
      name: "Barış Deniz Özcan",
      title: "Backend Developer",
      skills: "C#",
      experience: "1 yıla yakın deneyim",
      imagePath: 'assets/images/baris.jpg',
      socialLinks: {
        "instagram": "https://www.instagram.com/barisdenizo/",
        "linkedin": "https://www.linkedin.com/in/baris-ozcann/",
        "github": "https://github.com/Baris007",
      },
    ),
  ];

  void _launchURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bağlantı açılamadı: $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bizi Tanıyın',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(profile.imagePath),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${profile.title} (${profile.skills})',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          profile.experience,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (profile.socialLinks["instagram"] != null)
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.pink,
                                ),
                                onPressed: () {
                                  _launchURL(context,
                                      profile.socialLinks["instagram"]!);
                                },
                              ),
                            if (profile.socialLinks["linkedin"] != null)
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  _launchURL(context,
                                      profile.socialLinks["linkedin"]!);
                                },
                              ),
                            if (profile.socialLinks["github"] != null)
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.github,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _launchURL(
                                      context, profile.socialLinks["github"]!);
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
