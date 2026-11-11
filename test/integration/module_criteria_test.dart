import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rpl_keamanan/config/app_config.dart';
import 'package:rpl_keamanan/repositories/post_repository_impl.dart';
import 'package:rpl_keamanan/repositories/user_repository_impl.dart';
import 'package:rpl_keamanan/services/api_service.dart';

void main() {
  setUpAll(() {
    dotenv.loadFromString(envString: '''
BASE_URL=https://jsonplaceholder.typicode.com
API_KEY=test_api_key_solid_123
''');
  });

  group('Kriteria Modul & Keamanan Code Verification', () {
    test('1. AppConfig memuat environment variable dengan benar', () {
      expect(AppConfig.baseUrl, equals('https://jsonplaceholder.typicode.com'));
      expect(AppConfig.apiKey, equals('test_api_key_solid_123'));
      expect(AppConfig.isConfigured(), isTrue);
      expect(AppConfig.timeoutSeconds, equals(10));
    });

    test('2. ApiService menyematkan header X-API-Key dan URL dinamis', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('jsonplaceholder.typicode.com/users'));
        expect(request.headers['X-API-Key'], equals('test_api_key_solid_123'));
        expect(request.headers['Content-Type'], equals('application/json'));
        return http.Response('[{"id": 1, "name": "Leanne Graham", "username": "Bret", "email": "Sincere@april.biz"}]', 200);
      });

      final api = ApiService(client: mockClient);
      final users = await api.getUsers();
      expect(users.length, equals(1));
      expect(users.first.name, equals('Leanne Graham'));
    });

    test('3. UserRepositoryImpl berhasil mengambil list User', () async {
      final mockClient = MockClient((request) async {
        return http.Response('[{"id": 10, "name": "Clementina DuBuque", "username": "Moriah.Stanton", "email": "Rey.Padberg@karina.biz"}]', 200);
      });

      final repo = UserRepositoryImpl(apiService: ApiService(client: mockClient));
      final users = await repo.getUsers();
      expect(users.isNotEmpty, isTrue);
      expect(users.first.id, equals(10));
    });

    test('4. Latihan 1: PostRepositoryImpl mengambil list Post', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('/posts'));
        return http.Response('[{"userId": 1, "id": 1, "title": "Judul Post Modul", "body": "Isi post praktikum"}]', 200);
      });

      final repo = PostRepositoryImpl(apiService: ApiService(client: mockClient));
      final posts = await repo.getPosts();
      expect(posts.length, equals(1));
      expect(posts.first.title, equals('Judul Post Modul'));
    });

    test('5. Keamanan Git: .env terdaftar di .gitignore', () {
      final gitignore = File('.gitignore').readAsStringSync();
      expect(gitignore.contains('.env'), isTrue);
    });

    test('6. Keamanan Kredensial: Tidak ada hardcoded API Key di kode sumber lib/', () {
      final libDir = Directory('lib');
      final dartFiles = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        expect(content.contains('dummy_api_key_12345'), isFalse, reason: 'Ditemukan hardcoded API key di ${file.path}');
      }
    });
  });
}
