import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email dan password harus diisi'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await ApiService.login(_emailCtrl.text, _passCtrl.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login gagal. Cek email/password.'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 🔹 HEADER - Mobile Optimized
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 15 : 20,
                  vertical: isMobile ? 12 : 15,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SpeakOut',
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF667eea),
                              ),
                            ),
                            if (!isMobile)
                              const Text(
                                'ngomong Inggris jadi mudah',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    // Mobile: Hamburger Menu
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
                                  _buildMobileMenuItem('Home'),
                                  _buildMobileMenuItem('Course'),
                                  _buildMobileMenuItem('Teachers'),
                                  _buildMobileMenuItem('Record'),
                                  _buildMobileMenuItem('Schedules'),
                                  _buildMobileMenuItem('Articles'),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else
                      // Desktop: Navigation Menu
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
                  ],
                ),
              ),
            ),
          ),

          // 🔹 MAIN CONTENT - Mobile Optimized
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
                            _buildLoginForm(isMobile: isMobile),
                            const SizedBox(height: 30),
                            _buildSidebar(isMobile: isMobile),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildLoginForm(isMobile: false)),
                            const SizedBox(width: 40),
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

  Widget _buildMobileMenuItem(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () => Navigator.pop(context),
    );
  }

  // 🔸 LOGIN FORM - Mobile Optimized
  Widget _buildLoginForm({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 25 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
            'Log In',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Home',
                  style: TextStyle(color: Color(0xFF667eea), fontSize: 14),
                ),
              ),
              const Text(
                ' / Log In',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 30),

          // Email Field
          const Text(
            'Email Address',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE1E5EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE1E5EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF667eea),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: isMobile ? 20 : 25),

          // Password Field
          const Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passCtrl,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE1E5EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE1E5EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF667eea),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            obscureText: true,
          ),
          SizedBox(height: isMobile ? 20 : 25),

          // Remember Me & Forgot Password - Stack on mobile
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: const Color(0xFF667eea),
                        ),
                        const Text('Remember Me', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF667eea),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: const Color(0xFF667eea),
                        ),
                        const Text('Remember Me', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF667eea),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: isMobile ? 20 : 25),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: isMobile ? 48 : 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 25),

          // ✅ FIX: Register Link - "Register Now" bisa diklik
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: isMobile ? 13 : 14,
                  ),
                  children: const [
                    TextSpan(text: "Don't have an account? "),
                    // ✅ FIX: Tambahkan text: 'Register Now'
                    TextSpan(
                      text: 'Register Now',
                      style: TextStyle(
                        color: Color(0xFF667eea),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 25),
        ],
      ),
    );
  }

  // 🔸 SIDEBAR (Office Info) - Mobile Optimized
  Widget _buildSidebar({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
          Text(
            'Jl. Jenderal Sudirman 3007 KM 3.5\nPalembang',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: isMobile ? 13 : 14,
              height: 1.8,
            ),
          ),
          SizedBox(height: isMobile ? 10 : 15),
          Text(
            '(0711) 319988 / 370066',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: isMobile ? 13 : 14,
              height: 1.8,
            ),
          ),
          const Text(
            'speakout@palcomtech.com',
            style: TextStyle(
              color: Color(0xFF667eea),
              fontSize: 14,
              height: 1.8,
            ),
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

// 🔸 NAVIGATION MENU ITEM WIDGET
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
          color: Color(0xFF333333),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}