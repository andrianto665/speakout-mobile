// Widget test for SpeakOut App - Synced with login_screen.dart ✅
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speakout_app/main.dart';
import 'package:speakout_app/screens/login_screen.dart';

void main() {
  // ✅ Test 1: App bisa di-render tanpa crash
  testWidgets('SpeakOutApp builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const SpeakOutApp());
    // Jika tidak crash, test passed
    expect(find.byType(SpeakOutApp), findsOneWidget);
  });

  // ✅ Test 2: LoginScreen memiliki elemen UI yang benar
  testWidgets('LoginScreen has correct UI elements', (WidgetTester tester) async {
    // Render LoginScreen langsung (bypass AuthGate)
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );

    // 🎯 Cek teks yang SAMA PERSIS dengan di login_screen.dart
    expect(find.text('SpeakOut Login'), findsOneWidget);        // AppBar title
    expect(find.text('Email'), findsOneWidget);                  // Label TextField
    expect(find.text('Password'), findsOneWidget);               // Label TextField
    expect(find.text('LOGIN'), findsOneWidget);                  // Tombol (huruf besar!)
    expect(find.text('Belum punya akun? Daftar sekarang'), findsOneWidget); // Register link
    
    // Cek tipe widget
    expect(find.byType(TextField), findsNWidgets(2));            // 2 input field
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1)); // Tombol login
    expect(find.byType(AppBar), findsOneWidget);                 // Header
  });

  // ✅ Test 3: Form bisa di-interact (enter text & tap button)
  testWidgets('Login form can be interacted with', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );

    // 🎯 Gunakan Key untuk select field (lebih reliable daripada teks)
    await tester.enterText(find.byKey(const Key('email_field')), 'user@test.com');
    await tester.enterText(find.byKey(const Key('password_field')), '123456');
    await tester.pump(); // Trigger rebuild

    // Verifikasi input masuk (cek via finder teks)
    expect(find.text('user@test.com'), findsOneWidget);
    // Note: password field obscureText, jadi tidak bisa dicek teks-nya

    // Tap tombol login (akan gagal karena API tidak connect di test - itu OK)
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    // Verifikasi tombol masih ada (tidak crash)
    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });
}