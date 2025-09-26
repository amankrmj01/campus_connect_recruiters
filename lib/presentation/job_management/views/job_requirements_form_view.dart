import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/job_management.controller.dart';

class JobRequirementsFormView extends GetView<JobManagementController> {
  const JobRequirementsFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Requirements Input
        _buildRequirementsInput(),

        SizedBox(height: 16),

        // Skills & Qualifications
        _buildSkillsSection(),

        SizedBox(height: 16),

        // Education Requirements
        _buildEducationSection(),

        SizedBox(height: 16),

        // Certifications
        _buildCertificationsSection(),
      ],
    );
  }

  Widget _buildRequirementsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Job Requirements',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            TextButton.icon(
              onPressed: _showRequirementsHelper,
              icon: Icon(Icons.help_outline, size: 16),
              label: Text('Need help?', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),

        SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Toolbar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    _buildToolbarButton(
                      Icons.format_list_bulleted,
                      'Add Bullet Point',
                      () {
                        _addBulletPoint();
                      },
                    ),
                    _buildToolbarButton(
                      Icons.format_list_numbered,
                      'Add Numbered Item',
                      () {
                        _addNumberedItem();
                      },
                    ),
                    _buildToolbarButton(
                      Icons.star_outline,
                      'Add Must-Have',
                      () {
                        _addMustHave();
                      },
                    ),
                    _buildToolbarButton(
                      Icons.thumb_up_outlined,
                      'Add Nice-to-Have',
                      () {
                        _addNiceToHave();
                      },
                    ),
                  ],
                ),
              ),

              // Text Area
              TextField(
                controller: controller.requirementsController,
                maxLines: null,
                minLines: 6,
                decoration: InputDecoration(
                  hintText:
                      'Enter job requirements (one per line):\n\nMust-Have:\n• Bachelor\'s degree in Computer Science\n• 3+ years of software development experience\n\nNice-to-Have:\n• Experience with cloud platforms\n• Open source contributions',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8),

        // Quick Add Buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickAddChip('Experience Level', Icons.trending_up, () {
              _addRequirement('• Minimum X years of relevant experience');
            }),
            _buildQuickAddChip('Education', Icons.school, () {
              _addRequirement('• Bachelor\'s degree in relevant field');
            }),
            _buildQuickAddChip('Technical Skills', Icons.code, () {
              _addRequirement('• Proficiency in [specify technologies]');
            }),
            _buildQuickAddChip('Soft Skills', Icons.people, () {
              _addRequirement('• Strong communication and teamwork skills');
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                size: 16,
                color: Colors.blue[600],
              ),
              SizedBox(width: 8),
              Text(
                'Required Skills & Qualifications',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Technical Skills
          _buildSkillCategory('Technical Skills', [
            'Programming Languages',
            'Frameworks',
            'Databases',
            'Tools & Platforms',
          ], Colors.blue),

          SizedBox(height: 12),

          // Soft Skills
          _buildSkillCategory('Soft Skills', [
            'Communication',
            'Problem Solving',
            'Leadership',
            'Team Work',
          ], Colors.green),

          SizedBox(height: 12),

          // Experience Level
          Row(
            children: [
              Text(
                'Experience Level: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: DropdownButton<String>(
                  value: 'Fresher',
                  underline: SizedBox(),
                  isDense: true,
                  items: controller.experienceOptions.map((exp) {
                    return DropdownMenuItem(
                      value: exp,
                      child: Text(exp, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(
    String title,
    List<String> suggestions,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _getColorShade(color, 700),
          ),
        ),

        SizedBox(height: 6),

        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: suggestions.map((skill) {
            return GestureDetector(
              onTap: () => _addSkillRequirement(skill),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getColorShade(color, 200)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 12,
                      color: _getColorShade(color, 600),
                    ),
                    SizedBox(width: 4),
                    Text(
                      skill,
                      style: TextStyle(
                        fontSize: 11,
                        color: _getColorShade(color, 700),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, size: 16, color: Colors.orange[600]),
              SizedBox(width: 8),
              Text(
                'Education Requirements',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Education Level
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minimum Education Level',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: DropdownButton<String>(
                        value: 'Bachelor\'s Degree',
                        isExpanded: true,
                        underline: SizedBox(),
                        items:
                            [
                              'High School',
                              'Diploma',
                              'Bachelor\'s Degree',
                              'Master\'s Degree',
                              'PhD',
                              'No formal education required',
                            ].map((education) {
                              return DropdownMenuItem(
                                value: education,
                                child: Text(
                                  education,
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferred Field of Study',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'e.g., Computer Science, Engineering',
                        hintStyle: TextStyle(fontSize: 11),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Quick Education Templates
          Text(
            'Quick Add:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 6),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildEducationTemplate(
                'CS/IT Background',
                '• Bachelor\'s in Computer Science, IT, or related field',
              ),
              _buildEducationTemplate(
                'Engineering Degree',
                '• Bachelor\'s degree in Engineering',
              ),
              _buildEducationTemplate(
                'MBA Preferred',
                '• MBA or equivalent business degree preferred',
              ),
              _buildEducationTemplate(
                'Technical Certification',
                '• Relevant technical certifications',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationTemplate(String label, String requirement) {
    return GestureDetector(
      onTap: () => _addRequirement(requirement),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 12, color: Colors.orange[600]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.orange[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 16,
                color: Colors.purple[600],
              ),
              SizedBox(width: 8),
              Text(
                'Certifications & Additional Requirements',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Certification Categories
          _buildCertificationCategory('Technical Certifications', [
            'AWS Certified',
            'Google Cloud Certified',
            'Microsoft Azure',
            'Oracle Certified',
          ]),

          SizedBox(height: 8),

          _buildCertificationCategory('Industry Certifications', [
            'PMP',
            'Agile/Scrum Master',
            'Six Sigma',
            'ITIL',
          ]),

          SizedBox(height: 8),

          _buildCertificationCategory('Language Requirements', [
            'English Proficiency',
            'Local Language',
            'International Languages',
          ]),

          SizedBox(height: 12),

          // Custom Certification Input
          TextField(
            decoration: InputDecoration(
              labelText: 'Custom Certification/Requirement',
              hintText: 'Enter specific certification or requirement',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(Icons.add, size: 16),
                onPressed: () {
                  // Add custom certification
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationCategory(
    String title,
    List<String> certifications,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.purple[700],
          ),
        ),

        SizedBox(height: 4),

        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: certifications.map((cert) {
            return GestureDetector(
              onTap: () => _addCertificationRequirement(cert),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 10, color: Colors.purple[600]),
                    SizedBox(width: 2),
                    Text(
                      cert,
                      style: TextStyle(fontSize: 10, color: Colors.purple[700]),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToolbarButton(
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Icon(icon, size: 14, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildQuickAddChip(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  void _addBulletPoint() {
    final currentText = controller.requirementsController.text;
    final cursorPosition = controller.requirementsController.selection.start;

    final newText =
        currentText.substring(0, cursorPosition) +
        '\n• ' +
        currentText.substring(cursorPosition);

    controller.requirementsController.text = newText;
    controller.requirementsController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + 3),
    );
  }

  void _addNumberedItem() {
    final currentText = controller.requirementsController.text;
    final lines = currentText.split('\n');
    final lastNumber = _findLastNumberInList(lines);

    final cursorPosition = controller.requirementsController.selection.start;
    final newText =
        currentText.substring(0, cursorPosition) +
        '\n${lastNumber + 1}. ' +
        currentText.substring(cursorPosition);

    controller.requirementsController.text = newText;
    controller.requirementsController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + '${lastNumber + 1}. '.length + 1),
    );
  }

  void _addMustHave() {
    _addRequirement('\nMust-Have:\n• ');
  }

  void _addNiceToHave() {
    _addRequirement('\nNice-to-Have:\n• ');
  }

  void _addRequirement(String requirement) {
    final currentText = controller.requirementsController.text;
    final newText = currentText.isEmpty
        ? requirement
        : currentText + (currentText.endsWith('\n') ? '' : '\n') + requirement;

    controller.requirementsController.text = newText;
  }

  void _addSkillRequirement(String skill) {
    _addRequirement('• Experience with $skill');
  }

  void _addCertificationRequirement(String certification) {
    _addRequirement('• $certification certification preferred');
  }

  int _findLastNumberInList(List<String> lines) {
    int lastNumber = 0;
    for (String line in lines.reversed) {
      final trimmed = line.trim();
      final match = RegExp(r'^(\d+)\.').firstMatch(trimmed);
      if (match != null) {
        lastNumber = int.parse(match.group(1)!);
        break;
      }
    }
    return lastNumber;
  }

  void _showRequirementsHelper() {
    Get.dialog(
      Dialog(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Writing Effective Job Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_outlined),
                  ),
                ],
              ),

              SizedBox(height: 16),

              _buildHelperSection('Structure Your Requirements', [
                'Separate Must-Have from Nice-to-Have requirements',
                'Use bullet points for better readability',
                'Order requirements by importance',
                'Be specific about experience levels',
              ]),

              SizedBox(height: 16),

              _buildHelperSection('Best Practices', [
                'Use clear, concise language',
                'Avoid jargon and internal terminology',
                'Include both technical and soft skills',
                'Specify education and certification requirements',
              ]),

              SizedBox(height: 16),

              _buildHelperSection('Examples of Good Requirements', [
                '• 3+ years of JavaScript development experience',
                '• Bachelor\'s degree in Computer Science or related field',
                '• Experience with React.js and Node.js',
                '• Strong problem-solving and communication skills',
              ]),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Got it!'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelperSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 8),

        Column(
          children: items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: Colors.blue[600])),
                  Expanded(child: Text(item, style: TextStyle(fontSize: 12))),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorShade(Color baseColor, int shade) {
    if (baseColor == Colors.blue) {
      switch (shade) {
        case 200:
          return Colors.blue[200]!;
        case 600:
          return Colors.blue[600]!;
        case 700:
          return Colors.blue[700]!;
        default:
          return baseColor;
      }
    } else if (baseColor == Colors.green) {
      switch (shade) {
        case 200:
          return Colors.green[200]!;
        case 600:
          return Colors.green[600]!;
        case 700:
          return Colors.green[700]!;
        default:
          return baseColor;
      }
    }
    // Fallback for other colors - create approximate shades
    switch (shade) {
      case 200:
        return baseColor.withAlpha((0.3 * 255).toInt());
      case 600:
        return baseColor;
      case 700:
        return Color.lerp(baseColor, Colors.black, 0.2)!;
      default:
        return baseColor;
    }
  }
}
