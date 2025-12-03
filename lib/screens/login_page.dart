import 'package:flutter/material.dart';
import 'package:socialmediaapp/services/auth_service.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _obscureText = true;

  final Color _primaryColor = const Color(0xFF1E2746);
  final Color _greyColor = Colors.grey.shade400;

  void _login() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) return;
    
    showDialog(context: context, barrierDismissible: false, builder: (c) => Center(child: CircularProgressIndicator()));

    var user = await _auth.signIn(_emailController.text, _passController.text);
    Navigator.pop(context);  

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Gagal. Cek email/password.")));
    }
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, IconButton? suffixBtn}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _greyColor),
      prefixIcon: Icon(icon, color: _primaryColor),
      suffixIcon: suffixBtn,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _greyColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _greyColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryColor, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Icon(Icons.camera_enhance_rounded, size: 80, color: _primaryColor),
              SizedBox(height: 16),
              Text(
                "SocialSpace", 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _primaryColor, letterSpacing: 1.5),
              ),
              Text(
                "Share your moments", 
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 60),

              // --- INPUT ---
              Align(alignment: Alignment.centerLeft, child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor))),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(hint: "masukkan email...", icon: Icons.email_outlined),
              ),
              SizedBox(height: 24),

              Align(alignment: Alignment.centerLeft, child: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor))),
              SizedBox(height: 8),
              TextField(
                controller: _passController,
                obscureText: _obscureText,
                decoration: _inputDecoration(
                  hint: "masukkan password...",
                  icon: Icons.lock_outline,
                  suffixBtn: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _greyColor),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // --- TOMBOL ---
              ElevatedButton(
                onPressed: _login,
                child: Text("Masuk", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                    child: Text("Daftar Sekarang", style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}