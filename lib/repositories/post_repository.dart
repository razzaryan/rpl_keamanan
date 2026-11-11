import '../models/post.dart';

/// Abstraksi repository untuk mengelola data Post (Latihan 1).
abstract class PostRepository {
  /// Mengambil semua postingan dari API.
  Future<List<Post>> getPosts();
}
