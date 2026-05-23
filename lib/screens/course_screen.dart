import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class CourseScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  
  const CourseScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  int _progress = 0;
  bool _isUpdating = false;

  final List<Map<String, dynamic>> _lessons = [
    {'title': 'Introduction to Public Speaking', 'duration': '15 mins'},
    {'title': 'Overcoming Stage Fright', 'duration': '20 mins'},
    {'title': 'Structuring Your Speech', 'duration': '25 mins'},
    {'title': 'Voice Modulation Techniques', 'duration': '18 mins'},
    {'title': 'Body Language Mastery', 'duration': '22 mins'},
    {'title': 'Final Presentation Practice', 'duration': '30 mins'},
  ];

  Future<void> _updateProgress() async {
    setState(() => _isUpdating = true);
    
    final newProgress = _progress >= 50 ? 100 : 50;
    final success = await ApiService.updateProgress(widget.courseId, newProgress);
    
    if (!mounted) return;
    setState(() {
      _isUpdating = false;
      if (success) _progress = newProgress;
    });
    
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ Progress berhasil diupdate!' : '❌ Gagal update progress.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 🔹 HEADER
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 20,
                  vertical: isMobile ? 10 : 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          width: isMobile ? 35 : 45,
                          height: isMobile ? 35 : 45,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isMobile ? 8 : 10),
                        Text(
                          'SpeakOut',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF667eea),
                          ),
                        ),
                      ],
                    ),

                    // Right Side: Logout + Menu
                    Row(
                      children: [
                        // Logout Button
                        InkWell(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Yakin ingin logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                            
                            if (confirm == true && mounted) {
                              await ApiService.logout();
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                (route) => false,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 10 : 16,
                              vertical: isMobile ? 6 : 8,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Hamburger Menu (mobile only)
                        if (isMobile)
                          IconButton(
                            icon: const Icon(Icons.menu, color: Color(0xFF667eea)),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.home),
                                        title: const Text('Home'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.school),
                                        title: const Text('Courses'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.people),
                                        title: const Text('Teachers'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 15 : 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 968) {
                        return Column(
                          children: [
                            _buildCourseDetail(isMobile: true),
                            const SizedBox(height: 30),
                            _buildSidebar(isMobile: true),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildCourseDetail(isMobile: false)),
                            const SizedBox(width: 40),
                            // ✅ FIX: Hapus 'const' karena _buildSidebar adalah method call
                            SizedBox(width: 400, child: _buildSidebar(isMobile: false)),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 COURSE DETAIL CONTENT
  Widget _buildCourseDetail({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // ✅ FIX: Gunakan Color.fromRGBO atau hex
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text('Home', style: TextStyle(color: Color(0xFF667eea), fontSize: 14)),
              ),
              const Text(' / ', style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
              GestureDetector(
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Courses', style: TextStyle(color: Color(0xFF667eea), fontSize: 14)),
              ),
              const Text(' / ', style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
              Expanded(
                child: Text(
                  widget.courseTitle,
                  style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Course Title
          Text(
            widget.courseTitle,
            style: TextStyle(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Color(0xFF667eea)),
                  const SizedBox(width: 6),
                  Text('John Doe', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Color(0xFF667eea)),
                  const SizedBox(width: 6),
                  Text('6 Lessons • 2h 10m', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 🔹 PROGRESS CARD (Gradient Purple)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$_progress%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _progress / 100,
                    minHeight: 8,
                    // ✅ FIX: Gunakan Color.fromRGBO
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUpdating ? null : _updateProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _progress >= 100 ? Colors.green.shade600 : Colors.white,
                      foregroundColor: _progress >= 100 ? Colors.white : const Color(0xFF667eea),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isUpdating
                        ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            _progress >= 100 ? '✓ Course Completed' : 'Mark as 50% Complete',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 🔹 LESSONS LIST
          Text(
            'Course Lessons',
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lessons.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final lesson = _lessons[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  // ✅ FIX: Gunakan Color.fromRGBO
                  backgroundColor: const Color.fromRGBO(102, 126, 234, 0.1),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Color(0xFF667eea), fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(lesson['title']),
                subtitle: Text(lesson['duration'], style: TextStyle(color: Colors.grey.shade600)),
                trailing: const Icon(Icons.play_circle_outline, color: Color(0xFF667eea)),
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔸 SIDEBAR (Office Info)
  Widget _buildSidebar({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // ✅ FIX: Gunakan Color.fromRGBO atau hex
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SpeakOut Office',
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1a1a1a),
            ),
          ),
          SizedBox(height: isMobile ? 15 : 20),
          const Text(
            'Jl. Jenderal Sudirman 3007 KM 3.5\nPalembang',
            style: TextStyle(color: Color(0xFF666666), fontSize: 14, height: 1.8),
          ),
          SizedBox(height: isMobile ? 10 : 15),
          const Text(
            '(0711) 319988 / 370066',
            style: TextStyle(color: Color(0xFF666666), fontSize: 14, height: 1.8),
          ),
          const Text(
            'speakout@palcomtech.com',
            style: TextStyle(color: Color(0xFF667eea), fontSize: 14, height: 1.8),
          ),
          SizedBox(height: isMobile ? 8 : 10),
          const Text(
            'View Map →',
            style: TextStyle(
              color: Color(0xFF667eea),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}