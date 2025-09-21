// lib/pages/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final svc = Provider.of<SupabaseService>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // same hacker/matrix background
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hacker Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.black.withOpacity(0.85),
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Name
                          TextField(
                            style: GoogleFonts.robotoMono(color: Colors.greenAccent),
                            controller: _nameCtrl,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person, color: Colors.greenAccent),
                              labelText: 'Name',
                              labelStyle: GoogleFonts.robotoMono(color: Colors.greenAccent),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.greenAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Email
                          TextField(
                            style: GoogleFonts.robotoMono(color: Colors.greenAccent),
                            controller: _emailCtrl,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Colors.greenAccent),
                              labelText: 'Email',
                              labelStyle: GoogleFonts.robotoMono(color: Colors.greenAccent),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.greenAccent),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          // Password
                          TextField(
                            style: GoogleFonts.robotoMono(color: Colors.greenAccent),
                            controller: _passCtrl,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Colors.greenAccent),
                              labelText: 'Password',
                              labelStyle: GoogleFonts.robotoMono(color: Colors.greenAccent),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.greenAccent),
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent.withOpacity(0.2),
                                foregroundColor: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.greenAccent),
                                ),
                                elevation: 4,
                              ),
                              onPressed: _loading ? null : () async {
                                final name = _nameCtrl.text.trim();
                                final email = _emailCtrl.text.trim();
                                final pass = _passCtrl.text;
                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Enter name')),
                                  );
                                  return;
                                }
                                if (email.isEmpty || pass.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Email & password required')),
                                  );
                                  return;
                                }
                                setState(() => _loading = true);
                                final ok = await svc.signUp(email, pass, name);
                                setState(() => _loading = false);
                                if (ok) Navigator.pushReplacementNamed(context, '/signin');
                              },
                              child: _loading
                                  ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                              )
                                  : Text(
                                'Sign Up',
                                style: GoogleFonts.robotoMono(
                                  color: Colors.greenAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Error message
                          Consumer<SupabaseService>(
                            builder: (_, svc, __) => svc.error != null
                                ? Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                svc.error!,
                                style: GoogleFonts.robotoMono(color: Colors.redAccent),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signin'),
                    child: Text(
                      'Already have an account? Sign In',
                      style: GoogleFonts.robotoMono(color: Colors.greenAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
