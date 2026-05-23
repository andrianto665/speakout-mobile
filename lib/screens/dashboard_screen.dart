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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final userData = await ApiService.getUserData();
    if (userData != null && userData['name'] != null) {
      setState(() {
        _displayName = userData['name'].toString().split(' ').first;
      });
    }
    
    _courses = await ApiService.getCourses();
    setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 🔹 HEADER (Sama dengan dashboard.html)
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
                    
                    // Navigation Menu (Desktop)
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: _logout,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Logout',
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

          // 🔹 MAIN CONTENT (2 Columns: Dashboard + Sidebar)
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
                            _buildDashboardContent(),
                            const SizedBox(height: 40),
                            _buildSidebar(),
                          ],
                        );
                      } else {
                        // Desktop: Side by side
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildDashboardContent()),
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

  // 🔸 DASHBOARD CONTENT
  Widget _buildDashboardContent() {
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
          // Breadcrumb + Header
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Home',
                  style: TextStyle(color: Color(0xFF667eea), fontSize: 14),
                ),
              ),
              const Text(' / Dashboard', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'My Courses',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const Text(
            'Track your learning progress and continue your journey',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 25),

          // Stats Cards (Responsive Grid)
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 2 : 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: isMobile ? 2 : 1.8,
                children: [
                  _buildStatCard('Total Users', '156', Colors.indigo),
                  _buildStatCard('Total Courses', '12', Colors.green),
                  _buildStatCard('Active Enrollments', '89', Colors.blue),
                  _buildStatCard('Completed', '34', Colors.orange),
                ],
              );
            },
          ),
          const SizedBox(height: 30),

          // Course List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF667eea)),
                onPressed: _loadData,
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Course List / Loading / Empty State
          _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Color(0xFF667eea)),
                  ),
                )
              : _courses.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Icon(Icons.school_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada course tersedia',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final c = _courses[index];
                        final progress = c['enrollment']?['progress'] ?? 0;
                        final isCompleted = progress >= 100;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFF667eea).withValues(alpha: 0.2),
                              child: Text(
                                c['title']?[0]?.toUpperCase() ?? 'C',
                                style: const TextStyle(
                                  color: Color(0xFF667eea),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              c['title'] ?? 'Tanpa Judul',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['instructor'] ?? ''),
                                if (progress > 0) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: LinearProgressIndicator(
                                            value: progress / 100,
                                            minHeight: 6,
                                            backgroundColor: Colors.grey.shade200,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text('$progress%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            trailing: isCompleted
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseScreen(
                                  courseId: c['id'],
                                  courseTitle: c['title'],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  // 🔸 STAT CARD WIDGET
  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 SIDEBAR (Office Info) - Sama dengan login/register screen
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Jl. Jenderal Sudirman 3007 KM 3.5\nPalembang',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            '(0711) 319988 / 370066',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.8,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'speakout@palcomtech.com',
              style: TextStyle(
                color: Color(0xFF667eea),
                fontSize: 14,
                height: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View Map →',
              style: TextStyle(
                color: Color(0xFF667eea),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔸 NAVIGATION MENU ITEM WIDGET (Reusable)
class _NavMenuItem extends StatelessWidget {
  final String title;
  const _NavMenuItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}