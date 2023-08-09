import 'dart:io';
import 'package:circle/entities/entry.dart';
import 'package:circle/models/entries_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:circle/configs/custom_colors.dart';
import 'package:circle/widget/global_widgets/elevated_button_widget.dart';
import 'package:circle/widget/global_widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class ManipulateEntryScreen extends StatefulWidget {
  final Entry? entry;

  const ManipulateEntryScreen({Key? key, this.entry}) : super(key: key);

  @override
  State<ManipulateEntryScreen> createState() => _ManipulateEntryScreenState();
}

class _ManipulateEntryScreenState extends State<ManipulateEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? image;

  void onSubmit() {
    // Get the title text and content text
    final title = _titleController.text;
    final content = _contentController.text;

    // Check if either title or content is empty
    // If !empty --> proceed
    // If empty --> show error message saying title or content is missing
    if (title.isNotEmpty && content.isNotEmpty) {
      final entriesModel = Provider.of<EntriesModel>(context, listen: false);

      // If this screen is called without an Entry object passed as a parameter,
      // Treats like a new entry,
      // Otherwise get the existing values and display them and,
      // Update them if those values are updated
      if (widget.entry == null) {
        entriesModel.addEntry(title, content, image);

        // Navigate back after adding the entry
        Navigator.pop(context);
        _showSnackBar(context, 'New entry added successfully.');
      } else {
        // Update method
        // TODO: "widget.entry!.entry_id - 1" -- This should be changed when Future Provider is used, because then index starts from 1 instead of 0
        entriesModel.editEntry(
            widget.entry!.entry_id - 1, title, content, image);

        // Navigate back after adding/updating the entry
        Navigator.pop(context);
        _showSnackBar(context,
            '[ Entry ID: ${widget.entry!.entry_id - 1} ] Updated successfully.');
      }
    } else {
      _showSnackBar(context, 'Title and content are required.');
    }
  }

  // Image picker functionality
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      _showSnackBar(context, 'Failed to pick image: $e');
    }
  }

  // Function to clear the image
  void clearImage() {
    setState(() {
      image = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = '';
    _contentController.text = '';
    // Used for the update method
    // Check if an Entry object is passed
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      image = widget.entry!.image;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.entry == null ? 'Add Entry' : 'Update Entry',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: CustomColors.olive,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: CustomColors.background,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(2),
                                    bottomRight: Radius.circular(2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Text('Title'),
                                        ),
                                      ),
                                    ),
                                    ElevatedButtonWidget(
                                      child: Text('Clear'),
                                      width: 50,
                                      height: 30,
                                      borderRadius: 2,
                                      onPressed: () => _titleController.clear(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget(
                                maxLength: 50,
                                hintText: 'Trip to Kandy',
                                controller: _titleController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(2),
                                    bottomRight: Radius.circular(2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Text('Content'),
                                        ),
                                      ),
                                    ),
                                    ElevatedButtonWidget(
                                      child: Text('Clear'),
                                      width: 50,
                                      height: 30,
                                      borderRadius: 2,
                                      onPressed: () =>
                                          _contentController.clear(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget(
                                maxLines: 15,
                                hintText: 'My friends and I went to Kandy...',
                                controller: _contentController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(2),
                                    bottomRight: Radius.circular(2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Text('Add a photo'),
                                        ),
                                      ),
                                    ),
                                    ElevatedButtonWidget(
                                      child: Text('Clear'),
                                      width: 50,
                                      height: 30,
                                      borderRadius: 2,
                                      onPressed: () => clearImage(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: image != null
                                        ? Image.file(image!,
                                            fit: BoxFit.fitWidth)
                                        : Text(
                                            'Choose an image from your gallery.\nYou can leave it blank.',
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                  const SizedBox(height: 15),
                                  ElevatedButtonWidget(
                                    child: Text('Gallery'),
                                    width: 150,
                                    height: 35,
                                    borderRadius: 2,
                                    onPressed: () =>
                                        pickImage(ImageSource.gallery),
                                  ),
                                  ElevatedButtonWidget(
                                    child: Text('Camera'),
                                    width: 150,
                                    height: 35,
                                    borderRadius: 2,
                                    onPressed: () =>
                                        pickImage(ImageSource.camera),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ElevatedButtonWidget(
                  child: Text(
                    widget.entry == null ? 'Add Entry' : 'Update Entry',
                    style: TextStyle(fontSize: 16),
                  ),
                  width: 100,
                  height: 50,
                  borderRadius: 2,
                  onPressed: () => onSubmit(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}