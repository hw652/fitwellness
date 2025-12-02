import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_wellness/core/models/community_post.dart';

class CommunityRepository {
  static const String _storageKey = 'community_posts';

  // Mock Data (as seen in original screen)
  final List<CommunityPost> _mockPosts = [
    CommunityPost(
      id: 'mock_1',
      username: '운동매니아',
      userImage:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCNAD1uHqmyTGJdLZKsLyLAYBPEzYe9R_yigBzwSfLjl1KV0s1ZUDYL2_Tim0ow06-fHsq1Nau-opYOrAsyd60hnMdFtEY3vbEh12vUIWZYq5fwa5MtE_4uDq5sQ7l35j_Mbg4hbaCF8JszMUG38x6p4vDYEMma7p5uQ_3r7z9hc7TOBt1Xv-nvG04MwlGeTJ_R2odoJ1zo4Dy6o6FBWG7baEjp4aGqgWNVK0Wnc_C1Gauv91OiwQzIr5MamxmfyKEOgNSyQP-mqZOU',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      tag: '운동일지',
      content: '오늘 오운완! 하체 운동 루틴 공유합니다. 다들 득근하세요! 🔥',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCnfloTdMgfwA8ZAWFT4bbolWEypWvRdLkbSY3wel1_XFVOmtL6e68wQNvbNsWtXAHp2HyqAa3u4jJvsPgs9IEO-F05DPi7tZIhKvKX0OhO1ZqV_hRuDYi51qLTHDfeCTYhWn9RLuC9eF1BcTvu_zE2LscMlQTTRApLuihX333myLQR2PEraUGn-eqPbgNwzWYYQWxXa4b0jyQLCIRmACcCgQAK6iYS67txoY1qDxufCsiwfQFla_XmgPI0jr3Q84sEJaLFaO9-FDOI',
      likes: 15,
      comments: 3,
    ),
    CommunityPost(
      id: 'mock_2',
      username: '다이어터',
      userImage:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBUi4sQ2TwhkYrxlSEyZAdOeKLjQdgAr1YvgDuc1FkirmvwHgRkVfXEThv7UkQ0xkYg57q-9Lo3NYBMzCb2c-m5rxKRnfIA8k4fUprkLd8jMS38Ld18Z6guTdfJayMKamV8MUWEm2GNWmmFgckjTnVAffBDSFZE-7um7b6GL-sxo9181Vq_33gGziyQUyPfijnmIcgr8Ux6U1Xt1sfpx_9y3q0XDYMzyDGlzA1iWcERnK9QV8zXr8vAwpgwhVu0IAKlCVR_wOIme30W',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      tag: '식단공유',
      content: '점심으로 먹은 닭가슴살 샐러드! 드레싱 추천 받아요. 🥗',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDMYwUFKIJ1y7XnYzyR75M438Kfqu3bfsybbeuGV27-csXZSYMWvfEka_BGwbcoWoL9ga1s5yJOUT1h-60iE1Ww6P3RzLCvbbfkjxfLnpOHQ9ZrJgaK-iLTsEvbzyo_RrDS-_lP1WNvxbQy8PK98wk20coDWFy3u-_L9KtqXXqnOPr7Niv_Al2Xu1ZufhHvSuhqcTm7qvlrTFdaHOfSWrfJHNMMYW2Dto5ud0VQw5xJ3UhXwO4RW-Eo2FtDLBvEoSnKh5N2OC4fh5g3',
      likes: 28,
      comments: 5,
    ),
    CommunityPost(
      id: 'mock_3',
      username: '헬린이',
      userImage:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB4kguom_vAI_3N3p-zVQifWeCkzqcjMIMZuRqckbUY7xMmZaoLHDuANaoszLPxWZM70IGlNR6Eh6FGrDnqsHwlHWaU4fU_vDABOoJ7pYPKSq3hIC1cJuBcPK5st56txV_1ajRwT83PeP1nmnfVbhF_y659-uxUERFAzXhTQPDYWAB8kXMGPTryo-4M8Dd84RxuZnhvvJxUTm2ueyNSYnSiq5gkc5oRxYJPrDfrZHVYgPNAroPbLpyIsxA3Zx40tfTBhnuYapJmYNMY',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      tag: '질문있어요',
      content: '벤치프레스 할 때 어깨 통증이 있는데, 자세 문제일까요? 조언 부탁드립니다!',
      likes: 9,
      comments: 7,
    ),
  ];

  Future<List<CommunityPost>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString(_storageKey);

    List<CommunityPost> localPosts = [];
    if (postsJson != null) {
      final List<dynamic> decodedList = jsonDecode(postsJson);
      localPosts = decodedList
          .map((item) => CommunityPost.fromJson(item))
          .toList();
    }

    // Return local posts (newest first usually if prepended) followed by mock posts
    // Assuming local posts are added to the front of the list
    return [...localPosts, ..._mockPosts];
  }

  Future<void> savePost(CommunityPost post) async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString(_storageKey);

    List<CommunityPost> currentPosts = [];
    if (postsJson != null) {
      final List<dynamic> decodedList = jsonDecode(postsJson);
      currentPosts = decodedList
          .map((item) => CommunityPost.fromJson(item))
          .toList();
    }

    // Add new post to the beginning
    currentPosts.insert(0, post);

    final String encodedList = jsonEncode(
      currentPosts.map((p) => p.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encodedList);
  }

  Future<String?> saveImageLocally(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = 'post_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newImage = await imageFile.copy('$path/$fileName');
      return newImage.path;
    } catch (e) {
      // Error saving image: $e
      return null;
    }
  }
}
