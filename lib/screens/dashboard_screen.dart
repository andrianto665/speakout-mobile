import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'course_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String _displayName = 'User';
  String _userRole = 'user';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final userData = await ApiService.getUserData();
    if (userData != null) {
      setState(() {
        _displayName = userData['name']?.toString().split(' ').first ?? 'User';
        _userRole = userData['role'] ?? 'user';
      });
    }
    
    try {
      _courses = await ApiService.getCourses();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      // Menggunakan print dengan ignore agar tidak warning di production
      // ignore: avoid_print
      print('❌ Error loading courses: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
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
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isAdmin = _userRole == 'admin';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 🔹 HEADER
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 2))],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: isMobile ? 10 : 15),
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
                            gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(width: isMobile ? 8 : 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SpeakOut', style: TextStyle(fontSize: isMobile ? 16 : 24, fontWeight: FontWeight.bold, color: const Color(0xFF667eea))),
                            if (!isMobile) const Text('ngomong Inggris jadi mudah', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                          ],
                        ),
                      ],
                    ),

                    // Right Side
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMobile || screenWidth > 400) Text(_displayName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: isMobile ? 12 : 14, color: const Color(0xFF333333))),
                        if (!isMobile || screenWidth > 400) const SizedBox(width: 10),
                        InkWell(
                          onTap: _logout,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: isMobile ? 6 : 8),
                            decoration: const BoxDecoration(color: Color(0xFFEF4444), borderRadius: BorderRadius.all(Radius.circular(6))),
                            child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: isMobile ? 11 : 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
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
                                    children: ['Home', 'Course', 'Teachers', 'Record', 'Schedules', 'Articles']
                                        .map((t) => ListTile(title: Text(t, style: const TextStyle(fontSize: 16)), onTap: () => Navigator.pop(context)))
                                        .toList(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 20 : 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text('Home', style: TextStyle(color: Color(0xFF667eea), fontSize: 14)),
                                Text(' / Dashboard', style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text('My Courses', style: TextStyle(fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.w600, color: const Color(0xFF1a1a1a))),
                            const Text('Track your learning progress and continue your journey', style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
                            const SizedBox(height: 25),

                            // Admin Stats
                            if (isAdmin) ...[
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isMobile ? 2 : 4,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: isMobile ? 1.5 : 1.8,
                                children: [
                                  _buildStatCard('Total Users', '156', const Color(0xFF667eea)),
                                  _buildStatCard('Total Courses', '12', const Color(0xFF10B981)),
                                  _buildStatCard('Active Enrollments', '89', const Color(0xFF3B82F6)),
                                  _buildStatCard('Completed', '34', const Color(0xFFF59E0B)),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],

                            // ✅ FIX: Empty State & Loading State (Tanpa const di list children)
                            _isLoading
                                ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Column(children: [SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: Color(0xFF667eea), strokeWidth: 3)), SizedBox(height: 15), Text('Loading your courses...')])))
                                : _courses.isEmpty
                                    ? Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 40),
                                            const Text('🎉', style: TextStyle(fontSize: 48)),
                                            const SizedBox(height: 15),
                                            const Text('You haven\'t enrolled in any courses yet!', style: TextStyle(color: Color(0xFF666666))),
                                            const SizedBox(height: 15),
                                            // ✅ FIX: ElevatedButton tidak di dalam const list
                                            ElevatedButton(
                                              onPressed: null,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF667eea),
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text('Browse Courses'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                          final crossAxisCount = isMobile ? 1 : 2;
                                          final cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 20) / crossAxisCount;
                                          return GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: cardWidth / 280),
                                            itemCount: _courses.length,
                                            itemBuilder: (context, index) => _buildCourseCard(_courses[index]),
                                          );
                                        },
                                      ),
                          ],
                        ),
                      ),
                      if (isMobile) ...[const SizedBox(height: 30), _buildSidebar(isMobile: true)],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 COURSE CARD
  Widget _buildCourseCard(dynamic course) {
    final progress = course['enrollment']?['progress'] ?? 0;
    final isCompleted = progress >= 100;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border.all(color: const Color(0xFFE1E5EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course['title'] ?? 'No Title', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1a1a1a))),
          const SizedBox(height: 8),
          Text(course['description'] ?? 'No description available.', style: const TextStyle(color: Color(0xFF666666), fontSize: 14, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Color(0xFF667eea)),
              const SizedBox(width: 6),
              Expanded(child: Text(course['instructor'] ?? 'Unknown Instructor', style: const TextStyle(color: Color(0xFF667eea), fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('Progress', style: TextStyle(color: Color(0xFF666666), fontSize: 12)), Text('0%', style: TextStyle(color: Color(0xFF666666), fontSize: 12))],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 6,
              backgroundColor: const Color(0xFFE1E5EB),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
            ),
          ),
          const SizedBox(height: 15),
          
          // ✅ GRADIENT BUTTON
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CourseScreen(courseId: course['id'], courseTitle: course['title'])),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: Text(
                isCompleted ? '✓ Completed' : (progress > 0 ? 'Continue Learning' : 'Start Learning'),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 STAT CARD
  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 🔸 SIDEBAR
  Widget _buildSidebar({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SpeakOut Office', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1a1a1a))),
          SizedBox(height: 20),
          Text('Jl. Jenderal Sudirman 3007 KM 3.5\nPalembang', style: TextStyle(color: Color(0xFF666666), fontSize: 14, height: 1.8)),
          SizedBox(height: 15),
          Text('(0711) 319988 / 370066', style: TextStyle(color: Color(0xFF666666), fontSize: 14, height: 1.8)),
          Text('speakout@palcomtech.com', style: TextStyle(color: Color(0xFF667eea), fontSize: 14, height: 1.8)),
          SizedBox(height: 10),
          Text('View Map →', style: TextStyle(color: Color(0xFF667eea), fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }
}