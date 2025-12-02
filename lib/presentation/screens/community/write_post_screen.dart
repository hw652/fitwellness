import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_wellness/core/config/app_theme.dart';
import 'package:team_wellness/core/data/community_repository.dart';
import 'package:team_wellness/core/models/community_post.dart';
import 'package:uuid/uuid.dart';

class WritePostScreen extends StatefulWidget {
  const WritePostScreen({super.key});

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final CommunityRepository _repository = CommunityRepository();
  final FocusNode _focusNode = FocusNode();
  String _selectedTag = '운동일지';
  final List<String> _tags = ['운동일지', '식단공유', '질문있어요', '자유글'];
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('카메라로 촬영'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _savePost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    String? localImagePath;
    if (_selectedImage != null) {
      localImagePath = await _repository.saveImageLocally(_selectedImage!);
    }

    final newPost = CommunityPost(
      id: const Uuid().v4(),
      username: '나', // Currently hardcoded as 'Me'
      userImage: 'https://via.placeholder.com/150', // Placeholder for current user
      createdAt: DateTime.now(),
      tag: '#$_selectedTag',
      content: _contentController.text,
      imageUrl: localImagePath,
      isLocalImage: localImagePath != null,
      likes: 0,
      comments: 0,
    );

    await _repository.savePost(newPost);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      context.pop(true); // Return true to signal refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '글쓰기',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _savePost,
              child: Text(
                '완료',
                style: TextStyle(
                  color: appColors?.green ?? Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.1)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag Selection
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tags.map((tag) {
                        final isSelected = _selectedTag == tag;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedTag = tag;
                                });
                              }
                            },
                            selectedColor: appColors?.mint ?? const Color(0xFF30e89c),
                            backgroundColor: colorScheme.surface,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : colorScheme.onSurface.withValues(alpha: 0.7),
                              fontWeight: FontWeight.bold,
                            ),
                            side: isSelected
                                ? BorderSide.none
                                : BorderSide(
                                    color: colorScheme.outline.withValues(alpha: 0.2),
                                  ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Content Input
                  TextField(
                    controller: _contentController,
                    focusNode: _focusNode,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: _focusNode.hasFocus ? '' : '어떤 이야기를 나누고 싶으신가요?\n자유롭게 작성해주세요.',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.3), // Light gray hint
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Preview (if selected)
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Image Attachment Placeholder
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outline.withValues(alpha: 0.2),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_selectedImage != null ? 1 : 0}/10',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
