import 'package:flutter/material.dart';
import 'package:socialmediaapp/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _obscureText = true;

  final Color _primaryColor = const Color(0xFF1E2746);
  final Color _greyColor = Colors.grey.shade400;

  void _register() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty || _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Semua data harus diisi.")));
      return;
    }
    // Loading
    showDialog(context: context, barrierDismissible: false, builder: (c) => Center(child: CircularProgressIndicator()));
    
    var user = await _auth.signUp(_emailController.text, _passController.text, _usernameController.text);
    Navigator.pop(context); // Tutup loading

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Berhasil! Silakan Login.")));
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Gagal.")));
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: _primaryColor), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person_add_alt_1_rounded, size: 60, color: _primaryColor),
              SizedBox(height: 10),
              Text("Buat Akun Baru", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor)),
              SizedBox(height: 40),

              Align(alignment: Alignment.centerLeft, child: Text("Username", style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor))),
              SizedBox(height: 8),
              TextField(controller: _usernameController, decoration: _inputDecoration(hint: "pilih username...", icon: Icons.person_outline)),
              SizedBox(height: 20),

              Align(alignment: Alignment.centerLeft, child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor))),
              SizedBox(height: 8),
              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: _inputDecoration(hint: "masukkan email...", icon: Icons.email_outlined)),
              SizedBox(height: 20),

              Align(alignment: Alignment.centerLeft, child: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor))),
              SizedBox(height: 8),
              TextField(
                controller: _passController,
                obscureText: _obscureText,
                decoration: _inputDecoration(
                  hint: "buat password...",
                  icon: Icons.lock_outline,
                  suffixBtn: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _greyColor),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
              ),
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: _register,
                child: Text("Daftar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}