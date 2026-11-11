import '../models/user.dart';

/// Abstraksi repository untuk mengelola data pengguna.
///
/// Interface ini mendefinisikan kontrak untuk operasi data pengguna.
/// Implementasi konkretnya ada di [UserRepositoryImpl].
abstract class UserRepository {
  /// Mengambil daftar semua pengguna.
  Future<List<User>> getUsers();

  /// Mengambil pengguna berdasarkan [id].
  Future<User> getUserById(int id);
}
