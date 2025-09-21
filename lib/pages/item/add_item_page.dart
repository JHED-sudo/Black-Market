// lib/pages/add_item_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/supabase_service.dart';
import '../../widgets/custom_input_field.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});
  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
  final _nameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool _uploading = false;

  Future<void> pickImage() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _image = File(img.path));
  }

  Future<void> _handleUpload() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your trader name')),
      );
      return;
    }
    if (_image == null) return;

    setState(() => _uploading = true);
    final svc = Provider.of<SupabaseService>(context, listen: false);

    await svc.addItem(
      title: _titleCtrl.text.trim(),
      desc: _descCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text) ?? 0,
      contact: _contactCtrl.text.trim(),
      uploaderName: _nameCtrl.text.trim(),
      image: _image!,
    );

    setState(() => _uploading = false);
    if (svc.error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${svc.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canUpload = _image != null && !_uploading;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'ADD GOODS',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
              fontFamily: "monospace",
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.green,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title field
                CustomInputField(
                  controller: _titleCtrl,
                  label: 'GOODS TITLE',
                  icon: Icons.label_outline,
                  hackerMode: true, // 👈 you'll update CustomInputField
                ),
                const SizedBox(height: 16),

                // Description
                CustomInputField(
                  controller: _descCtrl,
                  label: 'DESCRIPTION',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  hackerMode: true,
                ),
                const SizedBox(height: 16),

                // Price
                CustomInputField(
                  controller: _priceCtrl,
                  label: 'PRICE (PHP)',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  hackerMode: true,
                ),
                const SizedBox(height: 16),

                // Name
                CustomInputField(
                  controller: _nameCtrl,
                  label: 'YOUR DISPLAY NAME',
                  icon: Icons.person_outline,
                  hackerMode: true,
                ),
                const SizedBox(height: 16),

                // Contact
                CustomInputField(
                  controller: _contactCtrl,
                  label: 'CONTACT EMAIL',
                  icon: Icons.contact_mail_outlined,
                  hackerMode: true,
                ),
                const SizedBox(height: 24),

                // Image picker
                _image == null
                    ? ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library,
                      size: 24, color: Colors.greenAccent),
                  label: const Text(
                    'CHOOSE PHOTO',
                    style: TextStyle(
                      fontFamily: "monospace",
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                          color: Colors.greenAccent, width: 2),
                    ),
                    shadowColor: Colors.greenAccent,
                    elevation: 10,
                  ),
                  onPressed: pickImage,
                )
                    : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.greenAccent, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.green,
                            blurRadius: 12,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!,
                            height: 180, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => setState(() => _image = null),
                      child: const Text(
                        'RE-PICK IMAGE',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: "monospace",
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Upload button
                ElevatedButton(
                  onPressed: canUpload ? _handleUpload : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Colors.greenAccent, width: 2),
                    ),
                    elevation: 12,
                    shadowColor: Colors.greenAccent,
                  ),
                  child: _uploading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.greenAccent,
                    ),
                  )
                      : const Text(
                    'UPLOAD GOODS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "monospace",
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.green,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
