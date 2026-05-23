import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _agreeTerms = false;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua field harus diisi'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Anda harus menyetujui Terms of Service'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    final success = await ApiService.register(_nameCtrl.text, _emailCtrl.text, _passCtrl.text);
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registrasi gagal.'),
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
                            _buildRegisterForm(isMobile: isMobile),
                            const SizedBox(height: 30),
                            _buildSidebar(isMobile: isMobile),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildRegisterForm(isMobile: false)),
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

  // 🔸 REGISTER FORM - Mobile Optimized
  Widget _buildRegisterForm({required bool isMobile}) {
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
            'Create Account',
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
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Home',
                  style: TextStyle(color: Color(0xFF667eea), fontSize: 14),
                ),
              ),
              const Text(
                ' / Register',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 30),

          // Full Name Field
          const Text(
            'Full Name',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'Enter your full name',
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
          ),
          SizedBox(height: isMobile ? 20 : 25),

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
              hintText: 'Minimum 6 characters',
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

          // Terms & Conditions Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeTerms,
                onChanged: (value) => setState(() => _agreeTerms = value!),
                activeColor: const Color(0xFF667eea),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, height: 1.4),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(color: Color(0xFF667eea)),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Color(0xFF667eea)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 25),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: isMobile ? 48 : 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
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
                      'Create Account',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 25),

          // ✅ FIX: Login Link - "Log In" bisa diklik
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: isMobile ? 13 : 14,
                  ),
                  children: const [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Log In',
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