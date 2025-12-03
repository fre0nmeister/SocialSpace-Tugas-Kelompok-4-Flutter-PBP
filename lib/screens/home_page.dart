import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _postController = TextEditingController();
  final _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  
  User? user = FirebaseAuth.instance.currentUser;

  final Color _primaryColor = const Color(0xFF1E2746);
  final Color _greyOutline = Colors.grey.shade300;

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 25, maxWidth: 800);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadPost() async {
    if (_postController.text.isEmpty && _selectedImage == null) return;
    setState(() => _isLoading = true);
    String? base64Image;
    try {
      if (_selectedImage != null) {
        List<int> imageBytes = await _selectedImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);
        if (base64Image.length > 1000000) throw Exception("Ukuran gambar terlalu besar!");
      }
      
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      await FirebaseFirestore.instance.collection('posts').add({
        'text': _postController.text,
        'image_base64': base64Image,
        'username': currentUser?.displayName ?? 'User',
        'uid': currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _postController.clear();
      setState(() { _selectedImage = null; _isLoading = false; });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      setState(() => _isLoading = false);
    }
  }

  void _showDetailBase64(String base64String) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: IconThemeData(color: Colors.white)),
        body: Center(child: Image.memory(base64Decode(base64String), fit: BoxFit.contain)),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    String initialName = (user?.displayName != null && user!.displayName!.isNotEmpty) 
        ? user!.displayName![0].toUpperCase() 
        : "U";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,  
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _primaryColor, 
                        radius: 20,
                        child: Text(initialName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.displayName ?? "User", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Posting sesuatu...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: _logout,
                        icon: Icon(Icons.logout, color: Colors.red),
                        tooltip: "Logout",
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: "Apa yang Anda pikirkan?",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (_selectedImage != null)
                    Container(
                      height: 150, width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 8, top: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(icon: Icon(Icons.close, color: Colors.white), onPressed: () => setState(() => _selectedImage = null)),
                            ),
                          )
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => showModalBottomSheet(context: context, builder: (ctx) => Wrap(children: [
                          ListTile(leading: Icon(Icons.camera), title: Text('Kamera'), onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); }),
                          ListTile(leading: Icon(Icons.image), title: Text('Galeri'), onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); }),
                        ])),
                        icon: Icon(Icons.photo_library, color: Colors.green),
                        label: Text("Foto/Video", style: TextStyle(color: Colors.black87)),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _uploadPost,
                        icon: _isLoading ? SizedBox() : Icon(Icons.send, size: 18),
                        label: _isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text("Kirim"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(horizontal: 24)
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            
            Divider(height: 1, thickness: 1),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      bool hasImage = data.containsKey('image_base64') && data['image_base64'] != null;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),  
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200, 
                                    child: Text(data['username'][0].toUpperCase(), style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold))
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['username'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
                                      Text("Baru saja", style: TextStyle(color: Colors.grey, fontSize: 12)), // Timestamp simpel
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Icons.more_horiz, color: Colors.grey),
                                ],
                              ),
                            ),
                            
                            if (data['text'] != "") 
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
                                child: Text(data['text'], style: TextStyle(fontSize: 15, height: 1.4)),
                              ),
                            
                            if (hasImage)
                              GestureDetector(
                                onTap: () => _showDetailBase64(data['image_base64']),
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: 400),
                                  width: double.infinity,
                                  color: Colors.grey.shade100,
                                  child: Image.memory(base64Decode(data['image_base64']), fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => Center(child: Icon(Icons.broken_image, color: Colors.grey))),
                                ),
                              ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround, 
                                children: [
                                  TextButton.icon(
                                    onPressed: () {},  
                                    icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.grey.shade600, size: 20),
                                    label: Text("Suka", style: TextStyle(color: Colors.grey.shade600)),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.mode_comment_outlined, color: Colors.grey.shade600, size: 20),
                                    label: Text("Komentar", style: TextStyle(color: Colors.grey.shade600)),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.share_outlined, color: Colors.grey.shade600, size: 20),
                                    label: Text("Bagikan", style: TextStyle(color: Colors.grey.shade600)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}