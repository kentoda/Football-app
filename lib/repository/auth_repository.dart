import 'package:firebase_auth/firebase_auth.dart';

// 認証系の処理
class AuthRepository {
  static AuthRepository? _instance;
  AuthRepository._();
  static AuthRepository? get instance {
    if (_instance == null) {
      _instance = AuthRepository._();
    }
    return _instance;
  }

  final _auth = FirebaseAuth.instance;

  /// ログイン
  Future<User?> login({required String email, required String password}) async {
    UserCredential firebaseUser =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("successfully");
    return firebaseUser.user;
  }

  /// 新規登録
  Future<User?> signUp(
      {required String email, required String password}) async {
    final firebaseUser =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return firebaseUser.user;
  }

  /// サインアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// パスワード再設定
  Future<void> resetPassword({
    required String email,
  }) async {
    final firebaseUser = await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  }

  /// ログイン中Firebaseユーザ-
  User? get firebaseUser => _auth.currentUser;

  /// ログイン中かどうか
  bool get isLogin => _auth.currentUser != null;
}
