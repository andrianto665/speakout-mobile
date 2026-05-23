import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
  String _displayName = 'User';

  // Mock lessons data (sesuaikan dengan response API jika ada endpoint detail)
  final List<Map<String, dynamic>> _lessons = [
    {'title': 'Introduction to Public Speaking', 'duration': '15 mins'},
    {'title': 'Overcoming Stage Fright', 'duration': '20 mins'},
    {'title': 'Structuring Your Speech', 'duration': '25 mins'},
    {'title': 'Voice Modulation Techniques', 'duration': '18 mins'},
    {'title': 'Body Language Mastery', 'duration': '22 mins'},
    {'title': 'Final Presentation Practice', 'duration': '30 mins'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await ApiService.getUserData();
    if (mounted && userData != null && userData['name'] != null) {
      setState(() {
        _displayName = userData['name'].toString().split(' ').first;
      });
    }
  }

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ Progress berhasil diupdate!' : '❌ Gagal update progress.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 🔹 HEADER (Identik dengan layar lain)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SpeakOut',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF667eea),
                              ),
                            ),
                            Text(
                              'ngomong Inggris jadi mudah',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Navigation Menu
                    const Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NavMenuItem(title: 'Home'),
                          SizedBox(width: 30),
                          _NavMenuItem(title: 'Course'),
                          SizedBox(width: 30),
                          _NavMenuItem(title: 'Teachers'),
                          SizedBox(width: 30),
                          _NavMenuItem(title: 'Record'),
                          SizedBox(width: 30),
                          _NavMenuItem(title: 'Schedules'),
                          SizedBox(width: 30),
                          _NavMenuItem(title: 'Articles'),
                        ],
                      ),
                    ),
                    
                    // User Info + Logout
                    Row(
                      children: [
                        Text(
                          _displayName,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 MAIN CONTENT (2 Columns: Course Detail + Sidebar)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 968) {
                        // Mobile: Stack vertical
                        return Column(
                          children: [
                            _buildCourseDetail(),
                            const SizedBox(height: 40),
                            _buildSidebar(),
                          ],
                        );
                      } else {
                        // Desktop: Side by side
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildCourseDetail()),
                            const SizedBox(width: 40),
                            SizedBox(width: 400, child: _buildSidebar()),
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
  Widget _buildCourseDetail() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              const Text(' / ', style: TextStyle(color: Colors.grey, fontSize: 14)),
              GestureDetector(
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Courses', style: TextStyle(color: Color(0xFF667eea), fontSize: 14)),
              ),
              const Text(' / ', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text(widget.courseTitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),

          // Course Title & Instructor
          Text(
            widget.courseTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text('John Doe', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text('6 Lessons • 2h 10m', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
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
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
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
          const Text(
            'Course Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lessons.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final lesson = _lessons[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF667eea).withValues(alpha: 0.1),
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

  // 🔸 SIDEBAR (Office Info) - Identik
  Widget _buildSidebar() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SpeakOut Office',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1a1a1a)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Jl. Jenderal Sudirman 3007 KM 3.5\nPalembang',
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.8),
          ),
          const SizedBox(height: 15),
          const Text(
            '(0711) 319988 / 370066',
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.8),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'speakout@palcomtech.com',
              style: TextStyle(color: Color(0xFF667eea), fontSize: 14, height: 1.8),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View Map →',
              style: TextStyle(color: Color(0xFF667eea), fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔸 REUSABLE NAV ITEM
class _NavMenuItem extends StatelessWidget {
  final String title;
  const _NavMenuItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}